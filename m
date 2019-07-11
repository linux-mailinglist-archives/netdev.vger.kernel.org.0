Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40C365008
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfGKB4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:56:07 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:36818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbfGKB4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 21:56:07 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 8E0E5E88A85AE80ACC16;
        Thu, 11 Jul 2019 09:56:02 +0800 (CST)
Received: from DGGEMM424-HUB.china.huawei.com (10.1.198.41) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 09:56:01 +0800
Received: from DGGEMM507-MBX.china.huawei.com ([169.254.1.169]) by
 dggemm424-hub.china.huawei.com ([10.1.198.41]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 09:55:55 +0800
From:   Nixiaoming <nixiaoming@huawei.com>
To:     Vasily Averin <vvs@virtuozzo.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "Nadia.Derbey@bull.net" <Nadia.Derbey@bull.net>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "semen.protsenko@linaro.org" <semen.protsenko@linaro.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
CC:     "Huangjianhui (Alex)" <alex.huangjianhui@huawei.com>,
        Dailei <dylix.dailei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Thread-Topic: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Thread-Index: AQHVNszeCdZobq+tm0y9Gm/hoQ9GDabC0qkAgAHQ6FA=
Date:   Thu, 11 Jul 2019 01:55:55 +0000
Message-ID: <E490CD805F7529488761C40FD9D26EF12AC9D068@dggemm507-mbx.china.huawei.com>
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
 <f628ff03-eb47-62f3-465b-fe4ed046b30c@virtuozzo.com>
In-Reply-To: <f628ff03-eb47-62f3-465b-fe4ed046b30c@virtuozzo.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.57.88.168]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBKdWx5IDEwLCAyMDE5IDE6NDkgUE0gVmFzaWx5IEF2ZXJpbiB3cm90ZToNCj5PbiA3
LzEwLzE5IDY6MDkgQU0sIFhpYW9taW5nIE5pIHdyb3RlOg0KPj4gUmVnaXN0ZXJpbmcgdGhlIHNh
bWUgbm90aWZpZXIgdG8gYSBob29rIHJlcGVhdGVkbHkgY2FuIGNhdXNlIHRoZSBob29rDQo+PiBs
aXN0IHRvIGZvcm0gYSByaW5nIG9yIGxvc2Ugb3RoZXIgbWVtYmVycyBvZiB0aGUgbGlzdC4NCj4N
Cj5JIHRoaW5rIGlzIG5vdCBlbm91Z2ggdG8gX3ByZXZlbnRfIDJuZCByZWdpc3RlciBhdHRlbXB0
LA0KPml0J3MgZW5vdWdoIHRvIGRldGVjdCBqdXN0IGF0dGVtcHQgYW5kIGdlbmVyYXRlIHdhcm5p
bmcgdG8gbWFyayBob3N0IGluIGJhZCBzdGF0ZS4NCj4NCg0KRHVwbGljYXRlIHJlZ2lzdHJhdGlv
biBpcyBwcmV2ZW50ZWQgaW4gbXkgcGF0Y2gsIG5vdCBqdXN0ICJtYXJrIGhvc3QgaW4gYmFkIHN0
YXRlIg0KDQpEdXBsaWNhdGUgcmVnaXN0cmF0aW9uIGlzIGNoZWNrZWQgYW5kIGV4aXRlZCBpbiBu
b3RpZmllcl9jaGFpbl9jb25kX3JlZ2lzdGVyKCkNCg0KRHVwbGljYXRlIHJlZ2lzdHJhdGlvbiB3
YXMgY2hlY2tlZCBpbiBub3RpZmllcl9jaGFpbl9yZWdpc3RlcigpIGJ1dCBvbmx5IA0KdGhlIGFs
YXJtIHdhcyB0cmlnZ2VyZWQgd2l0aG91dCBleGl0aW5nLiBhZGRlZCBieSBjb21taXQgODMxMjQ2
NTcwZDM0NjkyZSANCigia2VybmVsL25vdGlmaWVyLmM6IGRvdWJsZSByZWdpc3RlciBkZXRlY3Rp
b24iKQ0KDQpNeSBwYXRjaCBpcyBsaWtlIGEgY29tYmluYXRpb24gb2YgODMxMjQ2NTcwZDM0Njky
ZSBhbmQgbm90aWZpZXJfY2hhaW5fY29uZF9yZWdpc3RlcigpLA0KIHdoaWNoIHRyaWdnZXJzIGFu
IGFsYXJtIGFuZCBleGl0cyB3aGVuIGEgZHVwbGljYXRlIHJlZ2lzdHJhdGlvbiBpcyBkZXRlY3Rl
ZC4NCg0KPlVuZXhwZWN0ZWQgMm5kIHJlZ2lzdGVyIG9mIHRoZSBzYW1lIGhvb2sgbW9zdCBsaWtl
bHkgd2lsbCBsZWFkIHRvIDJuZCB1bnJlZ2lzdGVyLA0KPmFuZCBpdCBjYW4gbGVhZCB0byBob3N0
IGNyYXNoIGluIGFueSB0aW1lOiANCj55b3UgY2FuIHVucmVnaXN0ZXIgbm90aWZpZXIgb24gZmly
c3QgYXR0ZW1wdCBpdCBjYW4gYmUgdG9vIGVhcmx5LCBpdCBjYW4gYmUgc3RpbGwgaW4gdXNlLg0K
Pm9uIHRoZSBvdGhlciBoYW5kIHlvdSBjYW4gbmV2ZXIgY2FsbCAybmQgdW5yZWdpc3RlciBhdCBh
bGwuDQoNClNpbmNlIHRoZSBtZW1iZXIgd2FzIG5vdCBhZGRlZCB0byB0aGUgbGlua2VkIGxpc3Qg
YXQgdGhlIHRpbWUgb2YgdGhlIHNlY29uZCByZWdpc3RyYXRpb24sIA0Kbm8gbGlua2VkIGxpc3Qg
cmluZyB3YXMgZm9ybWVkLiANClRoZSBtZW1iZXIgaXMgcmVsZWFzZWQgb24gdGhlIGZpcnN0IHVu
cmVnaXN0cmF0aW9uIGFuZCAtRU5PRU5UIG9uIHRoZSBzZWNvbmQgdW5yZWdpc3RyYXRpb24uDQpB
ZnRlciBwYXRjaGluZywgdGhlIGZhdWx0IGhhcyBiZWVuIGFsbGV2aWF0ZWQNCg0KSXQgbWF5IGJl
IG1vcmUgaGVscGZ1bCB0byByZXR1cm4gYW4gZXJyb3IgY29kZSB3aGVuIHNvbWVvbmUgdHJpZXMg
dG8gcmVnaXN0ZXIgdGhlIHNhbWUNCm5vdGlmaWNhdGlvbiBwcm9ncmFtIGEgc2Vjb25kIHRpbWUu
DQpCdXQgSSBub3RpY2VkIHRoYXQgbm90aWZpZXJfY2hhaW5fY29uZF9yZWdpc3RlcigpIHJldHVy
bnMgMCB3aGVuIGR1cGxpY2F0ZSByZWdpc3RyYXRpb24gDQppcyBkZXRlY3RlZC4gQXQgdGhlIHNh
bWUgdGltZSwgaW4gYWxsIHRoZSBleGlzdGluZyBleHBvcnQgZnVuY3Rpb24gY29tbWVudHMgb2Yg
bm90aWZ5LA0KIkN1cnJlbnRseSBhbHdheXMgcmV0dXJucyB6ZXJvIg0KDQpJIGFtIGEgYml0IGNv
bmZ1c2VkOiB3aGljaCBpcyBiZXR0ZXI/DQoNCj4NCj5VbmZvcnR1bmF0ZWx5IEkgZG8gbm90IHNl
ZSBhbnkgd2F5cyB0byBoYW5kbGUgc3VjaCBjYXNlcyBwcm9wZXJseSwNCj5hbmQgaXQgc2VlbXMg
Zm9yIG1lIHlvdXIgcGF0Y2hlcyBkb2VzIG5vdCByZXNvbHZlIHRoaXMgcHJvYmxlbS4NCj4NCj5B
bSBJIG1pc3NlZCBzb21ldGhpbmcgcHJvYmFibHk/DQo+IA0KPj4gY2FzZTE6IEFuIGluZmluaXRl
IGxvb3AgaW4gbm90aWZpZXJfY2hhaW5fcmVnaXN0ZXIoKSBjYW4gY2F1c2Ugc29mdCBsb2NrdXAN
Cj4+ICAgICAgICAgYXRvbWljX25vdGlmaWVyX2NoYWluX3JlZ2lzdGVyKCZ0ZXN0X25vdGlmaWVy
X2xpc3QsICZ0ZXN0MSk7DQo+PiAgICAgICAgIGF0b21pY19ub3RpZmllcl9jaGFpbl9yZWdpc3Rl
cigmdGVzdF9ub3RpZmllcl9saXN0LCAmdGVzdDEpOw0KPj4gICAgICAgICBhdG9taWNfbm90aWZp
ZXJfY2hhaW5fcmVnaXN0ZXIoJnRlc3Rfbm90aWZpZXJfbGlzdCwgJnRlc3QyKTsNCg0KVGhhbmtz
DQoNClhpYW9taW5nIE5pDQo=
