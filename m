Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972C8F8576
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLAhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:37:32 -0500
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:24550
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726906AbfKLAhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 19:37:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4Sfof5bTvEoAHYGn6kOggdYfGfl3IFfwD7tzKxGOn0Zgm37J6JqXG9naOaG65gEUev5Yecjwnkzx2H+wl1Rh27d1EETZ5DB9nqS7ul+vCAprmqKEjBipzP1gnqTVbAkQidrGAqJWeZkKTyQ0UCR9PlvN6szG6cnDAB+sM5JOcHRlZmJJAofmn1qAhHLKs1uIV3Cy1e7j3QwPLnlNvqPbAL47/OiMidTypH/VG4S9Chkap+w6dqp6/6Xw5MjuWcmVtXtuPBjThXnsi0ok2A2ks5zhwOSCkiLJr5IsnHc/1iZ7lQ4MIGoCrIQt3HAs712JHH28//0YIJzsDCQfRGIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0WD0j+MHGv2M5nwt8YEIOrY2WZLS6TEIbansldHpek=;
 b=KV7tHEoTowogiOwPrCBkWk/WJWxyiseVdDaOsnSZUueh8N1/JkxU9LJ4RQhMJue8vFWLJPExQbw/TncS4YK/bKH3AIK8hHF/4BydioScEedt1zRZAlJdk27KZx5W1FT6nLeidhNN7RmXxaTsxesR1mRJi1xBD2e4o8R1Kn90NDgH8jKt0fv58J7b/JQ3MpGMQHuNzvaIkwXHZ02DOs55hoRqnjKX/V46loBi9cy8Q1I7+REGt2adCGJV0ML5/fqipxq04GsXp6fo94bIu8JaK6Y16Ga41hUBVyUccjpTC3Fg14Kb0E8Hd4LQN/dbwRwcKYWjrxRexZuOUfpGBVbtfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0WD0j+MHGv2M5nwt8YEIOrY2WZLS6TEIbansldHpek=;
 b=ilYzFpvIctPs8IoEVINe76Q9ITAMKVgzHWG1JI8IMAD0H+6Sq2gPb1L8GxPTdf5D2QKmJ1oyIKLIu3izHdFTsWCGGZTebriuMD2e3PJBJ4FByb6SHDVjSIue+7VQfKz2FMFwG6jR1jvYjlIGkHiZ3MvSe+bxz+PUfFW0zJ49JO4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3262.eurprd05.prod.outlook.com (10.170.236.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 00:37:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:37:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 7/7] net/mlx5: TC: Offload flow table rules
Thread-Topic: [PATCH mlx5-next 7/7] net/mlx5: TC: Offload flow table rules
Thread-Index: AQHVmOic6Bgf9v9mR0+8zwrSE9f8waeGsOIA
Date:   Tue, 12 Nov 2019 00:37:27 +0000
Message-ID: <0ba19058c0b455fe0ef9e272e981f78a977c0b82.camel@mellanox.com>
References: <20191111233430.25120-1-pablo@netfilter.org>
         <20191111233430.25120-8-pablo@netfilter.org>
