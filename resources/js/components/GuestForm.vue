<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    guest: {
        type: Object,
        default: () => ({ name: '', email: '', phone: '' })
    },
    bookingId: {
        type: Number,
        required: true
    }
});

const emit = defineEmits(['save', 'cancel']);

const formData = ref({ ...props.guest });
const errors = ref({});

// Watch for changes in props.guest to reset form data
watch(() => props.guest, (newGuest) => {
    formData.value = { ...newGuest };
    errors.value = {};
}, { deep: true });

const validateForm = () => {
    errors.value = {};
    let isValid = true;

    if (!formData.value.name || formData.value.name.trim() === '') {
        errors.value.name = ['Name is required'];
        isValid = false;
    }

    if (!formData.value.email || formData.value.email.trim() === '') {
        errors.value.email = ['Email is required'];
        isValid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.value.email)) {
        errors.value.email = ['Please enter a valid email address'];
        isValid = false;
    }

    return isValid;
};

const handleSubmit = async () => {
    if (!validateForm()) {
        return;
    }

    const guestData = {
        ...formData.value,
        booking_id: props.bookingId
    };

    emit('save', guestData);
};

const handleCancel = () => {
    emit('cancel');
};
</script>

<template>
    <form @submit.prevent="handleSubmit" class="space-y-4 p-4 bg-gray-50 rounded-lg">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                    Name *
                </label>
                <input
                    type="text"
                    id="name"
                    v-model="formData.name"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                    :class="{ 'border-red-500': errors.name }"
                    placeholder="Enter guest name"
                />
                <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name[0] }}</p>
            </div>
            
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                    Email *
                </label>
                <input
                    type="email"
                    id="email"
                    v-model="formData.email"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                    :class="{ 'border-red-500': errors.email }"
                    placeholder="Enter guest email"
                />
                <p v-if="errors.email" class="mt-1 text-sm text-red-600">{{ errors.email[0] }}</p>
            </div>
        </div>
        
        <div>
            <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">
                Phone
            </label>
            <input
                type="tel"
                id="phone"
                v-model="formData.phone"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                placeholder="Enter guest phone number"
            />
        </div>
        
        <div class="flex justify-end space-x-3">
            <button
                type="button"
                @click="handleCancel"
                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
            >
                Cancel
            </button>
            <button
                type="submit"
                class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
                {{ guest.id ? 'Update Guest' : 'Add Guest' }}
            </button>
        </div>
    </form>
</template>
