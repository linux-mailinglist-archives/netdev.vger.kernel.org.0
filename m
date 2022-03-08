Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD93A4D2478
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350817AbiCHWr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiCHWr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:47:26 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC3D45A091
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:46:28 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-268-kDfJIgcAOn-lgcIv_Roklg-1; Tue, 08 Mar 2022 22:46:25 +0000
X-MC-Unique: kDfJIgcAOn-lgcIv_Roklg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 8 Mar 2022 22:46:24 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 8 Mar 2022 22:46:24 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Thread-Topic: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Thread-Index: AQHYMzupXSXwX/KYxk6M6s+NBOrfjay2FJiQ
Date:   Tue, 8 Mar 2022 22:46:24 +0000
Message-ID: <c85c188f9074456e92e9c4f8d8290ec2@AcuMS.aculab.com>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
In-Reply-To: <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSG9yYXRpdSBWdWx0dXINCj4gU2VudDogMDggTWFyY2ggMjAyMiAyMjozMA0KPiANCj4g
VGhlIDAzLzA4LzIwMjIgMjI6MzYsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+DQo+ID4gPiAgc3Rh
dGljIGludCBsYW45NjZ4X3BvcnRfaW5qX3JlYWR5KHN0cnVjdCBsYW45NjZ4ICpsYW45NjZ4LCB1
OCBncnApDQo+ID4gPiAgew0KPiA+ID4gLSAgICAgdTMyIHZhbDsNCj4gPiA+ICsgICAgIHVuc2ln
bmVkIGxvbmcgdGltZSA9IGppZmZpZXMgKyB1c2Vjc190b19qaWZmaWVzKFJFQURMX1RJTUVPVVRf
VVMpOw0KPiA+ID4gKyAgICAgaW50IHJldCA9IDA7DQo+ID4gPg0KPiA+ID4gLSAgICAgcmV0dXJu
IHJlYWR4X3BvbGxfdGltZW91dF9hdG9taWMobGFuOTY2eF9wb3J0X2lual9zdGF0dXMsIGxhbjk2
NngsIHZhbCwNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFFT
X0lOSl9TVEFUVVNfRklGT19SRFlfR0VUKHZhbCkgJiBCSVQoZ3JwKSwNCj4gPiA+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJFQURMX1NMRUVQX1VTLCBSRUFETF9USU1F
T1VUX1VTKTsNCj4gPiA+ICsgICAgIHdoaWxlICghKGxhbl9yZChsYW45NjZ4LCBRU19JTkpfU1RB
VFVTKSAmDQo+ID4gPiArICAgICAgICAgICAgICBRU19JTkpfU1RBVFVTX0ZJRk9fUkRZX1NFVChC
SVQoZ3JwKSkpKSB7DQo+ID4gPiArICAgICAgICAgICAgIGlmICh0aW1lX2FmdGVyKGppZmZpZXMs
IHRpbWUpKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0ID0gLUVUSU1FRE9VVDsN
Cj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gPiA+ICsgICAgICAgICAgICAg
fQ0KPiA+DQo+ID4gRGlkIHlvdSB0cnkgc2V0dGluZyBSRUFETF9TTEVFUF9VUyB0byAwPyByZWFk
eF9wb2xsX3RpbWVvdXRfYXRvbWljKCkNCj4gPiBleHBsaWNpdGx5IHN1cHBvcnRzIHRoYXQuDQo+
IA0KPiBJIGhhdmUgdHJpZWQgYnV0IGl0IGRpZG4ndCBpbXByb3ZlLiBJdCB3YXMgdGhlIHNhbWUg
YXMgYmVmb3JlLg0KDQpIb3cgbWFueSB0aW1lcyByb3VuZCB0aGUgbG9vcCBpcyBpdCBnb2luZyA/
DQoNCkl0IG1pZ2h0IGJlIHRoYXQgYnkgdGhlIHRpbWUgcmVhZHhfcG9sbF90aW1lb3V0X2F0b21p
YygpDQpnZXRzIGFyb3VuZCB0byByZWFkaW5nIHRoZSByZWdpc3RlciB0aGUgZmlmbyBpcyBhY3R1
YWxseSByZWFkeS4NCg0KVGhlIHRoZXJlIGlzIHRoZSBkZWxheSBiZXR3ZWVuIGRldGVjdGluZyAn
cmVhZHknIGFuZCB3cml0aW5nDQp0aGUgbmV4dCBkYXRhLg0KVGhhdCBkZWxheSBtaWdodCBiZSBj
dW11bGF0aXZlIGFuZCBhZmZlY3QgcGVyZm9ybWFuY2UuDQoNCk9UT0ggc3Bpbm5pbmcgd2FpdGlu
ZyBmb3IgZmlmbyBzcGFjZSBpcyBqdXN0IHBsYWluIGhvcnJpZC4NClJlbWluZHMgbWUgb2YgM0M1
MDkgZHJpdmVycyA6LSkNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

