Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD87396ABE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 03:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhFABzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 21:55:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3359 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhFABzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 21:55:20 -0400
Received: from dggeme712-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvFTb0PLxz677c;
        Tue,  1 Jun 2021 09:49:55 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme712-chm.china.huawei.com (10.1.199.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 09:53:37 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 1 Jun 2021 09:53:37 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIHNjdHA6IHNtX3N0YXRlZnVuczog?=
 =?utf-8?Q?Fix_spelling_mistakes?=
Thread-Topic: [PATCH net-next] sctp: sm_statefuns: Fix spelling mistakes
Thread-Index: AQHXVb7r2PGYQfiLYUeXXJTSIeBLlKr9QQaAgAEk9cA=
Date:   Tue, 1 Jun 2021 01:53:37 +0000
Message-ID: <0a8bacf10bc145c5924f1d33a9aefd43@huawei.com>
References: <20210531020110.2920255-1-zhengyongjun3@huawei.com>
 <CADvbK_eCmDbAZ6_tppe=q3aW76OAnfZd3TXoAafDTk0h=JaTAg@mail.gmail.com>
In-Reply-To: <CADvbK_eCmDbAZ6_tppe=q3aW76OAnfZd3TXoAafDTk0h=JaTAg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIGFkdmljZSwgSSB3aWxsIGZpeCBpdCBhcyB5b3Ugc3VnZ2VzdCBhbmQg
c2VuZCBwYXRjaCB2MiA6KQ0KDQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IFhp
biBMb25nIFttYWlsdG86bHVjaWVuLnhpbkBnbWFpbC5jb21dIA0K5Y+R6YCB5pe26Ze0OiAyMDIx
5bm0NuaciDHml6UgMDoyNA0K5pS25Lu25Lq6OiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNA
aHVhd2VpLmNvbT4NCuaKhOmAgTogVmxhZCBZYXNldmljaCA8dnlhc2V2aWNoQGdtYWlsLmNvbT47
IE5laWwgSG9ybWFuIDxuaG9ybWFuQHR1eGRyaXZlci5jb20+OyBNYXJjZWxvIFJpY2FyZG8gTGVp
dG5lciA8bWFyY2Vsby5sZWl0bmVyQGdtYWlsLmNvbT47IGRhdmVtIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IGxpbnV4LXNjdHAgQCB2Z2Vy
IC4ga2VybmVsIC4gb3JnIDxsaW51eC1zY3RwQHZnZXIua2VybmVsLm9yZz47IG5ldHdvcmsgZGV2
IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZz4NCuS4u+mimDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gc2N0cDogc21fc3RhdGVmdW5zOiBG
aXggc3BlbGxpbmcgbWlzdGFrZXMNCg0KT24gU3VuLCBNYXkgMzAsIDIwMjEgYXQgOTo0OCBQTSBa
aGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+IHdyb3RlOg0KPg0KPiBGaXgg
c29tZSBzcGVsbGluZyBtaXN0YWtlcyBpbiBjb21tZW50czoNCj4gZ2VuZXJlYXRlID09PiBnZW5l
cmF0ZQ0KPiBjb3JyZWNsdHkgPT0+IGNvcnJlY3RseQ0KPiBib3VuZHJpZXMgPT0+IGJvdW5kYXJp
ZXMNCj4gZmFpbGVzID09PiBmYWlscw0KDQpJIGJlbGlldmUgbW9yZSBtaXN0YWtlcyBiZWxvdyBp
biB0aGlzIGZpbGUgY291bGQgaGl0Y2hoaWtlIHRoaXMgcGF0Y2ggdG8gZ2V0IGZpeGVkLiA6LSkN
Cg0KaXNzZXMgLT4gaXNzdWVzDQphc3NvY2l0aW9uIC0+IGFzc29jaWF0aW9uDQpzaWduZSAtPiBz
aWduDQphc3NvY2FpdGlvbiAtPiBhc3NvY2lhdGlvbg0KbWFuYWdlbWVtZW50LT4gbWFuYWdlbWVu
dA0KcmVzdHJhbnNtaXNzaW9ucy0+cmV0cmFuc21pc3Npb24NCnNpZGVmZmVjdCAtPiBzaWRlZWZm
ZWN0DQpib21taW5nIC0+IGJvb21pbmcNCmNodWtucy0+IGNodW5rcw0KU0hVRE9XTiAtPiBTSFVU
RE9XTg0KdmlvbGF0aW9uZy0+dmlvbGF0aW5nDQpleHBsY2l0bHktPiBleHBsaWNpdGx5DQpDSHVu
ay0+IENodW5rDQoNClRoYW5rcy4NCg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBaaGVuZyBZb25nanVu
IDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgbmV0L3NjdHAvc21fc3RhdGVm
dW5zLmMgfCA4ICsrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMg
Yi9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYyBpbmRleCANCj4gZmQxZTMxOWVkYTAwLi42OGU3ZDE0
YzM3OTkgMTAwNjQ0DQo+IC0tLSBhL25ldC9zY3RwL3NtX3N0YXRlZnVucy5jDQo+ICsrKyBiL25l
dC9zY3RwL3NtX3N0YXRlZnVucy5jDQo+IEBAIC02MDgsNyArNjA4LDcgQEAgZW51bSBzY3RwX2Rp
c3Bvc2l0aW9uIHNjdHBfc2ZfZG9fNV8xQ19hY2soc3RydWN0IG5ldCAqbmV0LA0KPiAgICAgICAg
IHNjdHBfYWRkX2NtZF9zZihjb21tYW5kcywgU0NUUF9DTURfTkVXX1NUQVRFLA0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICBTQ1RQX1NUQVRFKFNDVFBfU1RBVEVfQ09PS0lFX0VDSE9FRCkpOw0K
Pg0KPiAtICAgICAgIC8qIFNDVFAtQVVUSDogZ2VuZXJlYXRlIHRoZSBhc3NvY2l0aW9uIHNoYXJl
ZCBrZXlzIHNvIHRoYXQNCj4gKyAgICAgICAvKiBTQ1RQLUFVVEg6IGdlbmVyYXRlIHRoZSBhc3Nv
Y2l0aW9uIHNoYXJlZCBrZXlzIHNvIHRoYXQNCj4gICAgICAgICAgKiB3ZSBjYW4gcG90ZW50aWFs
bHkgc2lnbmUgdGhlIENPT0tJRS1FQ0hPLg0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIHNjdHBf
YWRkX2NtZF9zZihjb21tYW5kcywgU0NUUF9DTURfQVNTT0NfU0hLRVksIFNDVFBfTlVMTCgpKTsg
DQo+IEBAIC04MzgsNyArODM4LDcgQEAgZW51bSBzY3RwX2Rpc3Bvc2l0aW9uIHNjdHBfc2ZfZG9f
NV8xRF9jZShzdHJ1Y3QgDQo+IG5ldCAqbmV0LA0KPg0KPiAgICAgICAgIC8qIEFkZCBhbGwgdGhl
IHN0YXRlIG1hY2hpbmUgY29tbWFuZHMgbm93IHNpbmNlIHdlJ3ZlIGNyZWF0ZWQNCj4gICAgICAg
ICAgKiBldmVyeXRoaW5nLiAgVGhpcyB3YXkgd2UgZG9uJ3QgaW50cm9kdWNlIG1lbW9yeSBjb3Jy
dXB0aW9ucw0KPiAtICAgICAgICAqIGR1cmluZyBzaWRlLWVmZmVjdCBwcm9jZXNzaW5nIGFuZCBj
b3JyZWNsdHkgY291bnQgZXN0YWJsaXNoZWQNCj4gKyAgICAgICAgKiBkdXJpbmcgc2lkZS1lZmZl
Y3QgcHJvY2Vzc2luZyBhbmQgY29ycmVjdGx5IGNvdW50IA0KPiArIGVzdGFibGlzaGVkDQo+ICAg
ICAgICAgICogYXNzb2NpYXRpb25zLg0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIHNjdHBfYWRk
X2NtZF9zZihjb21tYW5kcywgU0NUUF9DTURfTkVXX0FTT0MsIA0KPiBTQ1RQX0FTT0MobmV3X2Fz
b2MpKTsgQEAgLTI5NTAsNyArMjk1MCw3IEBAIGVudW0gc2N0cF9kaXNwb3NpdGlvbiBzY3RwX3Nm
X2RvXzlfMl9yZXNodXRhY2soDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgY29tbWFuZHMpOw0KPg0KPiAgICAgICAgIC8qIFNpbmNlIHdlIGFyZSBu
b3QgZ29pbmcgdG8gcmVhbGx5IHByb2Nlc3MgdGhpcyBJTklULCB0aGVyZQ0KPiAtICAgICAgICAq
IGlzIG5vIHBvaW50IGluIHZlcmlmeWluZyBjaHVuayBib3VuZHJpZXMuICBKdXN0IGdlbmVyYXRl
DQo+ICsgICAgICAgICogaXMgbm8gcG9pbnQgaW4gdmVyaWZ5aW5nIGNodW5rIGJvdW5kYXJpZXMu
ICBKdXN0IGdlbmVyYXRlDQo+ICAgICAgICAgICogdGhlIFNIVVRET1dOIEFDSy4NCj4gICAgICAg
ICAgKi8NCj4gICAgICAgICByZXBseSA9IHNjdHBfbWFrZV9zaHV0ZG93bl9hY2soYXNvYywgY2h1
bmspOyBAQCAtMzU2MCw3IA0KPiArMzU2MCw3IEBAIGVudW0gc2N0cF9kaXNwb3NpdGlvbiBzY3Rw
X3NmX2RvXzlfMl9maW5hbChzdHJ1Y3QgbmV0ICpuZXQsDQo+ICAgICAgICAgICAgICAgICBnb3Rv
IG5vbWVtX2NodW5rOw0KPg0KPiAgICAgICAgIC8qIERvIGFsbCB0aGUgY29tbWFuZHMgbm93IChh
ZnRlciBhbGxvY2F0aW9uKSwgc28gdGhhdCB3ZQ0KPiAtICAgICAgICAqIGhhdmUgY29uc2lzdGVu
dCBzdGF0ZSBpZiBtZW1vcnkgYWxsb2NhdGlvbiBmYWlsZXMNCj4gKyAgICAgICAgKiBoYXZlIGNv
bnNpc3RlbnQgc3RhdGUgaWYgbWVtb3J5IGFsbG9jYXRpb24gZmFpbHMNCj4gICAgICAgICAgKi8N
Cj4gICAgICAgICBzY3RwX2FkZF9jbWRfc2YoY29tbWFuZHMsIFNDVFBfQ01EX0VWRU5UX1VMUCwg
DQo+IFNDVFBfVUxQRVZFTlQoZXYpKTsNCj4NCj4gLS0NCj4gMi4yNS4xDQo+DQo=
