Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C797F3D2000
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGVIFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:05:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:50499 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhGVIFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 04:05:11 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-h0lw6uECM3eZnQ-erC7drw-1; Thu, 22 Jul 2021 09:45:44 +0100
X-MC-Unique: h0lw6uECM3eZnQ-erC7drw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 22 Jul 2021 09:45:42 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 22 Jul 2021 09:45:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yunsheng Lin' <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "nickhu@andestech.com" <nickhu@andestech.com>,
        "green.hu@gmail.com" <green.hu@gmail.com>,
        "deanbo422@gmail.com" <deanbo422@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "ojeda@kernel.org" <ojeda@kernel.org>,
        "ndesaulniers@gooogle.com" <ndesaulniers@gooogle.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 3/4] tools headers UAPI: add cpu_relax() implementation
 for x86 and arm64
Thread-Topic: [PATCH v2 3/4] tools headers UAPI: add cpu_relax()
 implementation for x86 and arm64
Thread-Index: AQHXfQ/RMbMxcgsnGkW4/hrjrWfzM6tN6faQgACviYCAABYlkA==
Date:   Thu, 22 Jul 2021 08:45:42 +0000
Message-ID: <9e76aac65edc4d88b141d79496ae3fdf@AcuMS.aculab.com>
References: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
 <1626747709-34013-4-git-send-email-linyunsheng@huawei.com>
 <5db490c6f264431e91bcdbb62fcf3be5@AcuMS.aculab.com>
 <9efd2434-feac-a385-f3c5-4a0fb0cc7706@huawei.com>
In-Reply-To: <9efd2434-feac-a385-f3c5-4a0fb0cc7706@huawei.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IEJld2FyZSwgSW50ZWwgaW5jcmVhc2VkIHRoZSBzdGFsbCBmb3IgJ3JlcCBub3AnIGluIHNv
bWUgcmVjZW50DQo+ID4gY3B1IHRvIElJUkMgYWJvdXQgMjAwIGN5Y2xlcy4NCj4gPg0KPiA+IFRo
ZXkgZXZlbiBkb2N1bWVudCB0aGF0IHRoaXMgbWlnaHQgaGF2ZSBhIGRldHJpbWVudGFsIGVmZmVj
dC4NCj4gPiBJdCBpcyBiYXNpY2FsbHkgZmFyIHRvbyBsb25nIGZvciB0aGUgc29ydCBvZiB0aGlu
ZyBpdCBtYWtlcw0KPiA+IHNlbnNlIHRvIGJ1c3ktd2FpdCBmb3IuDQo+IA0KPiBUaGFua3MgZm9y
IHRoZSBpbmZvOikNCj4gSSB3aWxsIGJlIGJld2FyZSBvZiB0aGF0IHdoZW4gcGxheWluZyB3aXRo
ICAncmVwIG5vcCcgaW4gbmV3ZXINCj4geDg2IGNwdS4NCg0KU2VlIDguNC43IFBhdXNlIExhdGVu
Y3kgaW4gU2t5bGFrZSBNaWNyb2FyY2hpdGVjdHVyZSBpbg0KSW50ZWzCriA2NCBhbmQgSUEtMzIg
QXJjaGl0ZWN0dXJlcyBPcHRpbWl6YXRpb24gUmVmZXJlbmNlIE1hbnVhbA0KDQpUaGUgbGF0ZW5j
eSBvZiBQQVVTRSBpbnN0cnVjdGlvbiBpbiBwcmlvciBnZW5lcmF0aW9uIG1pY3JvYXJjaGl0ZWN0
dXJlDQppcyBhYm91dCAxMCBjeWNsZXMsIHdoZXJlYXMgb24gU2t5bGFrZSBtaWNyb2FyY2hpdGVj
dHVyZSBpdCBoYXMgYmVlbg0KZXh0ZW5kZWQgdG8gYXMgbWFueSBhcyAxNDAgY3ljbGVzLg0KDQpB
biBlYXJsaWVyIHNlY3Rpb24gZG9lcyBleHBsYWluIHdoeSB5b3UgbmVlZCBwYXVzZSB0aG91Z2gu
DQpPbmUgb2YgaXRzIGVmZmVjdHMgaXMgdG8gc3RvcCB0aGUgY3B1IHNwZWN1bGF0aXZlbHkgZXhl
Y3V0aW5nDQptdWx0aXBsZSBpdGVyYXRpb25zIG9mIHRoZSB3YWl0IGxvb2sgLSBlYWNoIHdpdGgg
aXRzIG93bg0KcGVuZGluZyByZWFkIG9mIHRoZSBtZW1vcnkgbG9jYXRpb24gdGhhdCBpcyBiZWlu
ZyBsb29rZWQgYXQuDQpVbndpbmRpbmcgdGhhdCBpc24ndCBmcmVlIC0gYW5kIHdhcyBwYXJ0aWN1
bGFybHkgZXhwZW5zaXZlIG9uDQpQNCBOZXRidXJzdCAtIHdoYXQgYSBzdXJwcmlzZSwgdGhleSBy
YW4gZXZlcnl0aGluZyBleGNlcHQNCmJlbmNobWFyayBsb29rcyB2ZXJ5IHNsb3dseS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

