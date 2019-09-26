Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE71BE9F7
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbfIZBPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:15:41 -0400
Received: from mx21.baidu.com ([220.181.3.85]:60634 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbfIZBPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 21:15:41 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 0A8019FF38B5C;
        Thu, 26 Sep 2019 09:15:34 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 26 Sep 2019 09:15:35 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 26 Sep 2019 09:15:35 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Pravin Shelar <pshelar@ovn.org>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG9wZW52c3dpdGNoOiBjaGFuZ2UgdHlwZSBvZiBV?=
 =?utf-8?B?UENBTExfUElEIGF0dHJpYnV0ZSB0byBOTEFfVU5TUEVD?=
Thread-Topic: [PATCH] openvswitch: change type of UPCALL_PID attribute to
 NLA_UNSPEC
Thread-Index: AQHVc+QVq57RtpC3l0K6ikxjWz2G76c9J2bQ
Date:   Thu, 26 Sep 2019 01:15:35 +0000
Message-ID: <e3535a264e3a4dedb3ab9ab88e907b5b@baidu.com>
References: <1569323512-19195-1-git-send-email-lirongqing@baidu.com>
 <CAOrHB_Drgcyxa_2yR4QyyUTkADxT=mdRwPSKOgTrefpnQq5-=g@mail.gmail.com>
In-Reply-To: <CAOrHB_Drgcyxa_2yR4QyyUTkADxT=mdRwPSKOgTrefpnQq5-=g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.6]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFByYXZpbiBTaGVsYXIg
W21haWx0bzpwc2hlbGFyQG92bi5vcmddDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDnmnIgyNuaX
pSA1OjAzDQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0K
PiDmioTpgIE6IExpbnV4IEtlcm5lbCBOZXR3b3JrIERldmVsb3BlcnMgPG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc+DQo+IOS4u+mimDogUmU6IFtQQVRDSF0gb3BlbnZzd2l0Y2g6IGNoYW5nZSB0eXBl
IG9mIFVQQ0FMTF9QSUQgYXR0cmlidXRlIHRvDQo+IE5MQV9VTlNQRUMNCj4gDQo+IE9uIFR1ZSwg
U2VwIDI0LCAyMDE5IGF0IDQ6MTEgQU0gTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
PiB3cm90ZToNCj4gPg0KPiA+IHVzZXJzcGFjZSBvcGVudnN3aXRjaCBwYXRjaCAiKGRwaWYtbGlu
dXg6IEltcGxlbWVudCB0aGUgQVBJIGZ1bmN0aW9ucw0KPiA+IHRvIGFsbG93IG11bHRpcGxlIGhh
bmRsZXIgdGhyZWFkcyByZWFkIHVwY2FsbCkiDQo+ID4gY2hhbmdlcyBpdHMgdHlwZSBmcm9tIFUz
MiB0byBVTlNQRUMsIGJ1dCBsZWF2ZSB0aGUga2VybmVsIHVuY2hhbmdlZA0KPiA+DQo+ID4gYW5k
IGFmdGVyIGtlcm5lbCA2ZTIzN2QwOTlmYWMgIihuZXRsaW5rOiBSZWxheCBhdHRyIHZhbGlkYXRp
b24gZm9yDQo+ID4gZml4ZWQgbGVuZ3RoIHR5cGVzKSIsIHRoaXMgYnVnIGlzIGV4cG9zZWQgYnkg
dGhlIGJlbG93IHdhcm5pbmcNCj4gPg0KPiA+ICAgICAgICAgWyAgIDU3LjIxNTg0MV0gbmV0bGlu
azogJ292cy12c3dpdGNoZCc6IGF0dHJpYnV0ZSB0eXBlIDUgaGFzIGFuDQo+IGludmFsaWQgbGVu
Z3RoLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFp
ZHUuY29tPg0KPiANCj4gQWNrZWQtYnk6IFByYXZpbiBCIFNoZWxhciA8cHNoZWxhckBvdm4ub3Jn
Pg0KPiANCg0KQWRkIGEgZml4ZXM6DQoNCkZpeGVzOiA1Y2Q2NjdiMGE0NTYgKCJvcGVudnN3aXRj
aDogQWxsb3cgZWFjaCB2cG9ydCB0byBoYXZlIGFuIGFycmF5IG9mICdwb3J0X2lkJ3MiKQ0KDQot
TEkNCg0KPiBUaGFua3MsDQo+IFByYXZpbi4NCg==
