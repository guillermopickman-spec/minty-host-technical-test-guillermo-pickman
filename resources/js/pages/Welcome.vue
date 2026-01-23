<script setup>
import { Head } from '@inertiajs/vue3';
import { useI18n } from 'vue-i18n';
import moment from 'moment';
import { useMintyTestStore } from '../stores/minty-test';
import { onMounted, ref, computed } from 'vue';
import GuestForm from '../components/GuestForm.vue';

const { t } = useI18n();
const store = useMintyTestStore();

// State for guest management
const editingGuest = ref(null);
const showAddForm = ref(false);
const selectedBookingId = ref(null);
const searchQuery = ref('');

onMounted(() => {
    store.getBookings();
});

const formatDate = (date) => {
    return moment(date).format('MMM D, YYYY');
};

const getStatusColor = (status) => {
    if (!status) return 'bg-gray-100 text-gray-800';
    return status === 'confirmed' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';
};

const handleAddGuest = (bookingId) => {
    selectedBookingId.value = bookingId;
    editingGuest.value = null;
    showAddForm.value = true;
};

const handleEditGuest = (guest) => {
    editingGuest.value = guest;
    selectedBookingId.value = guest.booking_id;
    showAddForm.value = true;
};

const handleDeleteGuest = async (guestId) => {
    if (confirm('Are you sure you want to delete this guest?')) {
        try {
            await store.deleteGuest(guestId);
        } catch (error) {
            alert('Failed to delete guest: ' + error.message);
        }
    }
};

const handleSaveGuest = async (guestData) => {
    try {
        if (editingGuest.value) {
            await store.updateGuest(editingGuest.value.id, guestData);
        } else {
            await store.createGuest(guestData);
        }
        showAddForm.value = false;
        editingGuest.value = null;
        selectedBookingId.value = null;
    } catch (error) {
        // Error is handled in the store
    }
};

const handleCancelForm = () => {
    showAddForm.value = false;
    editingGuest.value = null;
    selectedBookingId.value = null;
};

// Computed property to filter bookings by guest name
const filteredBookings = computed(() => {
    // 1. Safety check: if bookings doesn't exist yet, return empty array
    if (!store.bookings) return [];

    // 2. Safety check: ensure search.value isn't null/undefined before trimming
    const term = (searchQuery.value || '').toString().trim().toLowerCase();

    if (!term) return store.bookings;

    return store.bookings.filter(booking => {
        // 3. Use Optional Chaining (?.) for EVERYTHING
        if (!booking.guests) return false;
        
        return booking.guests.some(guest => {
            const guestName = guest.name?.toLowerCase() || '';
            const guestEmail = guest.email?.toLowerCase() || '';
            
            return guestName.includes(term) || guestEmail.includes(term);
        });
    });
});

// Computed property for paginated bookings
const paginatedBookings = computed(() => {
    // Safety check: ensure search.value isn't null/undefined before trimming
    const searchTerm = (searchQuery.value || '').toString().trim();
    
    if (searchTerm) {
        // If searching, don't paginate - show all filtered results
        return filteredBookings.value;
    }
    return store.paginatedBookings;
});

// Computed property for pagination info
const paginationInfo = computed(() => {
    // Safety check: ensure search.value isn't null/undefined before trimming
    const searchTerm = (searchQuery.value || '').toString().trim();
    
    if (searchTerm) {
        return `Showing ${filteredBookings.value.length} of ${store.totalBookings} bookings`;
    }
    const start = (store.currentPage - 1) * store.itemsPerPage + 1;
    const end = Math.min(store.currentPage * store.itemsPerPage, store.totalBookings);
    return `Showing ${start}-${end} of ${store.totalBookings} bookings`;
});
</script>

