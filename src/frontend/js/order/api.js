/* globals API_URL */
import fetchFactory from '../../../isomorphic/fetch/fetch';

export const fetchOrders = fetchFactory(`${API_URL}/orders`);
export const fetchOrder = fetchFactory(`${API_URL}/orders`);
export const fetchNewOrder = fetchFactory(`${API_URL}/orders`, 'POST');
