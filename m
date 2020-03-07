Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0217D03F
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 22:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCGVVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 16:21:30 -0500
Received: from mail-eopbgr30061.outbound.protection.outlook.com ([40.107.3.61]:10400
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbgCGVV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Mar 2020 16:21:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+GV+95H7XyXQ0Pk51laXHOlrwEA6c4MhSOsy9VoHKhgB0njBphSa6gXtuMlt6596ZtBjE+6p9zS5pBaP4nXL325hwYYrI2IKTCKecRKw7IYvp+1ZDbSp5HO3YzQrUUfSJi7BIZ20Aub66FlK1tbePeIPA+ZPdtbKLU1M/f1g2g6Ukd+lhfeBRm2PLmUWiTgw9vG4Y58t7Qnx9Qef3EiuSGOvpbrpLAIboZ9803ypJlo+AT27MkeGNfdX2SnOrqqR14FKsk6sxwVXfWfLn4hDFoqu6dRcnCt16MVVXcd4RINnVKv55Rs8TDmdIrBb2WXTy2YZ3cvIIedAO5RF+mGIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Je/WasDkYyQXVOdk926lcllr0f7/oR83br8p7eUgdoc=;
 b=TeksVRA1IQeRhsfgvitmo9of0pxHmIb7SZGRV5xrM8TabNdCtd2bUbZEkGxskBrMY5J4qwSeSy+cDIlwa7+lvi3AyzplIJlYkOvNN3yDXOluTR01KIALJjMIQUz691XKnYrepPXVRClG0Yt8+9vhXd4SNlaun1M6qoDy8fjUmz7wE1D1KVdB9HkfOjs+OGWxTGG6nFSD/AqAp/EVlfG2WcaLG/+5q9p3BmOPZ76/E6E69ectzPJE4DEFjMcvBoUcTMHQGPfZEUlpnwLYvOYeHgoEdyYrlhqi82gtFLW8tRlZmmiVRIvhBQlfilithaaIs6YOEJBr2gbN8ixAKXnjbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Je/WasDkYyQXVOdk926lcllr0f7/oR83br8p7eUgdoc=;
 b=AFbshuxRXoae1izNTRUC1HlGRPNNsbRMidZprRHoLZQi5R65S2HVwc2REudvOdzUdxehSihix0I1+EmB/QG1lFQ+PwNNowCSvT/b7ikXZJSbA0HlqU2gNOI2c8U4DOnW9IE9JepdQG3xD9yIGdU/n+6rtdynl4NJa0GIIrhrfSY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3407.eurprd05.prod.outlook.com (10.170.238.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Sat, 7 Mar 2020 21:21:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Sat, 7 Mar 2020
 21:21:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/4] Mellanox, mlx5 next updates 2020-03-02
Thread-Topic: [PATCH mlx5-next 0/4] Mellanox, mlx5 next updates 2020-03-02
Thread-Index: AQHV8PDgKu7ZlYRuZUOtB8wbWM79Uag9qtMA
Date:   Sat, 7 Mar 2020 21:21:26 +0000
Message-ID: <8ea865ad4c19e3013a2b67980d113ae0e8db07be.camel@mellanox.com>
References: <20200303001522.54067-1-saeedm@mellanox.com>
In-Reply-To: <20200303001522.54067-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4b27e4b7-60db-4bc2-10b5-08d7c2dd7ef4
x-ms-traffictypediagnostic: VI1PR05MB3407:|VI1PR05MB3407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3407554F0B0AE4F2186E401EBEE00@VI1PR05MB3407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(396003)(366004)(136003)(376002)(199004)(189003)(6506007)(4326008)(450100002)(36756003)(54906003)(4744005)(26005)(8676002)(81166006)(6862004)(81156014)(186003)(8936002)(6636002)(6486002)(478600001)(2616005)(71200400001)(2906002)(66556008)(66446008)(64756008)(86362001)(66476007)(76116006)(5660300002)(316002)(91956017)(37006003)(15650500001)(66946007)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3407;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2sa/FVcR7TTOjtq1Nyiyvy74S5pQt8Mck1royvt8Uz5U6RgHq8+cLfH4+lFonm5uTt0zSJggHqdyZ6XKJdeyd5XH/EZTag/wvMPb3PE00WA53uVvnZEqdduirZVn/K2qc7x8nUY1ybJaWh5gUpRfOMfp3FdYOf5DGES5CTK/YRuyBIC+fBwRHKBLza3rxbUEDrqFc5+FhNmXQlsI4xqEW/P7xxpwB0N6ln+Mvnfvtw/3whaCGmmymnlYvgeT6wgusK+YFLAOBWw1M9PMVRtCLCciSvfqsYe6wue/75IKR6Kj0oKK/05srjetIuvJ7JFX5WYIxttCYLO22rxCQXzT0SkpvlbTWDlhxWhhXh2a01UUcso7lVny9MTwBSUKRT5XRTgDZCEuCkZFfZMBKGrGlcLGTmT7nvzwRBpvS+5Uk9kKjTVwnxIJv9FDcZw4UPgd
x-ms-exchange-antispam-messagedata: c8DX2lv5EQRNoXdADKZIB3hh8Gf39f81LyBBNq0E8Zo26g/mYRHcuBfNyO27wxa2Bo6afckfCBegX4M/tHl0dXcn8mWuYWbCkE6m5kJxBmJVtTnfUm2oauy8KV0eAThAzCnC6zXSGXT4U7sdwWSQtg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FBAEC794CA2C0449458E049AAF1BDE2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b27e4b7-60db-4bc2-10b5-08d7c2dd7ef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2020 21:21:26.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bEraeIJOw7NRNXzXd/x416E420r4uWaPDP6xdBeBeOUOQoWwXaoYxUcp+4op0H2JcKwMfohSausgVlTE18wLLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTAyIGF0IDE2OjE1IC0wODAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gQWRkaW5nIHNvbWUgSFcgYml0cyBhbmQgZGVmaW5pdGlvbnMgdG8gbWx4NS1uZXh0IHNoYXJl
ZCBicmFuY2ggZm9yDQo+IHVwY29taW5nIG1seDUgZmVhdHVyZXMuIA0KPiBOb3RoaW5nIG1ham9y
LCBmb3IgbW9yZSBpbmZvIHBsZWFzZSBzZWUgaW5kaXZpZHVhbCBjb21taXQgbWVzc2FnZXMuDQo+
IA0KPiBJbiBjYXNlIG9mIG5vIG9iamVjdGlvbiwgdGhlIHBhdGNoZXMgd2lsbCBiZSBhcHBsaWVk
IHRvIG1seDUtbmV4dCBhbmQNCj4gc2VudCBpbiBhIGZ1dHVyZSBwdWxsIHJlcXVlc3QgdG8gbmV0
LW5leHQgYW5kL29yIHJkbWEtbmV4dCB3aXRoIHRoZQ0KPiByZXNwZWN0aXZlIHVwY29taW5nIGZl
YXR1cmVzLg0KDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0DQoNCnRoYW5rcyENCg0K