In-Reply-To: <20191111233430.25120-8-pablo@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7724b63-a8f2-4a49-f03b-08d767087e53
x-ms-traffictypediagnostic: VI1PR05MB3262:
x-microsoft-antispam-prvs: <VI1PR05MB3262E7AE505CE319E7851A95BE770@VI1PR05MB3262.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(199004)(189003)(4001150100001)(2906002)(118296001)(66476007)(66446008)(14444005)(256004)(2501003)(2351001)(25786009)(66946007)(81156014)(1730700003)(81166006)(8936002)(76116006)(3846002)(6116002)(8676002)(64756008)(91956017)(66556008)(71200400001)(71190400001)(6436002)(5640700003)(229853002)(6486002)(6512007)(36756003)(58126008)(54906003)(26005)(316002)(99286004)(186003)(102836004)(6506007)(2616005)(476003)(446003)(11346002)(486006)(4326008)(6246003)(5660300002)(76176011)(6916009)(66066001)(14454004)(86362001)(7736002)(305945005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3262;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VcaqtB3BKgoT34FVpVEtYapAQ79VqYaJZrFYh2cWd2cbPYXc94gIVoElNB4wFQdsfzpI7j3T2HLjfQlWPuJO12E1LNsPY7YWIMoH0X1ZXuVMf+zyw+Zl2ryKUDvxEr+QxwoyYuhi6qcQE9EQFdeLTggY3oIFebds5rcL+pnRszEEP5N3ah1ELJK+DCgdP9g5JN9XHBIxfYtC8KimVT1HlE6B914/k2Ik/VnzbxhgvzxL3AGJrMxTDzAzcf77QstE2638ClEg3k+10AHt3oWAIhBWMVUKt7GRB0CmEph2p3noSrvLZL85bYJm8VYndnH52ZglkK1e5xSTzkwfu9jktnMo0nz9P6GFkGpcOFchb3BZIEMy2ASDwzMec+scndhD82E96FI8a7wvDB/kdexpOvFHpGbd1+mPJ7gj0s4udaMBkR9Yb27tlxmMaZw8hnhv
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BD14DA7F6ECD54CA613DA4123FDC308@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7724b63-a8f2-4a49-f03b-08d767087e53
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 00:37:27.1574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Inl6fYIo77cLTQwUOH71eorzw/zB3iYIWnhA57M/LWqjzWZ/hka7otbfCE2Bb/9eEwGRbYXfqmZLF/Ru5VDeEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTEyIGF0IDAwOjM0ICswMTAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToNCj4gRnJvbTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCj4gDQo+IFNpbmNl
IGJvdGggdGMgcnVsZXMgYW5kIGZsb3cgdGFibGUgcnVsZXMgYXJlIG9mIHRoZSBzYW1lIGZvcm1h
dCwNCj4gd2UgY2FuIHJlLXVzZSB0YyBwYXJzaW5nIGZvciB0aGF0LCBhbmQgbW92ZSB0aGUgZmxv
dyB0YWJsZSBydWxlcw0KPiB0byB0aGVpciBzdGVlcmluZyBkb21haW4gLSBJbiB0aGlzIGNhc2Us
IHRoZSBuZXh0IGNoYWluIGFmdGVyDQo+IG1heCB0YyBjaGFpbi4NCj4gDQo+IElzc3VlOiAxOTI5
NTEwDQo+IENoYW5nZS1JZDogSTY4YmYxNGQ1Mzk4YjkxY2YyNmNjN2M3ZjE5ZGFiNjRiYTg3NTdj
MDENCj4gU2lnbmVkLW9mZi1ieTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NCj4gQWNrZWQtYnk6
IFBhYmxvIE5laXJhIEF5dXNvIDxwYWJsb0BuZXRmaWx0ZXIub3JnPg0KDQpTZXJpZXMgTEdUTSwg
DQoNCmNvdXBsZSBvZiB0aGluZ3M6DQogDQoxKSBQYXVsIHNob3VsZCBoYXZlIHJlbW92ZWQgSXNz
dWUgYW5kIGNoYW5nZS1JZCB0YWdzDQpJIGNhbiBkbyB0aGlzIG15c2VsZiB3aGVuIGkgYXBwbHkg
dGhvc2UgdG8gbXkgdHJlZXMuDQoNCjIpIHBhdGNoZXMgIzEuLiM2IGNhbiBwZXJmZWN0bHkgZ28g
bWx4NS1uZXh0LA0KYWxyZWFkeSB0cmllZCBhbmQgaSBoYWQgdG8gcmVzb2x2ZSBzb21lIHRyaXZp
YWwgY29uZmxpY3RzLCBidXQgYWxsDQpnb29kLg0KDQozKSB0aGlzIHBhdGNoIG5lZWRzIHRvIGJl
IG9uIHRvcCBvZiBuZXQtbmV4dCwgZHVlIHRvIGRlcGVuZGVuY3kgd2l0aCANClRDX1NFVFVQX0ZU
LCBJIHdpbGwgcmVzdWJtaXQgaXQgdGhyb3VnaCBteSBub3JtYWwgcHVsbCByZXF1ZXN0DQpwcm9j
ZWR1cmUgYWZ0ZXIgYXBwbHlpbmcgYWxsIG90aGVyIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgdG8g
bWx4NS1uZXh0DQpzaGFyZWQgYnJhbmNoLiANCg0KQWxsIHBhdGNoZXMgd2lsbCBsYW5kIGluIG5l
dC1uZXh0IGluIGNvdXBsZSBvZiBkYXlzLCBpIGd1ZXNzIHRoZXJlIGlzDQpubyBydXNoIHRvIGhh
dmUgdGhlbSB0aGVyZSBpbW1lZGlhdGVseSA/IA0KDQpUaGFua3MsDQpzYWVlZC4NCg0K
