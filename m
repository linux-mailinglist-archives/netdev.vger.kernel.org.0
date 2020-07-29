Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAD123196E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG2GU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:20:59 -0400
Received: from mx21.baidu.com ([220.181.3.85]:42418 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbgG2GU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:20:59 -0400
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id 278A096E1C15F0EFB305;
        Wed, 29 Jul 2020 14:20:54 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Wed, 29 Jul 2020 14:20:53 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Wed, 29 Jul 2020 14:20:47 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: =?gb2312?B?tPC4tDogW25ldC1uZXh0IDIvNl0gaTQwZTogcHJlZmV0Y2ggc3RydWN0IHBh?=
 =?gb2312?Q?ge_of_Rx_buffer_conditionally?=
Thread-Topic: [net-next 2/6] i40e: prefetch struct page of Rx buffer
 conditionally
Thread-Index: AQHWZRKIaFSgdN4Dc0O7wcJ77z58xakc5xyAgAEtH/A=
Date:   Wed, 29 Jul 2020 06:20:47 +0000
Message-ID: <8e1471fdcaed4f46825cd8ff112a8c36@baidu.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-3-anthony.l.nguyen@intel.com>
 <20200728131423.2430b3f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728131423.2430b3f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.182.89]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex30_2020-07-29 14:20:54:032
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSmFrdWIgS2ljaW5za2kgW21haWx0
bzprdWJhQGtlcm5lbC5vcmddDQo+ILeiy83KsbzkOiAyMDIwxOo31MIyOcjVIDQ6MTQNCj4gytW8
/sjLOiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+ILOty806IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21hbm5AcmVk
aGF0LmNvbTsNCj4gamVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tOyBBbmRyZXcgQm93ZXJzIDxh
bmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+DQo+INb3zOI6IFJlOiBbbmV0LW5leHQgMi82XSBpNDBl
OiBwcmVmZXRjaCBzdHJ1Y3QgcGFnZSBvZiBSeCBidWZmZXIgY29uZGl0aW9uYWxseQ0KPiANCj4g
T24gVHVlLCAyOCBKdWwgMjAyMCAxMjowODozOCAtMDcwMCBUb255IE5ndXllbiB3cm90ZToNCj4g
PiBGcm9tOiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4NCj4gPiBwYWdl
X2FkZHJlc3MoKSBhY2Nlc3NlcyBzdHJ1Y3QgcGFnZSBvbmx5IHdoZW4gV0FOVF9QQUdFX1ZJUlRV
QUwgb3INCj4gPiBIQVNIRURfUEFHRV9WSVJUVUFMIGlzIGRlZmluZWQsIG90aGVyd2lzZSBpdCBy
ZXR1cm5zIGFkZHJlc3MgYmFzZWQgb24NCj4gPiBvZmZzZXQsIHNvIHdlIHByZWZldGNoIGl0IGNv
bmRpdGlvbmFsbHkNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdx
aW5nQGJhaWR1LmNvbT4NCj4gPiBUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93
ZXJzQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5s
Lm5ndXllbkBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2k0MGUvaTQwZV90eHJ4LmMgfCAyICsrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pNDBlL2k0MGVfdHhyeC5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
L2k0MGVfdHhyeC5jDQo+ID4gaW5kZXggM2U1YzU2NmNlYjAxLi41ZDQwOGZlMjYwNjMgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cnguYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV90eHJ4LmMNCj4g
PiBAQCAtMTk1Myw3ICsxOTUzLDkgQEAgc3RhdGljIHN0cnVjdCBpNDBlX3J4X2J1ZmZlcg0KPiAq
aTQwZV9nZXRfcnhfYnVmZmVyKHN0cnVjdCBpNDBlX3JpbmcgKnJ4X3JpbmcsDQo+ID4gIAlzdHJ1
Y3QgaTQwZV9yeF9idWZmZXIgKnJ4X2J1ZmZlcjsNCj4gPg0KPiA+ICAJcnhfYnVmZmVyID0gaTQw
ZV9yeF9iaShyeF9yaW5nLCByeF9yaW5nLT5uZXh0X3RvX2NsZWFuKTsNCj4gPiArI2lmIGRlZmlu
ZWQoV0FOVF9QQUdFX1ZJUlRVQUwpIHx8IGRlZmluZWQoSEFTSEVEX1BBR0VfVklSVFVBTCkNCj4g
PiAgCXByZWZldGNodyhyeF9idWZmZXItPnBhZ2UpOw0KDQpNYXliZSBJIGNoYW5nZSBwcmVmZXRj
aHcgdG8gcHJlZmV0Y2guDQoNCnJlZmNvdW50IG9mIHJ4X2J1ZmZlciBwYWdlIHdpbGwgYmUgYWRk
ZWQgaGVyZSBvcmlnaW5hbGx5LA0Kc28gcHJlZmV0Y2h3IGlzIG5lZWRlZCwgYnV0IGFmdGVyIGNv
bW1pdCAxNzkzNjY4YzNiOGMNCigiaTQwZS9pNDBldmY6IFVwZGF0ZSBjb2RlIHRvIGJldHRlciBo
YW5kbGUgaW5jcmVtZW50aW5nIHBhZ2UgY291bnQiKSwNCmFuZCByZWZjb3VudCBpcyBub3QgYWRk
ZWQgZXZlcnl0aW1lLCBzbyBjaGFuZ2UgcHJlZmV0Y2h3DQphcyBwcmVmZXRjaCwNCg0KPiA+ICsj
ZW5kaWYNCj4gDQo+IExvb2tzIGxpa2Ugc29tZXRoaW5nIHRoYXQgYmVsb25ncyBpbiBhIGNvbW1v
biBoZWFkZXIgbm90IChwb3RlbnRpYWxseQ0KPiBtdWx0aXBsZSkgQyBzb3VyY2VzLg0KDQpOb3Qg
Y2xlYXIsIGhvdyBzaG91bGQgSSBjaGFuZ2U/DQoNCi1MaQ0K
