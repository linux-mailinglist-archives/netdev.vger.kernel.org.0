Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A920847E60C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244313AbhLWPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:53:06 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30100 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhLWPxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:53:05 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JKZQ82FFLz1DKG6;
        Thu, 23 Dec 2021 23:49:52 +0800 (CST)
Received: from dggpeml100015.china.huawei.com (7.185.36.168) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 23:53:02 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml100015.china.huawei.com (7.185.36.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 23:53:02 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Thu, 23 Dec 2021 23:53:02 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xue.zhihong@zte.com.cn" <xue.zhihong@zte.com.cn>,
        "wang.liang82@zte.com.cn" <wang.liang82@zte.com.cn>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH] vdpa: regist vhost-vdpa dev class
Thread-Topic: [PATCH] vdpa: regist vhost-vdpa dev class
Thread-Index: AQHX99HYrIlOz3l0l0u1qq17OsLXJqxAOkrA
Date:   Thu, 23 Dec 2021 15:53:02 +0000
Message-ID: <01217747379b4daab45862e572d4f8b1@huawei.com>
References: <20211223073145.35363-1-wang.yi59@zte.com.cn>
In-Reply-To: <20211223073145.35363-1-wang.yi59@zte.com.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWWkgV2FuZyBbbWFpbHRv
OndhbmcueWk1OUB6dGUuY29tLmNuXQ0KPiBTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMjMsIDIw
MjEgMzozMiBQTQ0KPiBUbzogbXN0QHJlZGhhdC5jb20NCj4gQ2M6IGphc293YW5nQHJlZGhhdC5j
b207IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZv
dW5kYXRpb24ub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyB4dWUuemhpaG9uZ0B6dGUuY29tLmNuOyB3YW5nLnlpNTlAenRlLmNvbS5j
bjsNCj4gd2FuZy5saWFuZzgyQHp0ZS5jb20uY247IFpoYW5nIE1pbiA8emhhbmcubWluOUB6dGUu
Y29tLmNuPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIHZkcGE6IHJlZ2lzdCB2aG9zdC12ZHBhIGRldiBj
bGFzcw0KPiANCj4gRnJvbTogWmhhbmcgTWluIDx6aGFuZy5taW45QHp0ZS5jb20uY24+DQo+IA0K
PiBTb21lIGFwcGxpY2F0aW9ucyBsaWtlIGthdGEtY29udGFpbmVycyBuZWVkIHRvIGFjcXVpcmUg
TUFKT1IvTUlOT1IvREVWTkFNRQ0KPiBmb3IgZGV2SW5mbyBbMV0sIHNvIHJlZ2lzdCB2aG9zdC12
ZHBhIGRldiBjbGFzcyB0byBleHBvc2UgdWV2ZW50Lg0KPiANCj4gMS4NCj4gaHR0cHM6Ly9naXRo
dWIuY29tL2thdGEtY29udGFpbmVycy9rYXRhLWNvbnRhaW5lcnMvYmxvYi9tYWluL3NyYy9ydW50
aW1lL3ZpDQo+IHJ0Y29udGFpbmVycy9kZXZpY2UvY29uZmlnL2NvbmZpZy5nbw0KPiANCj4gU2ln
bmVkLW9mZi1ieTogWmhhbmcgTWluIDx6aGFuZy5taW45QHp0ZS5jb20uY24+DQo+IFNpZ25lZC1v
ZmYtYnk6IFlpIFdhbmcgPHdhbmcueWk1OUB6dGUuY29tLmNuPg0KPiAtLS0NCj4gIGRyaXZlcnMv
dmhvc3QvdmRwYS5jIHwgMTIgKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJp
dmVycy92aG9zdC92ZHBhLmMNCj4gaW5kZXggZmI0MWRiM2RhNjExLi45MGZiYWQ5M2U3YTIgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ICsrKyBiL2RyaXZlcnMvdmhvc3Qv
dmRwYS5jDQo+IEBAIC0xMDEyLDYgKzEwMTIsNyBAQCBzdGF0aWMgdm9pZCB2aG9zdF92ZHBhX3Jl
bGVhc2VfZGV2KHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIAlrZnJlZSh2KTsNCj4gIH0NCj4g
DQo+ICtzdGF0aWMgc3RydWN0IGNsYXNzICp2aG9zdF92ZHBhX2NsYXNzOw0KPiAgc3RhdGljIGlu
dCB2aG9zdF92ZHBhX3Byb2JlKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSkNCj4gIHsNCj4gIAlj
b25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2ZHBhLT5jb25maWc7DQo+IEBAIC0x
MDQwLDYgKzEwNDEsNyBAQCBzdGF0aWMgaW50IHZob3N0X3ZkcGFfcHJvYmUoc3RydWN0IHZkcGFf
ZGV2aWNlICp2ZHBhKQ0KPiAgCXYtPmRldi5yZWxlYXNlID0gdmhvc3RfdmRwYV9yZWxlYXNlX2Rl
djsNCj4gIAl2LT5kZXYucGFyZW50ID0gJnZkcGEtPmRldjsNCj4gIAl2LT5kZXYuZGV2dCA9IE1L
REVWKE1BSk9SKHZob3N0X3ZkcGFfbWFqb3IpLCBtaW5vcik7DQo+ICsJdi0+ZGV2LmNsYXNzID0g
dmhvc3RfdmRwYV9jbGFzczsNCj4gIAl2LT52cXMgPSBrbWFsbG9jX2FycmF5KHYtPm52cXMsIHNp
emVvZihzdHJ1Y3Qgdmhvc3RfdmlydHF1ZXVlKSwNCj4gIAkJCSAgICAgICBHRlBfS0VSTkVMKTsN
Cj4gIAlpZiAoIXYtPnZxcykgew0KPiBAQCAtMTA5Nyw2ICsxMDk5LDE0IEBAIHN0YXRpYyBpbnQg
X19pbml0IHZob3N0X3ZkcGFfaW5pdCh2b2lkKQ0KPiAgew0KPiAgCWludCByOw0KPiANCj4gKwl2
aG9zdF92ZHBhX2NsYXNzID0gY2xhc3NfY3JlYXRlKFRISVNfTU9EVUxFLCAidmhvc3QtdmRwYSIp
Ow0KPiArCWlmIChJU19FUlIodmhvc3RfdmRwYV9jbGFzcykpIHsNCj4gKwkJciA9IFBUUl9FUlIo
dmhvc3RfdmRwYV9jbGFzcyk7DQo+ICsJCXByX3dhcm4oInZob3N0IHZkcGEgY2xhc3MgY3JlYXRl
IGVycm9yICVkLCAgbWF5YmUgbW9kIHJlaW5zZXJ0ZWRcbiIsIHIpOw0KPiArCQl2aG9zdF92ZHBh
X2NsYXNzID0gTlVMTDsNCg0KVW5uZWNlc3NhcnkgdG8gcmVzZXQ/DQoNCj4gKwkJcmV0dXJuIHI7
DQo+ICsJfQ0KPiArDQo+ICAJciA9IGFsbG9jX2NocmRldl9yZWdpb24oJnZob3N0X3ZkcGFfbWFq
b3IsIDAsIFZIT1NUX1ZEUEFfREVWX01BWCwNCj4gIAkJCQkidmhvc3QtdmRwYSIpOw0KPiAgCWlm
IChyKQ0KPiBAQCAtMTExMSw2ICsxMTIxLDcgQEAgc3RhdGljIGludCBfX2luaXQgdmhvc3RfdmRw
YV9pbml0KHZvaWQpDQo+ICBlcnJfdmRwYV9yZWdpc3Rlcl9kcml2ZXI6DQo+ICAJdW5yZWdpc3Rl
cl9jaHJkZXZfcmVnaW9uKHZob3N0X3ZkcGFfbWFqb3IsIFZIT1NUX1ZEUEFfREVWX01BWCk7DQo+
ICBlcnJfYWxsb2NfY2hyZGV2Og0KPiArCWNsYXNzX2Rlc3Ryb3kodmhvc3RfdmRwYV9jbGFzcyk7
DQo+ICAJcmV0dXJuIHI7DQo+ICB9DQo+ICBtb2R1bGVfaW5pdCh2aG9zdF92ZHBhX2luaXQpOw0K
PiBAQCAtMTExOCw2ICsxMTI5LDcgQEAgbW9kdWxlX2luaXQodmhvc3RfdmRwYV9pbml0KTsNCj4g
IHN0YXRpYyB2b2lkIF9fZXhpdCB2aG9zdF92ZHBhX2V4aXQodm9pZCkNCj4gIHsNCj4gIAl2ZHBh
X3VucmVnaXN0ZXJfZHJpdmVyKCZ2aG9zdF92ZHBhX2RyaXZlcik7DQo+ICsJY2xhc3NfZGVzdHJv
eSh2aG9zdF92ZHBhX2NsYXNzKTsNCj4gIAl1bnJlZ2lzdGVyX2NocmRldl9yZWdpb24odmhvc3Rf
dmRwYV9tYWpvciwgVkhPU1RfVkRQQV9ERVZfTUFYKTsNCj4gIH0NCj4gIG1vZHVsZV9leGl0KHZo
b3N0X3ZkcGFfZXhpdCk7DQo+IC0tDQo+IDIuMjcuMA0K
