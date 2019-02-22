import css from '../css/app.scss'

import 'phoenix_html'
import 'bootstrap'

import socket from './socket';

import React from 'react';
import ReactDOM from 'react-dom';

const COMPONENTS = {
};

function initComponents() {
    [...document.querySelectorAll('[data-component]')].map(container => {
        const componentName = container.dataset.component;
        const component = COMPONENTS[componentName];
        if (!component) throw (`Unknown component ${componentName}`);

        const props = JSON.parse(container.dataset.props);
        const element = React.createElement(component, props);
        ReactDOM.render(element, container);
    });
}

document.addEventListener('DOMContentLoaded', function () {
    initComponents();
});
