Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6985193DA3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgCZLI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:08:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44905 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728071AbgCZLI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:08:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-14-CLALoYrLOxepDcGv6nVzGw-1; Thu, 26 Mar 2020 11:08:52 +0000
X-MC-Unique: CLALoYrLOxepDcGv6nVzGw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 26 Mar 2020 11:08:52 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 26 Mar 2020 11:08:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'jeffrey.t.kirsher@intel.com'" <jeffrey.t.kirsher@intel.com>,
        "Network Development" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
CC:     "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>
Subject: RE: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Topic: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Index: AdXxfY9+FmJkPOq/QT2LrEdhM24vhgA0bfSABEOl6KA=
Date:   Thu, 26 Mar 2020 11:08:52 +0000
Message-ID: <ed99e7c34aab4b0fafa20fc449e77510@AcuMS.aculab.com>
References: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
 <c84d4055e13f30edf7b79086c9ed8d7d1fe6523b.camel@intel.com>
In-Reply-To: <c84d4055e13f30edf7b79086c9ed8d7d1fe6523b.camel@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmVmZiBLaXJzaGVyDQo+IFNlbnQ6IDA0IE1hcmNoIDIwMjAgMTg6MDQNCj4gT24gVHVl
LCAyMDIwLTAzLTAzIGF0IDE3OjA2ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gSW5z
dGVhZCBvZiBzcGlubmluZyB3YWl0aW5nIGZvciB0aGUgTUUgdG8gYmUgaWRsZSBkZWZlciB0aGUg
cmluZw0KPiA+IHRhaWwgdXBkYXRlcyB1bnRpbCBvbmUgb2YgdGhlIGZvbGxvd2luZzoNCj4gPiAt
IFRoZSBuZXh0IHVwZGF0ZSBmb3IgdGhhdCByaW5nLg0KPiA+IC0gVGhlIHJlY2VpdmUgZnJhbWUg
cHJvY2Vzc2luZy4NCj4gPiAtIFRoZSBuZXh0IHRpbWVyIHRpY2suDQo+ID4NCj4gPiBSZWR1Y2Ug
dGhlIGRlbGF5IGJldHdlZW4gY2hlY2tzIGZvciB0aGUgTUUgYmVpbmcgaWRsZSBmcm9tIDUwdXMN
Cj4gPiB0byB1dXMuDQo+ID4NCj4gPiBQYXJ0IGZpeCBmb3IgYmRjMTI1ZjcuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBMYWlnaHQgPGRhdmlkLmxhaWdodEBhY3VsYWIuY29tPg0KPiAN
Cj4gQWRkZWQgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcgbWFpbGluZyBsaXN0LCBz
byB0aGUgcmlnaHQNCj4gcGVvcGxlIGNhbiByZXZpZXcgeW91ciBwYXRjaC4NCg0KSSBkb24ndCBz
ZWUgYW55IHNpZ24gb2YgYW55b25lIGxvb2tpbmcgYXQgdGhpcy4NCklzIHRoZSBjb2RlIHNvIGJh
ZCBldmVyeW9uZSBoYXMgYnVyaWVkIHRoZWlyIGhlYWQgaW4gdGhlIHNhbmQ/DQoNCkFtIEkgcmln
aHQgaW4gdGhpbmtpbmcgdGhhdCB0aGUgYWN0dWFsIGhhcmR3YXJlIHByb2JsZW0gaXMNCnRoYXQg
UENJZSB3cml0ZXMgYXJlICdwb3N0ZWQnIGluIHRoZSBoYXJkd2FyZSBhbmQgdGhlbiBsb3N0DQpp
ZiB0aGUgTUUgZG9lcyBhIHdyaXRlIHdoaWxlIHRoZSBQQ0llIHdyaXRlIGlzIHN0aWxsIHBlbmRp
bmc/DQoNCkluIHdoaWNoIGNhc2UgYSBtdWNoIHNpbXBsZXIgcGF0Y2ggdGhhdCBkb2VzIGEgcmVh
ZGJhY2sgYWZ0ZXINCmV2ZXJ5IHdyaXRlIGFuZCByZXRyaWVzIGlmIHRoZSB2YWx1ZSBpcyBkaWZm
ZXJlbnQgd2lsbCBzb2x2ZQ0KdGhlIHByb2JsZW0gd2l0aG91dCBldmVyIG5lZWRpbmcgYSBkZWxh
eSgpLg0KDQpUaGUgb25seSAncHJvYmxlbScgcmVnaXN0ZXIgd291bGQgYmUgdGhlIGludGVycnVw
dCBtYXNrDQp3aGljaCB0aGUgaGFyZHdhcmUgYXBwZWFycyB0byBjaGFuZ2UgaXRzZWxmLg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

