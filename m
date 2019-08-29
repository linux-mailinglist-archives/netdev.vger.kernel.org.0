Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690C0A18A9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfH2LdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:33:16 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:59584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfH2LdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 07:33:16 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 7B4E619C6AA3719F0565;
        Thu, 29 Aug 2019 19:33:11 +0800 (CST)
Received: from dggeme751-chm.china.huawei.com (10.3.19.97) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 19:33:11 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 29 Aug 2019 19:33:10 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1591.008;
 Thu, 29 Aug 2019 19:33:10 +0800
From:   "zhangsha (A)" <zhangsha.zhang@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        hunongda <hunongda@huawei.com>,
        "Chenzhendong (alex)" <alex.chen@huawei.com>
Subject: RE: [PATCH v2] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Topic: [PATCH v2] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Index: AQHVWWTuTjbMPIKqPkGbw5snnBJTXKcPDgUAgAKfuyA=
Date:   Thu, 29 Aug 2019 11:33:10 +0000
Message-ID: <1bca4169ed95402eb32448379f56c2aa@huawei.com>
References: <20190823034209.14596-1-zhangsha.zhang@huawei.com>
 <20190827.150456.509211205582645335.davem@davemloft.net>
In-Reply-To: <20190827.150456.509211205582645335.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.220.209]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgTWlsbGVyIFtt
YWlsdG86ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldF0NCj4gU2VudDogMjAxOcTqONTCMjjI1SA2OjA1DQo+
IFRvOiB6aGFuZ3NoYSAoQSkgPHpoYW5nc2hhLnpoYW5nQGh1YXdlaS5jb20+DQo+IENjOiBqLnZv
c2J1cmdoQGdtYWlsLmNvbTsgdmZhbGljb0BnbWFpbC5jb207IGFuZHlAZ3JleWhvdXNlLm5ldDsN
Cj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
eXVlaGFpYmluZw0KPiA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPjsgaHVub25nZGEgPGh1bm9uZ2Rh
QGh1YXdlaS5jb20+Ow0KPiBDaGVuemhlbmRvbmcgKGFsZXgpIDxhbGV4LmNoZW5AaHVhd2VpLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gYm9uZGluZzogZm9yY2UgZW5hYmxlIGxhY3Ag
cG9ydCBhZnRlciBsaW5rIHN0YXRlDQo+IHJlY292ZXJ5IGZvciA4MDIuM2FkDQo+IA0KPiBGcm9t
OiA8emhhbmdzaGEuemhhbmdAaHVhd2VpLmNvbT4NCj4gRGF0ZTogRnJpLCAyMyBBdWcgMjAxOSAx
MTo0MjowOSArMDgwMA0KPiANCj4gPiAtIElmIHNwZWVkL2R1cGxleCBnZXR0aW5nIGZhaWxlZCBo
ZXJlLCB0aGUgbGluayBzdGF0dXMNCj4gPiAgIHdpbGwgYmUgY2hhbmdlZCB0byBCT05EX0xJTktf
RkFJTDsNCj4gDQo+IEhvdyBkb2VzIGl0IGZhaWwgYXQgdGhpcyBzdGVwPyAgSSBzdXNwZWN0IHRo
aXMgaXMgYSBkcml2ZXIgc3BlY2lmaWMgcHJvYmxlbS4NCg0KSGksIERhdmlkLA0KSSdtIHJlYWxs
eSBzb3JyeSBmb3IgdGhlIGRlbGF5ZWQgZW1haWwgYW5kIGFwcHJlY2lhdGVkIGZvciB5b3VyIGZl
ZWRiYWNrLg0KDQpJIHdhcyB0ZXN0aW5nIGluIGtlcm5lbCA0LjE5IHdpdGggYSBIdWF3ZWkgaGlu
aWMgY2FyZCB3aGVuIHRoZSBwcm9ibGVtIG9jY3VycmVkLg0KSSBjaGVja2VkIHRoZSBkbWVzZyBh
bmQgZ290IHRoZSBsb2dzIGluIHRoZSBmb2xsb3dpbmcgb3JkZXI6DQoxKSBsaW5rIHN0YXR1cyBk
ZWZpbml0ZWx5IGRvd24gZm9yIGludGVyZmFjZSBldGg2LCBkaXNhYmxpbmcgaXQNCjIpIGxpbmsg
c3RhdHVzIHVwIGFnYWluIGFmdGVyIDAgbXMgZm9yIGludGVyZmFjZSBldGg2DQozKSB0aGUgcGF0
ZXJuZXIncyBzeXN0ZW0gbWFjIGJlY29tZXMgdG8gIjAwOjAwOjAwOjAwOjAwOjAwIi4NCkJ5ICBy
ZWFkaW5nIHRoZSBjb2RlcywgSSB0aGluayB0aGF0IHRoZSBsaW5rIHN0YXR1cyBvZiB0aGUgc2xh
dmUgc2hvdWxkIGJlIGNoYW5nZWQNCnRvIEJPTkRfTElOS19GQUlMIGZyb20gQk9ORF9MSU5LX0RP
V04uIA0KDQpBcyB0aGlzIHByb2JsZW0gaGFzIG9ubHkgb2NjdXJyZWQgb25jZSBvbmx5LCBJIGFt
IG5vdCB2ZXJ5IHN1cmUgYWJvdXQgd2hldGhlciB0aGlzIGlzIGENCmRyaXZlciBzcGVjaWZpYyBw
cm9ibGVtIG9yIG5vdCBhdCB0aGUgbW9tZW50LiBCdXQgSSBmaW5kIHRoZSBjb21taXQgNGQyYzBj
ZGEsIA0KaXRzIGxvZyBzYXlzICIgU29tZSBOSUMgZHJpdmVycyBkb24ndCBoYXZlIGNvcnJlY3Qg
c3BlZWQvZHVwbGV4IHNldHRpbmdzIGF0IHRoZQ0KdGltZSB0aGV5IHNlbmQgTkVUREVWX1VQIG5v
dGlmaWNhdGlvbiAuLi4iLCAgc28gSSBwcmVmZXIgdG8gYmVsaWV2ZSBpdCdzIG5vdC4NCg0KVG8g
bXkgcHJvYmxlbSBJIHRoaW5rICBpdCBpcyBub3QgZW5vdWdoIHRoYXQgbGluay1tb25pdG9yaW5n
IChtaWltb24pIG9ubHkgc2V0DQpTUEVFRC9EVVBMRVggcmlnaHQsIHRoZSBsYWNwIHBvcnQgc2hv
dWxkIGJlIGVuYWJsZWQgdG9vIGF0IHRoZSBzYW1lIHRpbWUuDQogDQoNCg0K