<template>
    <Head title="Minty Test 2026" />

    <div v-if="store.bookings" class="min-h-screen bg-gray-50">
        <!-- Header -->
        <div class="bg-white shadow-sm border-b">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <img src="/images/minty-logo.png" alt="minty" class="h-12 w-auto" />
                        <div>
                            <h1 class="text-2xl font-bold text-gray-900">Minty Host</h1>
                            <p class="text-sm text-gray-600">Guest Management System</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-gray-600">Total Bookings: {{ store.totalBookings }}</p>
                        <p class="text-sm text-gray-600">Total Guests: {{ store.totalGuests }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Loading State -->
            <div v-if="store.loading" class="flex justify-center py-8">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
            </div>

            <!-- Error State -->
            <div v-if="store.error" class="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
                <p class="text-red-600">{{ store.error }}</p>
            </div>

            <!-- Search Bar -->
            <div class="mb-6">
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <input
                        v-model="searchQuery"
                        type="text"
                        class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500"
                        placeholder="Search guests by name or email..."
                    />
                </div>
            </div>

            <!-- Booking Grid -->
            <div v-if="!store.loading && paginatedBookings.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div v-for="booking in paginatedBookings" :key="booking.id" class="bg-white rounded-lg shadow-sm border">
                    <!-- Booking Header -->
                    <div class="p-6 border-b">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-lg font-semibold text-gray-900">Booking #{{ booking.id }}</h3>
                                <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getStatusColor(booking.status)]">
                                    {{ booking.status }}
                                </span>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-600">Check-in</p>
                                <p class="font-medium">{{ formatDate(booking.checkin_at) }}</p>
                            </div>
                        </div>
                        <div class="mt-2">
                            <p class="text-sm text-gray-600">Check-out</p>
                            <p class="font-medium">{{ formatDate(booking.checkout_at) }}</p>
                        </div>
                    </div>

                    <!-- Guests Section -->
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-md font-medium text-gray-900">Guests</h4>
                            <button
                                @click="handleAddGuest(booking.id)"
                                class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                            >
                                + Add Guest
                            </button>
                        </div>

                        <!-- Guest List -->
                        <div v-if="booking.guests && booking.guests.length > 0" class="space-y-3">
                            <div v-for="guest in booking.guests" :key="guest.id" class="flex items-center justify-between p-3 bg-gray-50 rounded-md">
                                <div>
                                    <p class="font-medium text-gray-900">{{ guest.name }}</p>
                                    <p class="text-sm text-gray-600">{{ guest.email }}</p>
                                    <p v-if="guest.phone" class="text-sm text-gray-600">{{ guest.phone }}</p>
                                </div>
                                <div class="flex space-x-2">
                                    <button
                                        @click="handleEditGuest(guest)"
                                        class="inline-flex items-center px-2 py-1 border border-gray-300 text-sm font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                    >
                                        Edit
                                    </button>
                                    <button
                                        @click="handleDeleteGuest(guest.id)"
                                        class="inline-flex items-center px-2 py-1 border border-transparent text-sm font-medium rounded text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                                    >
                                        Delete
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- No Guests Message -->
                        <div v-else class="text-center py-4 text-gray-500 border-2 border-dashed border-gray-300 rounded-md">
                            No guests added yet. Click "Add Guest" to get started.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-if="!store.loading && store.bookings.length === 0" class="text-center py-12">
                <div class="text-gray-500">No bookings found.</div>
                <p class="text-sm text-gray-400 mt-2">Please check your database or API connection.</p>
            </div>

            <!-- Pagination Controls -->
            <div v-if="!((searchQuery.value || '').toString().trim()) && store.totalPages > 1" class="flex items-center justify-between mt-8">
                <div class="text-sm text-gray-700">
                    {{ paginationInfo }}
                </div>
                <div class="flex space-x-2">
                    <button
                        @click="store.setPage(store.currentPage - 1)"
                        :disabled="!store.hasPrevPage"
                        class="px-3 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        Previous
                    </button>
                    <span class="px-3 py-2 text-sm text-gray-700">
                        Page {{ store.currentPage }} of {{ store.totalPages }}
                    </span>
                    <button
                        @click="store.setPage(store.currentPage + 1)"
                        :disabled="!store.hasNextPage"
                        class="px-3 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        Next
                    </button>
                </div>
            </div>
        </div>

        <!-- Guest Form Modal -->
        <div v-if="showAddForm" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
            <div class="relative top-20 mx-auto p-5 border w-full max-w-2xl shadow-lg rounded-md bg-white">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-900">
                        {{ editingGuest ? 'Edit Guest' : 'Add New Guest' }}
                    </h3>
                    <button
                        @click="handleCancelForm"
                        class="text-gray-400 hover:text-gray-600"
                    >
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>
                <GuestForm
                    :guest="editingGuest || {}"
                    :booking-id="selectedBookingId"
                    @save="handleSaveGuest"
                    @cancel="handleCancelForm"
                />
            </div>
        </div>
    </div>
</template>
