Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650D552D00
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbiFUI3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiFUI3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:29:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF73511C26
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:29:40 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-268-Vry1rg9xM9iWNfwB0fePKA-1; Tue, 21 Jun 2022 09:29:37 +0100
X-MC-Unique: Vry1rg9xM9iWNfwB0fePKA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 21 Jun 2022 09:29:36 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 21 Jun 2022 09:29:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jose Alonso' <joalonsof@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     'Eric Dumazet' <edumazet@google.com>
Subject: RE: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
Thread-Topic: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
Thread-Index: AQHYg3cHZx6N3hYII06ugHNzChs73a1Xof0ggAFgAICAAIMWwA==
Date:   Tue, 21 Jun 2022 08:29:36 +0000
Message-ID: <e9e7c7e188f941fca362bbe012014eec@AcuMS.aculab.com>
References: <24289408a3d663fa2efedf646b046eb8250772f1.camel@gmail.com>
         <6dacc318fcb1425e85168a6628846258@AcuMS.aculab.com>
 <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
In-Reply-To: <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zZSBBbG9uc28NCj4gU2VudDogMjEgSnVuZSAyMDIyIDAyOjE5DQo+IA0KPiANCj4g
T24gTW9uLCAyMDIyLTA2LTIwIGF0IDAzOjQ1ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
ID4NCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGF4X3NrYi0+dHJ1ZXNpemUgPSBwa3Rf
bGVuICsgc2l6ZW9mKHN0cnVjdCBza19idWZmKTsNCj4gPg0KPiA+IFlvdSd2ZSAnbG9zdCcgdGhp
cyBsaWUuDQo+ID4gSUlSQyB0aGUgJ3NrYicgYXJlIGFsbG9jYXRlZCB3aXRoIDY0ayBidWZmZXIg
c3BhY2UuDQo+ID4gSSdtIG5vdCBhdCBhbGwgc3VyZSBob3cgdGhlIGJ1ZmZlciBzcGFjZSBvZiBz
a2IgdGhhdCBhcmUgY2xvbmVkDQo+ID4gaW50byBtdWx0aXBsZSByeCBidWZmZXJzIGFyZSBzdXBw
b3NlZCB0byBiZSBhY2NvdW50ZWQgZm9yLg0KPiA+DQo+ID4gRG9lcyB0aGlzIGRyaXZlciBldmVy
IGNvcHkgdGhlIGRhdGEgZm9yIHNob3J0IGZyYW1lcz8NCj4gDQo+IFRoZSBkcml2ZXIgcmVjZWl2
ZXMgYSBza2Igd2l0aCBhIFVSQiAoZGV2LT5yeF91cmJfc2l6ZT0yNDU3NikNCj4gd2l0aCBOIHBh
Y2tldHMgYW5kIGRvIHNrYi0+Y2xvbmUgZm9yIHRoZSBOLTEgZmlyc3QgcGFja2V0cyBhbmQNCj4g
Zm9yIHRoZSBsYXN0IHJldHVybiB0aGUgc2tiIHJlY2VpdmVkLg0KPiBUaGUgdXNiIHRyYW5zZmVy
IHVzZXMgYnVsayBpbyBvZiA1MTIgYnl0ZXMgKGRldi0+bWF4cGFja2V0KS4NCj4gc2tiX2Nsb25l
IGNyZWF0ZXMgYSBuZXcgc2tfYnVmZiBzaGFyaW5nIHRoZSBzYW1lIHNrYi0+ZGF0YSBhdm9pZGlu
Zw0KPiBleHRyYSBjb3B5IG9mIHRoZSBwYWNrZXRzIGFuZCB0aGUgVVJCIGFyZWEgd2lsbCBiZSBy
ZWxlYXNlZCB3aGVuDQo+IGFsbCBwYWNrZXRzIHdlcmUgcHJvY2Vzc2VkIChyZWZlcmVuY2UgY291
bnQgPSAwKS4NCj4gVGhlIGxlbmd0aCBvZiByeCBxdWV1ZSBpcyBzZXR0ZWQgYnkgdXNibmV0Og0K
PiAjZGVmaW5lIE1BWF9RVUVVRV9NRU1PUlkgICAgICAgICg2MCAqIDE1MTgpDQo+IC4uLg0KPiAg
ICAgICAgIGNhc2UgVVNCX1NQRUVEX0hJR0g6DQo+ICAgICAgICAgICAgICAgICBkZXYtPnJ4X3Fs
ZW4gPSBNQVhfUVVFVUVfTUVNT1JZIC8gZGV2LT5yeF91cmJfc2l6ZTsNCj4gICAgICAgICAgICAg
ICAgIGRldi0+dHhfcWxlbiA9IE1BWF9RVUVVRV9NRU1PUlkgLyBkZXYtPmhhcmRfbXR1Ow0KPiAg
ICAgICAgICAgICAgICAgYnJlYWs7DQo+ICAgICAgICAgY2FzZSBVU0JfU1BFRURfU1VQRVI6DQo+
ICAgICAgICAgY2FzZSBVU0JfU1BFRURfU1VQRVJfUExVUzoNCj4gCQkuLi4NCj4gICAgICAgICAg
ICAgICAgIGRldi0+cnhfcWxlbiA9IDUgKiBNQVhfUVVFVUVfTUVNT1JZIC8gZGV2LT5yeF91cmJf
c2l6ZTsNCj4gICAgICAgICAgICAgICAgIGRldi0+dHhfcWxlbiA9IDUgKiBNQVhfUVVFVUVfTUVN
T1JZIC8gZGV2LT5oYXJkX210dTsNCj4gDQoNClRoYXQncyBhYm91dCB3aGF0IEkgcmVtZW1iZXIg
aXQgZG9pbmcgd2hlbiBJIGxvb2tlZCBhIGZldyB5ZWFycyBiYWNrLg0KSXQgaXMgaG9ycmlkLi4u
Lg0KSSBhbHNvIGVuZGVkIHVwIGZpbmRpbmcgcXVpdGUgYSBmZXcgYnVncyBpbiB0aGUgeGhjaSBk
cml2ZXIuDQoNClNvIHdoYXQgYWN0dWFsbHkgaGFwcGVucyBpcyBhIDkxMDgwIGJ5dGUgbGluZWFy
IHNrYiBpcyBhbGxvY2F0ZWQuDQpUaGlzIGhhcyBhICd0cnVlc2l6ZScgdGhhdCBkZXBlbmRzIG9u
IHRoZSBhbGxvY2F0b3IsIHByb2JhYmx5IDk2ay4NClRoZSB1c2IgZGF0YSAoYSBzZXF1ZW5jZSBv
ZiAxayBwYWNrZXRzIG9uIFVTQjMpIGlzIGNvcGllZCBpbnRvDQp0aGUgc2tiIGJ1ZmZlciBhcmVh
LCBtb3ZpbmcgdG8gdGhlIG5leHQgYnVmZmVyIGlmIGEgc2hvcnQgVVNCDQpidWZmZXIgaXMgcmVj
ZWl2ZWQuDQoNCkVhY2ggdGltZSB0aGUgc2tiIGlzIGNsb25lZCBlYWNoIGNvcHkgc3RpbGwgaGFz
IHRoZSBvcmlnaW5hbCAndHJ1ZXNpemUnLg0KU28gd2hlbiBxdWV1ZWQgb24gYSBzb2NrZXQgZWFj
aCB1c2UgOTZrKyBvZiB0aGUgcmVjZWl2ZSBidWZmZXIgc2l6ZS4NClRoaXMgaXMgYWJzb2x1dGVs
eSByaWdodCB3aGVuIG9ubHkgYSBzaW5nbGUgZXRoZXJuZXQgZnJhbWUgaXMgaW4NCnRoZSBVU0Ig
cGFja2V0IC0gZXZlbiBpZiBpdCBjb250YWlucyBvbmUgY2hhcmFjdGVyIG9mIGEgdGVybWluYWwg
c2Vzc2lvbi4NCkhvd2V2ZXIgaXQgd2lsbCBkZWZpbml0ZWx5IGJyZWFrIHRoZSB1c2VyIGV4cGVj
dGF0aW9ucy4NCg0KU2V0dGluZyBheF9za2ItPnRydWVzaXplIHRvIGEgc2hvcnQgbGVuZ3RoIGZp
eGVzIHRoZSAndXNlciBleHBlY3RhdGlvbicNCmJ1dCByZWFsbHkgYmxvYXRzIGtlcm5lbCBtZW1v
cnkgdXNlLg0KDQpNb3N0IGV0aGVybmV0IGRyaXZlcnMgbm93IHB1dCBidWZmZXJzIChub3Qgc2ti
KSBpbnRvIHRoZSByZWNlaXZlIHJpbmcNCmFuZCB3aWxsIGNvcHkgc2hvcnQgKDwxMDAgYnl0ZSkg
ZnJhbWVzIHNvIHRoYXQgdGhlIGJ1ZmZlcnMgY2FuIGJlDQpyZXVzZWQuDQoNCldpdGggOTBrIHNr
YiBjb3B5aW5nIGV2ZXJ5dGhpbmcgKGV4Y2VwdCBhIGJpZyBHUk8gcGFja2V0KSBpcw0KcHJvYmFi
bHkgdGhlIG9ubHkgc2FuZSB3YXkgdG8gYWNjb3VudCBmb3Iga2VybmVsIG1lbW9yeS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

