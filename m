Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334B453E397
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiFFH7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 03:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiFFH64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 03:58:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B19615728
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 00:58:53 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-73-mfL3pS3cOhmr6EtnnLsIdw-1; Mon, 06 Jun 2022 08:58:50 +0100
X-MC-Unique: mfL3pS3cOhmr6EtnnLsIdw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 6 Jun 2022 08:58:48 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 6 Jun 2022 08:58:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     Frederik Deweerdt <frederik.deweerdt@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
Thread-Topic: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown
 scenario
Thread-Index: AQHYdguKgdO0O+cjykaafLt/qHAria09qgMg///1QwCABGpjUA==
Date:   Mon, 6 Jun 2022 07:58:48 +0000
Message-ID: <748d3eab042345258b5d4f50eaa56104@AcuMS.aculab.com>
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
 <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
 <Ypfvs+VsNHWQKT6H@fractal.lan>
 <8362c86f9b004b449ad4105d8f7489e9@AcuMS.aculab.com>
 <CA+FuTSeqbu=MPdmOVSHBDy39ZxrHZUjgGmP4LhPXjWsfc_Qa+g@mail.gmail.com>
In-Reply-To: <CA+FuTSeqbu=MPdmOVSHBDy39ZxrHZUjgGmP4LhPXjWsfc_Qa+g@mail.gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAwMyBKdW5lIDIwMjIgMTQ6MzANCj4gDQo+
IE9uIEZyaSwgSnVuIDMsIDIwMjIgYXQgOToxOCBBTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdo
dEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IEZyZWRlcmlrIERld2VlcmR0IDxm
cmVkZXJpay5kZXdlZXJkdEBnbWFpbC5jb20+DQo+ID4gPiBTZW50OiAwMiBKdW5lIDIwMjIgMDA6
MDENCj4gPiA+ID4NCj4gPiA+ID4gQSBzb2NrZXQgbXVzdCBub3QgYmUgY2xvc2VkIHVudGlsIGFs
bCBjb21wbGV0aW9uIG5vdGlmaWNhdGlvbnMgaGF2ZQ0KPiA+ID4gPiBiZWVuIHJlY2VpdmVkLg0K
PiA+ID4gPg0KPiA+ID4gPiBDYWxsaW5nIHNodXRkb3duIGlzIGFuIG9wdGlvbmFsIHN0ZXAuIEl0
IG1heSBiZSBzdWZmaWNpZW50IHRvIHNpbXBseQ0KPiA+ID4gPiBkZWxheSBjbG9zZS4NCj4gPg0K
PiA+IFdoYXQgaGFwcGVucyBpZiB0aGUgcHJvY2VzcyBnZXRzIGtpbGxlZCAtIGVnIGJ5IFNJR1NF
R1Y/DQo+IA0KPiBUaGUgc2tiIGZyYWdzIGhvbGQgaW5kZXBlbmRlbnQgcmVmZXJlbmNlcyBvbiB0
aGUgcGFnZXMuIE9uY2Ugc2ticyBhcmUNCj4gZnJlZWQgb24gdHJhbnNtaXQgY29tcGxldGlvbiBv
ciBzb2NrZXQgcHVyZ2UgdGhlIHBhZ2VzIGFyZSByZWxlYXNlZCBpZg0KPiB0aGVyZSBhcmUgbm8g
b3RoZXIgcGFnZSByZWZlcmVuY2VzLg0KPiANCj4gT3RoZXJ3aXNlIHRoZXJlIGlzIG5vdGhpbmcg
emVyb2NvcHkgc3BlY2lmaWMgYWJvdXQgY2xvc2luZyBUQ1ANCj4gY29ubmVjdGlvbnMgd2hlbiBh
IHByb2Nlc3MgY3Jhc2hlcy4NCg0KU28gdGhlIHByb3Bvc2VkIHRleHQgZm9yIHRoZSBkb2N1bWVu
dGF0aW9uIGlzIGp1c3Qgd3JvbmcuDQoNClNvbWV0aGluZyB0aGF0IHNheXMgdGhhdCByZXRyYW5z
bWlzc2lvbnMgY2FuIHJlLXJlYWQgdGhlDQpwYWdlcyBhZnRlciB0aGUgc29ja2V0IGlzIGNsb3Nl
ZCB3b3VsZCBiZSBtb3JlIHJlbGV2YW50Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

