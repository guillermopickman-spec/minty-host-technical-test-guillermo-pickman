import { createInertiaApp } from '@inertiajs/vue3';
import createServer from '@inertiajs/vue3/server';
import { createPinia } from 'pinia';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createSSRApp, h } from 'vue';
import { renderToString } from 'vue/server-renderer';

import i18n from './i18n';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

createServer(
    (page) =>
        createInertiaApp({
            page,
            render: renderToString,
            title: (title) => title || appName,
            resolve: resolvePage,
            setup: ({ App, props, plugin }) => {
                const pinia = createPinia();

                return createSSRApp({ render: () => h(App, props) })
                    .use(plugin)
                    .use(pinia)
                    .use(i18n);
            },
        }),
    { cluster: true },
);

function resolvePage(name) {
    const pages = import.meta.glob('./pages/**/*.vue');

    return resolvePageComponent(`./pages/${name}.vue`, pages);
}
