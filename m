Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7340F10EAB
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfEAVnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:43:46 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:31200
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfEAVnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylb/IypTse4n/hqXp2njqdE3rTXd0PJ6mbciuOaBn2Y=;
 b=SsbFAJny/6AQAMiLI+79TWtyI4j3V0rhKX12UMg25D/Pfp6D2LRyQeVKGXOOm+AN3igIEWWirpCRD2DhIkr1VaLVmMMK4FoZrYEnnEQ17mHvuHZqjdfllM3MD+ejweGd6UGY86+J14LSirAQO8AaXGp8hY3HOzlW49MAgzV2Bso=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5849.eurprd05.prod.outlook.com (20.179.8.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 1 May 2019 21:43:41 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:43:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next 00/15] Mellanox, mlx5 updates 2019-04-30
Thread-Topic: [pull request][net-next 00/15] Mellanox, mlx5 updates 2019-04-30
Thread-Index: AQHU/5TY1kPAmBtTQ0ixaWC/hkwT/qZWzraA
Date:   Wed, 1 May 2019 21:43:41 +0000
Message-ID: <79468feda900284552c40913cbbf7db6f750c453.camel@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f16f2fd4-7be3-4b55-fdda-08d6ce7e13fe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5849;
x-ms-traffictypediagnostic: DB8PR05MB5849:
x-microsoft-antispam-prvs: <DB8PR05MB5849477C0C34A61FB04E36FBBE3B0@DB8PR05MB5849.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(366004)(136003)(376002)(396003)(199004)(189003)(6506007)(2501003)(58126008)(6486002)(2351001)(478600001)(76176011)(316002)(2906002)(256004)(68736007)(66066001)(15650500001)(99286004)(2616005)(11346002)(186003)(229853002)(14454004)(476003)(6436002)(5640700003)(26005)(102836004)(446003)(486006)(71200400001)(64756008)(66476007)(66946007)(66446008)(66556008)(5660300002)(4744005)(305945005)(7736002)(71190400001)(73956011)(76116006)(91956017)(8676002)(1730700003)(81156014)(81166006)(8936002)(6916009)(86362001)(118296001)(3846002)(6116002)(6512007)(6246003)(36756003)(25786009)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5849;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5scx4ESh4IM1tfy/leRnRcwrfCsZvqguooL2AC4OIuLG2dXXI+6OdgZH2YyGVphqrTTQGzcrJcFoPqHiOTDSUWWNLadxzAp+gDYUyFTQVmZV0AZe7fnIKKlOh7I3GwD8htocLiM+jVGlnfXT64QTKjUGs0UlTsmFRxaB4TcqV/kd3JcH3CApxPW41ORmVVMgP1oD9+oXtW6DLO+tK4TdrLr17Zi/wL7OcZUhcFfU6roZfK842wHeFw+B99Yq2bKJexSSHvt03cCV/9TahfHGEFfC8bQ09Ic3dO6LYhTg7fmr+pS3qse3C0VG+GWo4xSQweWP4A/Z20c7CvqhwrQmT/4tWsgUKP23kqu9OsuFMLLQzbGwLbGrkEL6CwtzdG0VHQbXLTaBYSfKKB4vpZWyttWWskKLWcgYvUbOHc2hNbs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F9D6FFFDC166642BF7E84251A47357B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16f2fd4-7be3-4b55-fdda-08d6ce7e13fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:43:41.5072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5849
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA0LTMwIGF0IDIwOjM5ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZSwNCj4gDQo+IFRoaXMgc2VyaWVzIHByb3ZpZGVzIG1pc2MgdXBkYXRlcyB0byBt
bHg1IGRyaXZlci4NCj4gVGhlcmUgaXMgb25lIHBhdGNoIG9mIHRoaXMgc2VyaWVzIHRoYXQgaXMg
dG91Y2hpbmcgb3V0c2lkZSBtbHg1DQo+IGRyaXZlcjoNCj4gDQo+IGV0aHRvb2wuaDogQWRkIFNG
Ri04NDM2IGFuZCBTRkYtODYzNiBtYXggRUVQUk9NIGxlbmd0aCBkZWZpbml0aW9ucw0KPiBBZGRl
ZCBtYXggRUVQUk9NIGxlbmd0aCBkZWZpbmVzIGZvciBldGh0b29sIHVzYWdlOg0KPiAgICAgICNk
ZWZpbmUgRVRIX01PRFVMRV9TRkZfODYzNl9NQVhfTEVOICAgICA2NDANCj4gICAgICAjZGVmaW5l
IEVUSF9NT0RVTEVfU0ZGXzg0MzZfTUFYX0xFTiAgICAgNjQwDQo+ICAgICANCj4gVGhlc2UgZGVm
aW5pdGlvbnMgdXNlZCB0byBkZXRlcm1pbmUgdGhlIEVFUFJPTSBkYXRhDQo+IGxlbmd0aCB3aGVu
IHJlYWRpbmcgaGlnaCBlZXByb20gcGFnZXMuDQo+IA0KPiBGb3IgbW9yZSBpbmZvcm1hdGlvbiBw
bGVhc2Ugc2VlIHRhZyBsb2cgYmVsb3cuDQo+IA0KPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtu
b3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQo+IA0KPiBQbGVhc2Ugbm90ZSB0aGF0IHRoZSBz
ZXJpZXMgc3RhcnRzIHdpdGggYSBtZXJnZSBvZiBtbHg1LW5leHQgYnJhbmNoLA0KPiB0byByZXNv
bHZlIGFuZCBhdm9pZCBkZXBlbmRlbmN5IHdpdGggcmRtYSB0cmVlLg0KPiANCj4gVGhhbmtzLA0K
PiBTYWVlZC4NCj4gDQoNCkhpIERhdmUsIGkgd2lsbCBiZSBzZW5kaW5nIFYyIHRvIGluY2x1ZGUg
bGF0ZXN0IGZpeCBmcm9tIG1seDUtbmV4dA0KYnJhbmNoLg0KDQpvdGhlcndpc2UgbWx4NSB3aWxs
IGJlIGJyb2tlbi4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
