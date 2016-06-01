import { after, describe, it } from 'selenium-webdriver/testing';
import driver from 'nodium/lib/driver';
import chai, { expect } from 'chai';
chai.use(require('chai-as-promised'));
chai.use(require('chai-webdriver')(driver));

describe('Products', function () { // eslint-disable-line func-names
    this.timeout(10000);

    it('user should see the product list', done => {
        driver
            .get('http://localhost:8081/#/products')
            .then(() => {
                expect('.product-item').dom.to.have.count(3, done);
            });
    });

    it('user should see the product details', done => {
        driver
            .get('http://localhost:8081/#/products/1')
            .then(() => {
                expect('.product-details').dom.to.be.visible();
                expect('.img-thumbnail').dom.to.be.visible();
                expect('.img-thumbnail').dom.to.have.attribute('src', 'http://lorempixel.com/400/400/');
                expect('h2').dom.to.have.text('abc');
                expect('.description').dom.to.have.text('John the zoo');
                expect('.price').dom.to.have.text('Price: $3.40');
            })
            .then(done)
            .catch(done);
    });

    after(() => {
        driver.quit();
    });
});
