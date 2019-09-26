Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C58BF485
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfIZN4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:56:30 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:12205
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726094AbfIZN43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:56:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjN1Y8q1OixfbWX8QkGeLsk8t/2eYI4uVo7ie7JO0AhnB1OGzt8fc4klfwMeG/XNcxYCQXgCBxWGb8qhsSj6gEzc/FWYu6AMi9vYSk5GNkvyGeY3x0US7lTIgmtfUtWReqrKwL4PB+8mTPCUSwxuTvePufV1bDipc15b+zDI74cM0YmxnLAWcszgp5uXifIaVJB8z01BLsAjzSPiympeTVh4vJ/C2QPJs+lMeAMVlXuIq9a2C+iDJ+Xiqhzq6E3Ba/kss4q17i9JO5hXGUVTuKi6Cop0WJ+joxRKxuEjpkjwuzyOLRxXuFPiVZZ9O8xpQs1UqPxZJRdrVKsAdzLPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KDKYLazWOgVb0BTYwRZJiS1cRKFHrCuVJ6Iicjd3gk=;
 b=CMI+WIk2/O2C8w05Uyt4zuoKqd3i80a5Tz156PEcc56TBLbZsLhP0dSXH4g8or5f4uFXArr/Qb/x7IMGdMokGqp082FPTO+tPN3k0DeAJKGJ66Zd9wVbcJtKcKjs6Ls3stKtD8pSNimsX//YblJWB+caea1Z0uectoJi3UUpDqtxAU7ycHX8daXLIPw/h8UpICLfCf9Nm6boe8d3U8Fnnrf6KHPEmK7zp1rLcX+P9QNgkYluMsaxPvbjIvN+eSGrib/kl3JTctuPEw+zd9vVU9hIZ856Xsit7je4H/miYjlqIFaeahh1MajW+YU9L5DZjjog2P2RV1KK/4k1PQnZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KDKYLazWOgVb0BTYwRZJiS1cRKFHrCuVJ6Iicjd3gk=;
 b=kbvHev5HChfrz8cOtJAGUPeSZw8voX321JPD2kgUcCgKhZht47K1uTiugZFsHUmwBoYLN05VuPxlFLU0LOvkZ1uZlAc3RO7m35FJVb47OsoNV5PwaFo6rwumgSaU82IliVPd7UAkEeAAebq5XLRN95B3NuBG9U6MVG0a9YB6G3o=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3284.eurprd05.prod.outlook.com (10.171.186.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 26 Sep 2019 13:56:25 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 13:56:25 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Thread-Topic: CONFIG_NET_TC_SKB_EXT
Thread-Index: AQHVbtxxDxq98BXUU0W1ldTc//QoBKczG/uAgAGj5oCAAGQoAIAAC2iAgAATpQCAAcftgIAAGgkAgAB1cACAAKZjgIABc1wA///TvACAATZdAIAB6dAAgAElAoCAACxNgIAADSyA
Date:   Thu, 26 Sep 2019 13:56:24 +0000
Message-ID: <ecfb7918-7660-91f0-035e-56f58a41dc17@mellanox.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
 <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
 <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
 <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
 <541fde6d-01ce-edf3-84e4-153756aba00f@mellanox.com>
 <08f58572-26ed-e947-5b0c-73732ef7eb35@solarflare.com>
In-Reply-To: <08f58572-26ed-e947-5b0c-73732ef7eb35@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0048.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::36)
 To AM4PR05MB3411.eurprd05.prod.outlook.com (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab794de1-2788-4ed6-296f-08d7428951c5
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM4PR05MB3284:|AM4PR05MB3284:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB32849BB627231A86C8CC92F3CF860@AM4PR05MB3284.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(189003)(199004)(71200400001)(7736002)(110136005)(66066001)(25786009)(14454004)(54906003)(478600001)(14444005)(256004)(316002)(31686004)(6436002)(6246003)(76176011)(52116002)(6512007)(31696002)(4326008)(3846002)(99286004)(2906002)(86362001)(6116002)(6486002)(229853002)(81156014)(81166006)(8936002)(8676002)(5660300002)(186003)(386003)(6506007)(71190400001)(53546011)(486006)(102836004)(446003)(36756003)(11346002)(476003)(2616005)(305945005)(66446008)(66476007)(66556008)(64756008)(7116003)(66946007)(7416002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3284;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7tbm9ujRg3QJuxzrzglWhb58JTss32Q0H3LB7aimPeC9Rhsap8khgvJOQ5+boGRxoANJRU7HsoHcFKNIv4HHz4AJZaM8fRpbFt/hqkRYovZzCdhODaJ2SqjxI2z1MKSFoXslfuNeom6c0B6itfilv7OZpPst1ztw2OwT4LA6Q0G7r5SBukGEfLrkT6DG6ogcgL+eja7efsSENDuY9YIh1WY4KqPykN3p+eno7looenZ6EFVhsbI1QHez5CLfXLMW9TcfMs95QlxGGAhsR/eYzmQLmyxuXy/hsONLBFkeGtpOiMIhL087sTpReXR3kpksI2/OIStqqrqpGcdIeT2KUDWlOhuFUOZpThoJstAwJn8JV0Bm+Xtqi+SStpzWhuDXqV8RZbxD/3GOVvpHRQn7viCFKgI2NKNndRdCaycRjHc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33B7988C1DEA59489567C9FDD7E4F837@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab794de1-2788-4ed6-296f-08d7428951c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 13:56:24.8241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gML8QQBdX/HOoYPUPb/lRAqcg+tYHmpMwM4QCyhiI6dE0yB4iZjIPwLx/msItaj72d0bdyx9xPGdhRsUFs5mJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3284
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzI2LzIwMTkgNDowOSBQTSwgRWR3YXJkIENyZWUgd3JvdGU6DQo+IE9uIDI2LzA5LzIw
MTkgMDg6MzAsIFBhdWwgQmxha2V5IHdyb3RlOg0KPj4gT2ssIEkgdGhvdWdodCB5b3UgbWVhbnQg
bWVyZ2luZyB0aGUgcnVsZXMgYmVjYXVzZSB3ZSBkbyB3YW50IHRvIHN1cHBvcnQNCj4+IHRob3Nl
IG1vZGlmaWNhdGlvbnMgdXNlLWNhc2VzLg0KPiBJIHRoaW5rIHRoZSBwb2ludCBpcyB0aGF0IHlv
dXIgdXNlLWNhc2UgaXMgc3VmZmljaWVudGx5IHdlaXJkIGFuZA0KPiAgwqBvYnNjdXJlIHRoYXQg
Y29kZSBpbiB0aGUgY29yZSB0byBzdXBwb3J0IGl0IG5lZWRzIHRvIGJlIHVuaW50cnVzaXZlOw0K
PiAgwqBhbmQgdGhpcyBjbGVhcmx5IHdhc24ndCAoeW91IG1hbmFnZWQgdG8gcGlzcyBvZmYgTGlu
dXMuLi4pIHNvIGl0DQo+ICDCoHNob3VsZCBiZSByZXZlcnRlZCwgYW5kIGhlbGQgb2ZmIHVudGls
IGEgbW9yZSBwYWxhdGFibGUgc29sdXRpb24gY2FuDQo+ICDCoGJlIHByb2R1Y2VkLsKgIEkgYWdy
ZWUgd2l0aCBBbGV4ZWkgb24gdGhpcy4NCj4gTmVpdGhlciBjdXJyZW50bHktc3VwcG9ydGVkLWJ5
LWRyaXZlcnMgY2FzZXMgbm9yIHRoZSBmaXJzdCBzdGVwIHRoYXQncw0KPiAgwqBsaWtlbHkgdG8g
YmUgYWRkZWQgKHRoZSBzaW1wbGUgY29ubnRyYWNrIHdpdGggbW9kaWZpY2F0aW9ucyBvbmx5IGF0
DQo+ICDCoHRoZSBlbmQpIG5lZWRzIHRoaXMsIGl0J3MgZm9yIGNhcGFiaWxpdGllcyB0aGF0IGFy
ZSBmYXJ0aGVyIGluIHRoZQ0KPiAgwqBmdXR1cmUsIHNvIHRoZXJlJ3MgcmVhbGx5IG5vIG5lZWQg
Zm9yIGl0IHRvIGJlIGluIHRoZSB0cmVlIHdoZW4gaXQncw0KPiAgwqBub3QgcmVhZHksIHdoaWNo
IGFwcGVhcnMgdG8gYmUgdGhlIGNhc2UgYXQgcHJlc2VudC4NCg0KVGhlIHVzZS1jYXNlIGlzbid0
IHdlaXJkLCBhcyBJJ3ZlIGp1c3Qgc2hvd24sIGV2ZW4gbmF0IG5lZWRzIHRoYXQuIFNlZSANCmJl
bG93IHRoYXQgZXZlbiBPdlMgaGFzIHNlbGZ0ZXN0cyB0aGF0IHRlc3QgdGhhdC4NCg0KVGhhdCdz
IG5vcm1hbCBPdlMgbmF0LCB3aGljaCB5b3UgY2FuIHNlZSBpbiBtYW55IHVzZS1jYXNlcy4gWW91
IGNhbiB0YWtlIA0KYSBsb29rIGF0IGRpZmZlcmVudCBPdlMgY29udHJvbGxlcnMNCg0KYW5kIHlv
dSB3b3VsZCBzZWUgdGhlIHNhbWUgYmVoYXZpb3IuDQoNCg0KVGhpcyBpcyB0aGUgZmlyc3Qgc3Rl
cCB0aGF0IHdhcyByZXF1aXJlZCB0byBzdXBwb3J0IG9mZmxvYWRpbmcgDQpjb25uZWN0aW9uIHRy
YWNraW5nIGZyb20gT3ZTLg0KDQpXZSBhcmUgaW4gcHJvZ3Jlc3Mgb2Ygc3VibWl0dGluZyB0aGUg
dXNlcnNwYWNlIHBhdGNoZXMsIGFuZCB3b3VsZCBoYXZlIA0KZG9uZSBpdCB0b2RheSBpZiBpdCB3
ZXJlbid0Jw0KDQpmb3IgdGhpcyBDT05GSUcgZGlzY3Vzc2lvbi4gSXQgd2FzIGFscmVhZHkgc3Vi
bWl0dGVkIGFzIFJGQyBhbHJlYWR5Lg0KDQpPdXIgZHJpdmVyIGltcGxlbWVudGF0aW9uIGlzIHJl
YWR5IGFuZCB3ZSB3aWxsIHN1Ym1pdCBpdCBvbmNlIHVzZXJzcGFjZSANCmlzIGFjY2VwdGVkLg0K
DQo+PiBJbiBuYXQgc2NlbmFyaW9zIHRoZSBwYWNrZXQgd2lsbCBiZSBtb2RpZmllZCwgYW5kIHRo
ZW4gdGhlcmUgY2FuIGJlIGEgbWlzczoNCj4+DQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgIC10
cmsgLi4uLiBDVCh6b25lIFgsIFJlc3RvcmUgTkFUKSxnb3RvIGNoYWluIDENCj4+DQo+PiAgIMKg
wqDCoMKgwqDCoMKgwqDCoMKgICt0cmsrZXN0LCBtYXRjaCBvbiBpcHY0LCBDVCh6b25lIFkpLCBn
b3RvIGNoYWluIDINCj4+DQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgICt0cmsrZXN0LCBvdXRw
dXQuLg0KPiBJJ20gY29uZnVzZWQsIEkgdGhvdWdodCB0aGUgdXN1YWwgbmF0IHNjZW5hcmlvIGxv
b2tlZCBtb3JlIGxpa2UNCj4gIMKgwqDCoCAwOiAtdHJrIC4uLiBhY3Rpb24gY3Qoem9uZSB4KSwg
Z290byBjaGFpbiAxDQo+ICDCoMKgwqAgMTogK3RyaytuZXcgLi4uIGFjdGlvbiBjdChjb21taXQs
IG5hdD1mb28pICMgc3cgb25seQ0KPiAgwqDCoMKgIDE6ICt0cmsrZXN0IC4uLiBhY3Rpb24gY3Qo
bmF0KSwgbWlycmVkIGV0aDENCj4gaS5lLiB0aGUgTkFUIG9ubHkgaGFwcGVucyBhZnRlciBjb25u
dHJhY2sgaGFzIG1hdGNoZWQgKGFuZCB0aHVzIHByb3ZpZGVkDQo+ICDCoHRoZSBzYXZlZCBOQVQg
bWV0YWRhdGEpLCBhdCB0aGUgZW5kIG9mIHRoZSBwaXBlLsKgIEkgZG9uJ3Qgc2VlIGhvdyB5b3UN
Cj4gIMKgY2FuIE5BVCBhIC10cmsgcGFja2V0Lg0KDQpCb3RoIGFyZSB2YWxpZCwgTmF0IGluIHRo
ZSBmaXJzdCBob3AsIGV4ZWN1dGVzIHRoZSBuYXQgc3RvcmVkIG9uIHRoZSANCmNvbm5lY3Rpb24g
aWYgYXZhaWxhYmxlIChjb25maWd1cmVkIGJ5IGNvbW1pdCkuDQoNCllvdSBjYW4gc2VlIGl0IGlu
IG11bHRpcGxlIHVzZXMgaW4gb3ZzIHRlc3RzOsKgIGdpdCBncmVwIC1wbmkgDQoidGFibGU9MC4q
Y3QuKm5hdC4qIiB0ZXN0cy9zeXN0ZW0tdHJhZmZpYy5hdA0KDQpFdmVuIGFmdGVyIHlvdSByZXN0
b3JlIG5hdCwgeW91IGNhbiBqdW1wIHRvIGRpZmZlcmVudCB6b25lcywgb3IgZXZlbiANCmFnYWlu
IHRvIGFub3RoZXIgdGFibGUuLi4uDQoNCkkndmUgc2VlbiBtdWNoIGRlZXBlciByZS1jaXJjdWxh
dGlvbiBjaGFpbnMgKHdoaWNoIHVzdWFsbHkgbWVhbnMgQ1QoKSkgDQphY3Rpb24uDQoNClNlZSBv
dnMgc2VsZi10ZXN0cyBhcyByZWZlcmVuY2UuDQoNCg0KPg0KPj4gQWxzbywgdGhlcmUgYXJlIHN0
YXRzIGlzc3VlcyBpZiB3ZSBhbHJlYWR5IGFjY291bnRlZCBmb3Igc29tZSBhY3Rpb25zIGluDQo+
PiBoYXJkd2FyZS4NCj4gQUZBSUNUIG9ubHkgJ2RlbGl2ZXJpc2gnIGFjdGlvbnMgKGkuZS4gbWly
cmVkIGFuZCBkcm9wKSBpbiBUQyBoYXZlIHN0YXRzLg0KPiBTbyBzdGF0cyBhcmUgdW5saWtlbHkg
dG8gYmUgYSBwcm9ibGVtIHVubGVzcyB5b3UndmUgZ290IChzYXkpIGEgbWlycmVkDQo+ICDCoG1p
cnJvciBiZWZvcmUgeW91IHNlbmQgdG8gY3QgYW5kIGdvdG8gY2hhaW4sIGluIHdoaWNoIGNhc2Ug
dGhlIGV4dHJhDQo+ICDCoGNvcHkgb2YgdGhlIHBhY2tldCBpcyBhIHJhdGhlciBiaWdnZXIgcHJv
YmxlbSBmb3IgaWRlbXBvdGVuY3kgdGhhbiBtZXJlDQo+ICDCoHN0YXRzIDstKQ0KDQpBbGwgdGMg
YWN0aW9ucyBoYXZlIHNvZnR3YXJlIHN0YXRzLCBhbmQgYXQgbGVhc3Qgb25lIChnb3RvLCBtaXJy
ZWQsIA0KZHJvcCkgcGVyIE92UyBnZW5lcmF0ZWQgcnVsZSB3aWxsIGhhdmUgaGFyZHdhcmUgc3Rh
dHMuDQoNCkFsbCBPdlMgZGF0YXBhdGggcnVsZXMgaGF2ZSBzdGF0cywgYW5kIGluIHR1cm4gdGhl
IHRyYW5zbGF0ZWQgVEMgcnVsZXMgDQphbGwgaGF2ZSBzdGF0cy4gT3ZTIGFnZXMgZWFjaCBydWxl
IGluZGVwZW5kZW50bHkuDQoNCg==
