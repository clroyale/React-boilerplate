import React from 'react';
import { Filter, List, TextField, EditButton, TextInput } from 'admin-on-rest/src/mui';

export const ProductFilter = (props) => (
    <Filter {...props}>
        <TextInput label="Search" source="reference" alwaysOn />
    </Filter>
);

export default (props) => (
    <List {...props} filter={ProductFilter}>
        <TextField label="reference" source="reference" />
        <TextField label="price" source="price" />
        <TextField label="width" source="width" />
        <TextField label="height" source="height" />
        <TextField label="stock" source="stock" />
        <EditButton basePath="/products" />
    </List>
);
