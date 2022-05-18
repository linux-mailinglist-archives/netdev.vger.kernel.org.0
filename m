Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C66C52C58D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbiERVbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243175AbiERVbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:31:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67BC767D19
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 14:31:12 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-68-0CePKdYbPxG8ovDFIacySQ-1; Wed, 18 May 2022 22:31:09 +0100
X-MC-Unique: 0CePKdYbPxG8ovDFIacySQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 18 May 2022 22:31:08 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 18 May 2022 22:31:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "'mchan@broadcom.com'" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMA=
Date:   Wed, 18 May 2022 21:31:08 +0000
Message-ID: <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
In-Reply-To: <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMTggTWF5IDIwMjIgMTg6MjcNCi4uLi4NCj4gPiBJ
ZiBJIHJlYWQgL3N5cy9jbGFzcy9uZXQvZW0yL3N0YXRpc3RpY3MvcnhfcGFja2V0cyBldmVyeSBz
ZWNvbmQNCj4gPiBkZWxheWluZyB3aXRoOg0KPiA+ICAgc3lzY2FsbChTWVNfY2xvY2tfbmFub3Ns
ZWVwLCBDTE9DS19NT05PVE9OSUMsIFRJTUVSX0FCU1RJTUUsICZ0cywgTlVMTCk7DQo+ID4gYWJv
dXQgZXZlcnkgNDMgc2Vjb25kcyBJIGdldCBhIHplcm8gaW5jcmVtZW50Lg0KPiA+IFRoaXMgcmVh
bGx5IGRvZXNuJ3QgaGVscCENCj4gDQo+IEl0IGxvb2tzIGxpa2UgdGhlIHRnMyBkcml2ZXIgZmV0
Y2hlcyB0aGUgSC9XIHN0YXRzIG9uY2UgcGVyIHNlY29uZC4gSQ0KPiBndWVzcyB0aGF0IGlmIHlv
dSBmZXRjaCB0aGVtIHdpdGggdGhlIHNhbWUgcGVyaW9kIGFuZCB5b3UgYXJlIHVubHVja3kNCj4g
eW91IGNhbiByZWFkIHRoZSBzYW1lIHNhbXBsZSAyIGNvbnNlY3V0aXZlIHRpbWUuDQoNCkFjdHVh
bGx5IEkgdGhpbmsgdGhlIGhhcmR3YXJlIGlzIHdyaXRpbmcgdGhlbSB0byBrZXJuZWwgbWVtb3J5
DQpldmVyeSBzZWNvbmQuDQpUaGlzIHJlYWxseSBpc24ndCBpZGVhbCBmb3IgcGFja2V0IGNvdW50
cy4NCg0KLi4uDQo+IFdpdGggUlBTIGVuYWJsZWQgcGFja2V0IHByb2Nlc3NpbmcgZm9yIG1vc3Qg
cGFja2V0cyAodGhlIG9uZXMgc3RpcnJlZA0KPiB0byByZW1vdGUgQ1BVcykgaXMgdmVyeSBjaGVh
cCwgYXMgdGhlIHNrYiBhcmUgbW92ZWQgb3V0IG9mIHRoZSBOSUMgdG8gYQ0KPiBwZXIgQ1BVIHF1
ZXVlIGFuZCB0aGF0J3MgaXQuDQoNCkl0IG1heSBiZSAnY2hlYXAnLCBidXQgYXQgNDAwMDAwIGZy
YW1lcy9zZWMgaXQgYWRkcyB1cC4NClRoZSBwcm9jZXNzaW5nIGluIHRnMyBpcyByZWxhdGl2ZWx5
IGxpZ2h0IC0gZGVwZW5kaW5nIG9uDQp0aGUgYWN0dWFsIGhhcmR3YXJlLg0KRnJvbSB3aGF0IEkg
cmVtZW1iZXIgb2YgdGhlIGUxMDAwIGRyaXZlciB0aGF0IGlzIHdvcnNlLg0KDQo+IEluIHRoZW9y
eSBwYWNrZXRzIGNvdWxkIGJlIGRyZXBwZWQgYmVmb3JlIGluc2VydGluZyB0aGVtIGludG8gdGhl
IFJQUw0KPiBxdWV1ZSwgaWYgdGhlIGxhdHRlciBncm93IHRvIGJpZywgYnV0IHRoYXQgbG9va3Mg
dW5saWtlbHkuIFlvdSBjYW4gdHJ5DQo+IHJhaXNpbmcgbmV0ZGV2X21heF9iYWNrbG9nLCBqdXN0
IGluIGNhc2UuDQoNCkknbSBwcmV0dHkgc3VyZSBub3RoaW5nIGlzIGJlaW5nIGRyb3BwZWQgdGhh
dCBsYXRlIG9uLg0KVGhlIGNwdSBwcm9jZXNzaW5nIHRoZSBSUFMgZGF0YSBhcmUgbWF4aW5nIGF0
IGFyb3VuZCAxMyUgJ3NvZnRpbnQnDQppcyA1LjE4IC0gcXVpdGUgYSBsb3QgbW9yZSB0aGFuIHRo
ZSAxMCUgd2l0aCAzLjEwLg0KDQo+IGRyb3B3YXRjaCAob3IgcGVyZiByZWNvcmQgLWdhIC1lIHNr
YjprZnJlZV9za2IpIHNob3VsZCBwb2ludCB5b3Ugd2hlcmUNCj4gZXhhY3RseSB0aGUgcGFja2V0
cyBhcmUgZHJvcHBlZC4NCg0KSSdtIDk5LjklIHN1cmUgdGhlIHBhY2tldHMgYXJlbid0IGdldHRp
bmcgaW50byBza2IuDQpJIGNhbiBqdXN0IGFib3V0IHJ1biB2ZXJ5IHNlbGVjdGl2ZSBmdHJhY2Ug
dHJhY2VzLg0KVGhleSBkb24ndCBzZWVtIHRvIHNob3cgYW55dGhpbmcgYmVpbmcgZHJvcHBlZC4N
CkJ5IGl0IGlzIHZlcnkgZGlmZmljdWx0IHRvIHNlZSBhbnl0aGluZyBhdCB0aGVzZQ0KcGFja2V0
IHJhdGVzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

