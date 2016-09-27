import React, { PropTypes } from 'react';
import compose from 'recompose/compose';
import { connect } from 'react-redux';
import OrderItem from './OrderItem';
import orderActions from './actions';
import withFetchingOnMount from '../../../common-client/fetch/withFetchingOnMount';
import withWindowTitle from '../app/withWindowTitle';

const OrderList = ({ orders }) => (
    <div className="row orders-list">
        <div className="col-xs-12">
            <div className="list-group">
                {orders.map(order => (
                    <OrderItem key={order.id} {...order} />
                ))}
            </div>
        </div>
    </div>
);

OrderList.propTypes = {
    orders: PropTypes.arrayOf(PropTypes.shape(OrderItem.propTypes)),
};

const dataStateSelector = state => state.order.list;
const loadingStateSelector = state => state.order.loading;
const mapStateToProps = state => ({ orders: state.order.list });

export default compose(
    withWindowTitle('Orders'),
    withFetchingOnMount(orderActions.list.request, dataStateSelector, null, loadingStateSelector),
    connect(mapStateToProps)
)(OrderList);
