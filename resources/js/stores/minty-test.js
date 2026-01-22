import { defineStore } from 'pinia';

export const useMintyTestStore = defineStore('minty-test', {
    state: () => ({
        testUser: 'Candidato/a',
        bookings: [],
        loading: false,
        error: null,
        currentPage: 1,
        itemsPerPage: 12,
        totalItems: 0,
    }),

    actions: {
        async getBookings() {
            try {
                this.loading = true;
                this.error = null;
                
                const response = await fetch('/api/bookings');

                if (!response.ok) {
                    throw new Error('Failed to fetch bookings');
                }

                const data = await response.json();
                this.bookings = data;
                this.totalItems = data.length;
            } catch (err) {
                this.error = err.message;
            } finally {
                this.loading = false;
            }
        },

        setPage(page) {
            this.currentPage = page;
        },

        setItemsPerPage(items) {
            this.itemsPerPage = items;
            this.currentPage = 1; // Reset to first page when changing items per page
        },

        async createGuest(guestData) {
            try {
                this.loading = true;
                this.error = null;

                const response = await fetch('/api/guests', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(guestData),
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || 'Failed to create guest');
                }

                const result = await response.json();
                
                // Update the booking with the new guest
                const bookingIndex = this.bookings.findIndex(b => b.id === guestData.booking_id);
                if (bookingIndex !== -1) {
                    if (!this.bookings[bookingIndex].guests) {
                        this.bookings[bookingIndex].guests = [];
                    }
                    this.bookings[bookingIndex].guests.push(result.guest);
                }

                return result;
            } catch (err) {
                this.error = err.message;
                throw err;
            } finally {
                this.loading = false;
            }
        },

        async updateGuest(id, guestData) {
            try {
                this.loading = true;
                this.error = null;

                const response = await fetch(`/api/guests/${id}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(guestData),
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || 'Failed to update guest');
                }

                const result = await response.json();
                
                // Update the guest in the booking
                this.bookings.forEach(booking => {
                    if (booking.guests) {
                        const guestIndex = booking.guests.findIndex(g => g.id === id);
                        if (guestIndex !== -1) {
                            booking.guests[guestIndex] = result.guest;
                        }
                    }
                });

                return result;
            } catch (err) {
                this.error = err.message;
                throw err;
            } finally {
                this.loading = false;
            }
        },

        async deleteGuest(id) {
            try {
                this.loading = true;
                this.error = null;

                const response = await fetch(`/api/guests/${id}`, {
                    method: 'DELETE',
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || 'Failed to delete guest');
                }

                // Remove the guest from the booking
                this.bookings.forEach(booking => {
                    if (booking.guests) {
                        const guestIndex = booking.guests.findIndex(g => g.id === id);
                        if (guestIndex !== -1) {
                            booking.guests.splice(guestIndex, 1);
                        }
                    }
                });

                return { message: 'Guest deleted successfully' };
            } catch (err) {
                this.error = err.message;
                throw err;
            } finally {
                this.loading = false;
            }
        },
    },

    getters: {
        totalBookings: (state) => state.bookings.length,
        totalGuests: (state) => {
            return state.bookings.reduce((total, booking) => {
                return total + (booking.guests ? booking.guests.length : 0);
            }, 0);
        },
        paginatedBookings: (state) => {
            const start = (state.currentPage - 1) * state.itemsPerPage;
            const end = start + state.itemsPerPage;
            return state.bookings.slice(start, end);
        },
        totalPages: (state) => {
            return Math.ceil(state.totalItems / state.itemsPerPage);
        },
        hasNextPage: (state) => {
            return state.currentPage < state.totalPages;
        },
        hasPrevPage: (state) => {
            return state.currentPage > 1;
        },
    },
});
