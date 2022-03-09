Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFEB4D2CA1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiCIJ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiCIJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:59:01 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAB599A9BF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:58:02 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-197-9BvwLLeYNEeOm-asGhaVog-1; Wed, 09 Mar 2022 09:57:59 +0000
X-MC-Unique: 9BvwLLeYNEeOm-asGhaVog-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 9 Mar 2022 09:57:58 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 9 Mar 2022 09:57:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Thread-Topic: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Thread-Index: AQHYMzupXSXwX/KYxk6M6s+NBOrfjay2FJiQgACwQ4CAAAv90A==
Date:   Wed, 9 Mar 2022 09:57:57 +0000
Message-ID: <45a9f88b140d44af8522e7d8a6abcbbf@AcuMS.aculab.com>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <c85c188f9074456e92e9c4f8d8290ec2@AcuMS.aculab.com>
 <20220309091129.b5q3gtiuqlk5skka@soft-dev3-1.localhost>
In-Reply-To: <20220309091129.b5q3gtiuqlk5skka@soft-dev3-1.localhost>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogJ0hvcmF0aXUgVnVsdHVyJw0KPiBTZW50OiAwOSBNYXJjaCAyMDIyIDA5OjExDQo+IA0K
PiBUaGUgMDMvMDgvMjAyMiAyMjo0NiwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+DQo+ID4gRnJv
bTogSG9yYXRpdSBWdWx0dXINCj4gPiA+IFNlbnQ6IDA4IE1hcmNoIDIwMjIgMjI6MzANCj4gPiA+
DQo+ID4gPiBUaGUgMDMvMDgvMjAyMiAyMjozNiwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gPiA+
DQo+ID4gPiA+ID4gIHN0YXRpYyBpbnQgbGFuOTY2eF9wb3J0X2lual9yZWFkeShzdHJ1Y3QgbGFu
OTY2eCAqbGFuOTY2eCwgdTggZ3JwKQ0KPiA+ID4gPiA+ICB7DQo+ID4gPiA+ID4gLSAgICAgdTMy
IHZhbDsNCj4gPiA+ID4gPiArICAgICB1bnNpZ25lZCBsb25nIHRpbWUgPSBqaWZmaWVzICsgdXNl
Y3NfdG9famlmZmllcyhSRUFETF9USU1FT1VUX1VTKTsNCj4gPiA+ID4gPiArICAgICBpbnQgcmV0
ID0gMDsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IC0gICAgIHJldHVybiByZWFkeF9wb2xsX3RpbWVv
dXRfYXRvbWljKGxhbjk2NnhfcG9ydF9pbmpfc3RhdHVzLCBsYW45NjZ4LCB2YWwsDQo+ID4gPiA+
ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUVNfSU5KX1NUQVRVU19G
SUZPX1JEWV9HRVQodmFsKSAmIEJJVChncnApLA0KPiA+ID4gPiA+IC0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFJFQURMX1NMRUVQX1VTLCBSRUFETF9USU1FT1VUX1VTKTsN
Cj4gPiA+ID4gPiArICAgICB3aGlsZSAoIShsYW5fcmQobGFuOTY2eCwgUVNfSU5KX1NUQVRVUykg
Jg0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgIFFTX0lOSl9TVEFUVVNfRklGT19SRFlfU0VUKEJJ
VChncnApKSkpIHsNCj4gPiA+ID4gPiArICAgICAgICAgICAgIGlmICh0aW1lX2FmdGVyKGppZmZp
ZXMsIHRpbWUpKSB7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldCA9IC1FVElN
RURPVVQ7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ID4gPiA+
ICsgICAgICAgICAgICAgfQ0KPiA+ID4gPg0KPiA+ID4gPiBEaWQgeW91IHRyeSBzZXR0aW5nIFJF
QURMX1NMRUVQX1VTIHRvIDA/IHJlYWR4X3BvbGxfdGltZW91dF9hdG9taWMoKQ0KPiA+ID4gPiBl
eHBsaWNpdGx5IHN1cHBvcnRzIHRoYXQuDQo+ID4gPg0KPiA+ID4gSSBoYXZlIHRyaWVkIGJ1dCBp
dCBkaWRuJ3QgaW1wcm92ZS4gSXQgd2FzIHRoZSBzYW1lIGFzIGJlZm9yZS4NCj4gPg0KPiA+IEhv
dyBtYW55IHRpbWVzIHJvdW5kIHRoZSBsb29wIGlzIGl0IGdvaW5nID8NCj4gDQo+IEluIHRoZSB0
ZXN0cyB0aGF0IEkgaGF2ZSBkb25lLCBJIGhhdmUgbmV2ZXIgc2VlbiBlbnRlcmluZyBpbiB0aGUg
bG9vcC4NCg0KSW4gd2hpY2ggY2FzZSBJJ2QgZG8gYW4gaW5pdGlhbCBzdGF0dXMgY2hlY2sgYmVm
b3JlIGV2ZW4NCmZhZmZpbmcgd2l0aCAnamlmZmllcycuDQoNCkl0IG1pZ2h0IGV2ZW4gYmUgdGhh
dCB0aGUgc3RhdHVzIHJlYWQgaXMgc28gc2xvdyB0aGF0IHNwYWNlDQppcyBhbHdheXMgYXZhaWxh
YmxlIGJ5IHRoZSB0aW1lIGl0IGlzIHByb2Nlc3NlZC4NClBDSWUgcmVhZHMgY2FuIGJlIGhvcnJp
Ymx5IHNsb3cuDQpJbnRvIG91ciBmZ3BhIHRoZXkgZW5kIHVwIGJlaW5nIHNsb3dlciB0aGFuIG9s
ZCBJU0EgYnVzIGN5Y2xlcy4NClByb2JhYmx5IHNldmVyYWwgdGhvdXNhbmQgY3B1IGNsb2Nrcy4N
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCg==

