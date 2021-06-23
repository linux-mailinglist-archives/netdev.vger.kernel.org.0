Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693BA3B1181
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 04:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFWCEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 22:04:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8294 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFWCEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 22:04:34 -0400
Received: from nkgeml706-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G8mbj4rgSz1BQd9;
        Wed, 23 Jun 2021 09:57:05 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 nkgeml706-chm.china.huawei.com (10.98.57.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 10:02:14 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2176.012;
 Wed, 23 Jun 2021 10:02:14 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
Thread-Topic: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
Thread-Index: Addn0lDNQ8Ker7O+Ra2emPmghn4FNg==
Date:   Wed, 23 Jun 2021 02:02:14 +0000
Message-ID: <b8d459068a994586a1ad8f6e2d3a1e92@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gNi8yMi8yMSA4OjE2IFBNLCBKYXkgVm9zYnVyZ2ggd3JvdGU6DQo+ID4gemh1ZGkg
PHpodWRpMjFAaHVhd2VpLmNvbT4gd3JvdGU6DQo+ID4NCj4gPj4gRnJvbTogRGkgWmh1IDx6aHVk
aTIxQGh1YXdlaS5jb20+DQo+ID4+DQo+ID4+IFRoZSBmb2xsb3dpbmcgc3RlcHMgd2lsbCBkZWZp
bml0ZWx5IGNhdXNlIHRoZSBrZXJuZWwgdG8gY3Jhc2g6DQo+ID4+IAlpcCBsaW5rIGFkZCB2cmYx
IHR5cGUgdnJmIHRhYmxlIDENCj4gPj4gCW1vZHByb2JlIGJvbmRpbmcua28gbWF4X2JvbmRzPTEN
Cj4gPj4gCWVjaG8gIit2cmYxIiA+L3N5cy9jbGFzcy9uZXQvYm9uZDAvYm9uZGluZy9zbGF2ZXMN
Cj4gPj4gCXJtbW9kIGJvbmRpbmcNCj4gPj4NCj4gPj4gVGhlIHJvb3QgY2F1c2UgaXMgdGhhdDog
V2hlbiB0aGUgVlJGIGlzIGFkZGVkIHRvIHRoZSBzbGF2ZSBkZXZpY2UsIGl0DQo+ID4+IHdpbGwg
ZmFpbCwgYW5kIHNvbWUgY2xlYW5pbmcgd29yayB3aWxsIGJlIGRvbmUuIGJlY2F1c2UgVlJGIGRl
dmljZQ0KPiA+PiBoYXMgSUZGX01BU1RFUiBmbGFnLCBjbGVhbnVwIHByb2Nlc3MgIHdpbGwgbm90
IGNsZWFyIHRoZSBJRkZfQk9ORElORw0KPiBmbGFnLg0KPiA+PiBUaGVuLCB3aGVuIHdlIHVubG9h
ZCB0aGUgYm9uZGluZyBtb2R1bGUsDQo+ID4+IHVucmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVy
KCkgd2lsbCB0cmVhdCB0aGUgVlJGIGRldmljZSBhcyBhIGJvbmQNCj4gPj4gbWFzdGVyIGRldmlj
ZSBhbmQgdHJlYXQgbmV0ZGV2X3ByaXYoKSBhcyBzdHJ1Y3QgYm9uZGluZ3t9IHdoaWNoIGFjdHVh
bGx5IGlzDQo+IHN0cnVjdCBuZXRfdnJme30uDQo+ID4+DQo+ID4+IEJ5IGFuYWx5emluZyB0aGUg
cHJvY2Vzc2luZyBsb2dpYyBvZiBib25kX2Vuc2xhdmUoKSwgaXQgc2VlbXMgdGhhdCBpdA0KPiA+
PiBpcyBub3QgYWxsb3dlZCB0byBhZGQgdGhlIHNsYXZlIGRldmljZSB3aXRoIHRoZSBJRkZfTUFT
VEVSIGZsYWcsIHNvDQo+ID4+IHdlIG5lZWQgdG8gYWRkIGEgY29kZSBjaGVjayBmb3IgdGhpcyBz
aXR1YXRpb24uDQo+ID4NCj4gPiAJSSBkb24ndCBiZWxpZXZlIHRoZSBzdGF0ZW1lbnQganVzdCBh
Ym92ZSBpcyBjb3JyZWN0OyBuZXN0aW5nIGJvbmRzDQo+ID4gaGFzIGhpc3RvcmljYWxseSBiZWVu
IHBlcm1pdHRlZCwgZXZlbiBpZiBpdCBpcyBvZiBxdWVzdGlvbmFibGUgdmFsdWUNCj4gPiB0aGVz
ZSBkYXlzLiAgSSd2ZSBub3QgdGVzdGVkIG5lc3RpbmcgaW4gYSB3aGlsZSwgYnV0IGxhc3QgSSBy
ZWNhbGwgaXQNCj4gPiBkaWQgZnVuY3Rpb24uDQo+ID4NCj4gPiAJTGVhdmluZyBhc2lkZSB0aGUg
cXVlc3Rpb24gb2Ygd2hldGhlciBpdCdzIHJlYWxseSB1c2VmdWwgdG8gbmVzdA0KPiA+IGJvbmRz
IG9yIG5vdCwgbXkgY29uY2VybiB3aXRoIGRpc2FibGluZyB0aGlzIGlzIHRoYXQgaXQgd2lsbCBi
cmVhaw0KPiA+IGV4aXN0aW5nIGNvbmZpZ3VyYXRpb25zIHRoYXQgY3VycmVudGx5IHdvcmsgZmlu
ZS4NCj4gPg0KPiA+IAlIb3dldmVyLCBpdCBzaG91bGQgYmUgcG9zc2libGUgdG8gdXNlIG5ldGlm
X2lzX2JvbmRpbmdfbWFzdGVyDQo+ICh3aGljaA0KPiA+IHRlc3RzIGRldi0+ZmxhZ3MgJiBJRkZf
TUFTVEVSIGFuZCBkZXYtPnByaXZfZmxhZ3MgJiBJRkZfQk9ORElORykgdG8NCj4gPiBleGNsdWRl
IElGRl9NQVNURVIgZGV2aWNlcyB0aGF0IGFyZSBub3QgYm9uZHMgKHdoaWNoIHNlZW0gdG8gYmUg
dnJmDQo+ID4gYW5kIGVxbCksIGUuZy4sDQo+ID4NCj4gPiAJaWYgKChzbGF2ZV9kZXYtPmZsYWdz
ICYgSUZGX01BU1RFUikgJiYNCj4gPiAJCSFuZXRpZl9pc19ib25kX21hc3RlcihzbGF2ZV9kZXYp
KQ0KPiA+DQo+ID4gCU9yIHdlIGNhbiBqdXN0IGdvIHdpdGggdGhpcyBwYXRjaCBhbmQgc2VlIGlm
IGFueXRoaW5nIGJyZWFrcy4NCj4gPg0KPiANCj4gc3l6Ym90IGZvciBzdXJlIHdpbGwgc3RvcCBm
aW5kaW5nIHN0YWNrIG92ZXJmbG93cyBhbmQgb3RoZXIgaXNzdWVzIGxpa2UgdGhhdCA6KQ0KPiAN
Cj4gSSBrbm93IHRoYXQgc29tZSBwZW9wbGUgdXNlZCBuZXN0ZWQgYm9uZGluZyBkZXZpY2VzIGlu
IG9yZGVyIHRvIGltcGxlbWVudA0KPiBjb21wbGV4IHFkaXNjIHNldHVwcy4NCj4gKGVnIEhUQiBv
biB0aGUgZmlyc3QgbGV2ZWwsIG5ldGVtIG9uIHRoZSBzZWNvbmQgbGV2ZWwpLg0KDQpJZiB0aGVy
ZSBpcyBzdWNoIGEgdXNhZ2Ugc2NlbmFyaW8sICB0aGUgZm9sbG93aW5nIGNvZGUgcHJvcG9zZWQg
YnkgSmF5IFZvc2J1cmdoIGlzIGJldHRlcjoNCglpZiAoKHNsYXZlX2Rldi0+ZmxhZ3MgJiBJRkZf
TUFTVEVSKSAmJiANCgkJCSFuZXRpZl9pc19ib25kX21hc3RlcihzbGF2ZV9kZXYpKQ0KDQpUaGFu
ayB5b3UgZm9yIHlvdXIgYWR2aWNlLCBJIHdpbGwgc2VuZCBhbm90aGVyIHBhdGNoIHRvIGZpeCBp
dC4NCg0KDQoNCg==
