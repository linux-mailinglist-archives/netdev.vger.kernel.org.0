Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA24E6E7B
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 08:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358494AbiCYHFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 03:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357530AbiCYHFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 03:05:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65F7A6C934
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:04:00 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-236--MPWl_J_M3qEDt7zHdpShQ-1; Fri, 25 Mar 2022 07:03:57 +0000
X-MC-Unique: -MPWl_J_M3qEDt7zHdpShQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 25 Mar 2022 07:03:56 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 25 Mar 2022 07:03:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'NeilBrown' <neilb@suse.de>, Haowen Bai <baihaowen@meizu.com>
CC:     "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: RE: [PATCH] SUNRPC: Increase size of servername string
Thread-Topic: [PATCH] SUNRPC: Increase size of servername string
Thread-Index: AQHYP+2Bp/ily4quQUeZW4BP4EodNKzPqMOggAADaSA=
Date:   Fri, 25 Mar 2022 07:03:56 +0000
Message-ID: <a717757cb2cb4f32afad046ce2f45117@AcuMS.aculab.com>
References: <1648103566-15528-1-git-send-email-baihaowen@meizu.com>
 <164817399413.6096.7103093569920914714@noble.neil.brown.name>
 <8723baf426ff4c7fb2027b86aa01fe70@AcuMS.aculab.com>
In-Reply-To: <8723baf426ff4c7fb2027b86aa01fe70@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDI1IE1hcmNoIDIwMjIgMDY6NTMNCj4gDQo+IEZy
b206IE5laWxCcm93bg0KPiA+IFNlbnQ6IDI1IE1hcmNoIDIwMjIgMDI6MDcNCj4gPg0KPiA+IE9u
IFRodSwgMjQgTWFyIDIwMjIsIEhhb3dlbiBCYWkgd3JvdGU6DQo+ID4gPiBUaGlzIHBhdGNoIHdp
bGwgZml4IHRoZSB3YXJuaW5nIGZyb20gc21hdGNoOg0KPiA+ID4NCj4gPiA+IG5ldC9zdW5ycGMv
Y2xudC5jOjU2MiBycGNfY3JlYXRlKCkgZXJyb3I6IHNucHJpbnRmKCkgY2hvcHMgb2ZmDQo+ID4g
PiB0aGUgbGFzdCBjaGFycyBvZiAnc3VuLT5zdW5fcGF0aCc6IDEwOCB2cyA0OA0KPiA+ID4NCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IEhhb3dlbiBCYWkgPGJhaWhhb3dlbkBtZWl6dS5jb20+DQo+ID4g
PiAtLS0NCj4gPiA+ICBuZXQvc3VucnBjL2NsbnQuYyB8IDIgKy0NCj4gPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0t
Z2l0IGEvbmV0L3N1bnJwYy9jbG50LmMgYi9uZXQvc3VucnBjL2NsbnQuYw0KPiA+ID4gaW5kZXgg
YzgzZmU2MS4uNmUwMjA5ZSAxMDA2NDQNCj4gPiA+IC0tLSBhL25ldC9zdW5ycGMvY2xudC5jDQo+
ID4gPiArKysgYi9uZXQvc3VucnBjL2NsbnQuYw0KPiA+ID4gQEAgLTUyNiw3ICs1MjYsNyBAQCBz
dHJ1Y3QgcnBjX2NsbnQgKnJwY19jcmVhdGUoc3RydWN0IHJwY19jcmVhdGVfYXJncyAqYXJncykN
Cj4gPiA+ICAJCS5zZXJ2ZXJuYW1lID0gYXJncy0+c2VydmVybmFtZSwNCj4gPiA+ICAJCS5iY194
cHJ0ID0gYXJncy0+YmNfeHBydCwNCj4gPiA+ICAJfTsNCj4gPiA+IC0JY2hhciBzZXJ2ZXJuYW1l
WzQ4XTsNCj4gPiA+ICsJY2hhciBzZXJ2ZXJuYW1lWzEwOF07DQo+ID4NCj4gPiBJdCB3b3VsZCBi
ZSBtdWNoIG5pY2VyIHRvIHVzZSBVTklYX1BBVEhfTUFYDQo+IA0KPiBOb3Qgb24tc3RhY2suLi4u
DQoNCk9rIEkgbG9va2VkIHRoZSBjb25zdGFudCB1cCAtIGl0IGlzIDEwOC4NCk9UT0gganVzdCBs
b29raW5nIGF0IHRoZSBjb2RlIG1ha2VzIGl0IGxvb2sgbGlrZSBhIHZhbHVlDQp0aGF0IGlzIG11
Y2ggbGFyZ2VyIC0gbm90IGdvb2Qgb24gc3RhY2suDQpFdmVuIFtzaXplb2Ygc3VuLT5zdW5fcGF0
aF0gd291bGQgcHJvYmFibHkgYmUgYmV0dGVyLg0KQnV0IEkgZG9uJ3QgdGhpbmsgdGhlIGNvcHkg
aXMgbmVlZGVkIGF0IGFsbC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

