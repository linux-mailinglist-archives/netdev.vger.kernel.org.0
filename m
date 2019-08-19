Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28E691D4E
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 08:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfHSGr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 02:47:27 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:30064
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfHSGr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 02:47:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDBB/kSoIW1oBCeUqzW2XHLkMfn/YjQAtL/cQXmm13Y3E3XpL+uQZn2ZCK2Y/F7QAQiWN6eMQBn3Bdns/Rng+INuHFz9jDICZJJMU0NhMgHWOgtAoiM5deWQr0pOsxLnbZLmt0h7dRSjv+f4nQOu0HyKkaGkSPnWcFqIHGZw8+Ns22RQPW7eRX0THWVbjmwTQf+FMlaIG5oi4ZtT9qOWMLnWSBRVCJzwCg7P2TgY+KZ1kMCu2jbSIFkHIfrUVvZ6doop/Mvqshrgyq3cD6g0oF9kloRtavouyicqsVEm2dzjntihRP9Dwwh/7kHqS7rLrQENw7tu015SA5iYgcZVlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYAiGBHqPhp2zNADVP0h/MlKH9V518hs+1TcHJgvLqM=;
 b=aTPPh7U0X9rBSpwEvKGo0R9e7BzNQHzRqZN8u5b8kCIfxM1aNFo1dNCp8aXdxGX8Wdodt7PBCzCb+R/snRJnQ7mQl3HeI6qZrNsfjG8xezB/bF0rqJOoP5gv9MygGXFUv+3yTdODC0vvF0J2cGDoJ6WSupFSKXDNqYPQQwZmrH5RREYktug99tp/nhlJfILxFI9BIaptmMuW5mfY9tQefB2PkMCAttZMCIR0Q+e72C+kKzT4SOLlplp5iylcjtL2Ea+O4CJbnxdMCh8/bgiYsAujeZ+YewTT5bR06Ui9ducwfANX9SRzLTZJxHI15eNyFTFyiuSu602mzcXReS3vhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYAiGBHqPhp2zNADVP0h/MlKH9V518hs+1TcHJgvLqM=;
 b=WydUvXWQX+o19g0qoIP8yRYlaq0WCTEXptktqQ9ojzRr0mnZigQPgvOoGcfCAnFIj4XtBXGVI+uo8Uetk4Gr1e66PLkCdN2sd1nsRJyU0eHsKIYDKvOt6o5/bGyEg59OGs+/zFExFAFzETKwx5pVY+sNVGIigzldbDj9ksqeRek=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4390.eurprd05.prod.outlook.com (52.135.168.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 06:47:20 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 06:47:20 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Yonghong Song <yhs@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Thread-Topic: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Thread-Index: AQHVVB0TkIi78FMQ3kSbHlkXUDVB+qb96KkAgABrUQCAA7ROgIAAA1+A
Date:   Mon, 19 Aug 2019 06:47:20 +0000
Message-ID: <f88c052e-bc75-9e70-6e94-3dc581baf5f4@mellanox.com>
References: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
 <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com>
 <2B143E7F-EE34-4298-B628-E2F669F89896@gmail.com>
 <CAJ8uoz1hY0P+xypkJYYi775SeSXnrrPSM5v0yTf3G+d2a3OhJg@mail.gmail.com>
In-Reply-To: <CAJ8uoz1hY0P+xypkJYYi775SeSXnrrPSM5v0yTf3G+d2a3OhJg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0202CA0035.eurprd02.prod.outlook.com
 (2603:10a6:3:e4::21) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5f67f02-7f5c-4d92-cd91-08d724711571
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR05MB4390;
x-ms-traffictypediagnostic: AM6PR05MB4390:
x-microsoft-antispam-prvs: <AM6PR05MB4390EE370680AD67B33D9225D1A80@AM6PR05MB4390.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(189003)(199004)(8936002)(81156014)(102836004)(86362001)(31696002)(6506007)(66556008)(64756008)(14454004)(66946007)(316002)(66446008)(81166006)(5660300002)(53546011)(66066001)(36756003)(71200400001)(386003)(71190400001)(478600001)(11346002)(446003)(476003)(186003)(26005)(52116002)(6116002)(3846002)(76176011)(486006)(6246003)(2616005)(2906002)(4326008)(31686004)(25786009)(6512007)(6436002)(53936002)(256004)(8676002)(6486002)(99286004)(229853002)(54906003)(110136005)(7736002)(305945005)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4390;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8+JzSaGekang7hPdzMFwbMSLm2vv7UZE+j8suMbq3fYQ7KAqbJj/df8RDr/007MNRNttnAxjPTfl74f59aJ7Vso6mVCaE8PBXIpWXpEAeSIPrVndbInsi69Y/QO+sBnmnqHlI/efvWp9hiw2prly/YvkIuIW1i+vMYXTC+EByd9q7GK6j9PJWBMOA4SnIgF0sCxwf2+3BCf6xNxjplSRHQCSIme6g++AULdHmKhRwvxBXZdtsn7Qq/vJvHuhV1dxnKMhe3grLlS3zR8iTsdswV+MxuJiDSGC593C7pAl3UitpvG+gOoJMuZ9bep1mPag+ti1G4SZ5LECM6oYujIQgg1ZlzmZ19y4BZKNLmrvAZuj2CHzMlWASuMMSzV12Fm3Ho4uM9ZGadMcY6fTYWr7Z+HVsTLH2OXfKFAMom+pkpw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB1F4B0195B84C4CA1D5A0FC56D38BD1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f67f02-7f5c-4d92-cd91-08d724711571
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 06:47:20.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fj4lLwM7g2pHT0ZqYglbAa4jRT2NLKOMmKm5uX540DBkdxyhPEVl9kzPZHbboAFB7MzNXTnT2YEY8HC0fTXFuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wOC0xOSAwOTozNSwgTWFnbnVzIEthcmxzc29uIHdyb3RlOg0KPiBPbiBTYXQsIEF1
ZyAxNywgMjAxOSBhdCAxMjowMiBBTSBKb25hdGhhbiBMZW1vbg0KPiA8am9uYXRoYW4ubGVtb25A
Z21haWwuY29tPiB3cm90ZToNCj4+DQo+Pg0KPj4NCj4+IE9uIDE2IEF1ZyAyMDE5LCBhdCA4OjM3
LCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4NCj4+PiBPbiA4LzE2LzE5IDM6MjYgQU0sIE1hZ251
cyBLYXJsc3NvbiB3cm90ZToNCj4+Pj4gVGhlIHpjIGlzIG5vdCB1c2VkIGluIHRoZSB4c2sgcGFy
dCBvZiBsaWJicGYsIHNvIGxldCB1cyByZW1vdmUgaXQuDQo+Pj4+IE5vdA0KPj4+PiBnb29kIHRv
IGhhdmUgZGVhZCBjb2RlIGx5aW5nIGFyb3VuZC4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTog
TWFnbnVzIEthcmxzc29uIDxtYWdudXMua2FybHNzb25AaW50ZWwuY29tPg0KPj4+PiBSZXBvcnRl
ZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gPiAtLS0NCj4+Pj4gICAgdG9vbHMvbGli
L2JwZi94c2suYyB8IDMgLS0tDQo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9ucygt
KQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBiL3Rvb2xzL2xp
Yi9icGYveHNrLmMNCj4+Pj4gaW5kZXggNjgwZTYzMC4uOTY4N2RhOSAxMDA2NDQNCj4+Pj4gLS0t
IGEvdG9vbHMvbGliL2JwZi94c2suYw0KPj4+PiArKysgYi90b29scy9saWIvYnBmL3hzay5jDQo+
Pj4+IEBAIC02NSw3ICs2NSw2IEBAIHN0cnVjdCB4c2tfc29ja2V0IHsNCj4+Pj4gICAgICAgaW50
IHhza3NfbWFwX2ZkOw0KPj4+PiAgICAgICBfX3UzMiBxdWV1ZV9pZDsNCj4+Pj4gICAgICAgY2hh
ciBpZm5hbWVbSUZOQU1TSVpdOw0KPj4+PiAtICAgIGJvb2wgemM7DQo+Pj4+ICAgIH07DQo+Pj4+
DQo+Pj4+ICAgIHN0cnVjdCB4c2tfbmxfaW5mbyB7DQo+Pj4+IEBAIC02MDgsOCArNjA3LDYgQEAg
aW50IHhza19zb2NrZXRfX2NyZWF0ZShzdHJ1Y3QgeHNrX3NvY2tldA0KPj4+PiAqKnhza19wdHIs
IGNvbnN0IGNoYXIgKmlmbmFtZSwNCj4+Pj4gICAgICAgICAgICAgICBnb3RvIG91dF9tbWFwX3R4
Ow0KPj4+PiAgICAgICB9DQo+Pj4+DQo+Pj4+IC0gICAgeHNrLT56YyA9IG9wdHMuZmxhZ3MgJiBY
RFBfT1BUSU9OU19aRVJPQ09QWTsNCj4+Pg0KPj4+IFNpbmNlIG9wdHMuZmxhZ3MgdXNhZ2UgaXMg
cmVtb3ZlZC4gRG8geW91IHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvDQo+Pj4gcmVtb3ZlDQo+Pj4g
ICAgICAgICAgIG9wdGxlbiA9IHNpemVvZihvcHRzKTsNCj4+PiAgICAgICAgICAgZXJyID0gZ2V0
c29ja29wdCh4c2stPmZkLCBTT0xfWERQLCBYRFBfT1BUSU9OUywgJm9wdHMsDQo+Pj4gJm9wdGxl
bik7DQo+Pj4gICAgICAgICAgIGlmIChlcnIpIHsNCj4+PiAgICAgICAgICAgICAgICAgICBlcnIg
PSAtZXJybm87DQo+Pj4gICAgICAgICAgICAgICAgICAgZ290byBvdXRfbW1hcF90eDsNCj4+PiAg
ICAgICAgICAgfQ0KPj4+IGFzIHdlbGwgc2luY2Ugbm9ib2R5IHRoZW4gdXNlcyBvcHRzPw0KPj4N
Cj4+IElJUkMsIHRoaXMgd2FzIGFkZGVkIHNwZWNpZmljYWxseSBpbg0KPj4gMjc2MWVkNGI2ZTE5
MjgyMDc2MGQ1YmE5MTM4MzRiMmJhMDVmZDA4Yw0KPj4gc28gdGhhdCB1c2VybGFuZCBjb2RlIGNv
dWxkIGtub3cgd2hldGhlciB0aGUgc29ja2V0IHdhcyBvcGVyYXRpbmcgaW4NCj4+IHplcm8tY29w
eQ0KPj4gbW9kZSBvciBub3QuDQo+IA0KPiBUaGFua3MgZm9yIHJlbWluZGluZyBtZSBKb25hdGhh
bi4NCj4gDQo+IFJvcGluZyBpbiBNYXhpbSBoZXJlIHNpbmNlIGhlIHdyb3RlIHRoZSBwYXRjaC4g
V2FzIHRoaXMgc29tZXRoaW5nIHlvdQ0KPiBwbGFubmVkIG9uIHVzaW5nIGJ1dCB0aGUgZnVuY3Rp
b25hbGl0eSB0aGF0IG5lZWRlZCBpdCB3YXMgcmVtb3ZlZD8gVGhlDQo+IHBhdGNoIHNldCBkaWQg
Z28gdGhyb3VnaCBhIG51bWJlciBvZiBjaGFuZ2VzIGluIHRoZSBsaWJicGYgYXJlYSwgaWYgSQ0K
PiByZW1lbWJlciBjb3JyZWN0bHkuDQo+IA0KPiBUaGVyZSBhcmUgdHdvIG9wdGlvbnM6IGVpdGhl
ciB3ZSByZW1vdmUgaXQsIG9yIHdlIGFkZCBhbiBpbnRlcmZhY2UgaW4NCj4geHNrLmggc28gdGhh
dCBwZW9wbGUgY2FuIHVzZSBpdC4gSSB2b3RlIGZvciB0aGUgbGF0dGVyIHNpbmNlIEkgdGhpbmsN
Cj4gaXQgY291bGQgYmUgdXNlZnVsLiBUaGUgc2FtcGxlIGFwcCBjb3VsZCB1c2UgaXQgYXQgbGVh
c3QgOi0pLg0KDQorMSwgbGV0J3MgZXhwb3NlIGl0IGFuZCBtYWtlIHhkcHNvY2sgcmVhZCBhbmQg
cHJpbnQgaXQuIEkgYWRkZWQgdGhpcyANCmZsYWcgdG8gbGliYnBmIHdoZW4gSSBhZGRlZCB0aGUg
YWJpbGl0eSB0byBxdWVyeSBpdCBmcm9tIHRoZSBrZXJuZWwsIGJ1dCANCkkgZGlkbid0IHBheSBh
dHRlbnRpb24gdGhhdCBzdHJ1Y3QgeHNrX3NvY2tldCB3YXMgcHJpdmF0ZSB0byBsaWJicGYsIGFu
ZCANCnhzay0+emMgY291bGRuJ3QgYmUgYWNjZXNzZWQgZXh0ZXJuYWxseS4NCg0KPiAvTWFnbnVz
DQo+IA0KPj4gLS0NCj4+IEpvbmF0aGFuDQoNCg==
