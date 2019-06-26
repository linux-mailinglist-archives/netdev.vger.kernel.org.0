Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4557154
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfFZTI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:08:28 -0400
Received: from mail-eopbgr20084.outbound.protection.outlook.com ([40.107.2.84]:61926
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbfFZTI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNzIYdHSiRI2DcumZNzVF8DxNAbVUs4W7PXKtc/ucGc=;
 b=jpYBUc/IaBrcnOCbdfESpOCb3pz+F70t77bnyuBvlsFTjhpbovwZ1zRDJp0vUpJtEIcwL703JYXi6ORz6HNjvqpt2v09tjQj4reQpHP+UXPsuAfr/p0DL92QxTMCvD0i6zTHDkHVBl6Sgf/AM3eFolSqpoEG+E/v0NedDPwwq5A=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2294.eurprd05.prod.outlook.com (10.168.56.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Wed, 26 Jun 2019 19:08:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 19:08:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled
Thread-Topic: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is
 disabled
Thread-Index: AQHVK2p9akCcAZ4D0Eim+TyKOGELBqas09MAgAAHyQCAAAHfAIABcLyA
Date:   Wed, 26 Jun 2019 19:08:24 +0000
Message-ID: <36b7d8e881b7d23a554cd6c6b939f26063bb69f6.camel@mellanox.com>
References: <20190625152708.23729-2-Jes.Sorensen@gmail.com>
         <20190625.133404.1626801368802216614.davem@davemloft.net>
         <91260adb2227e477647afda66fdff9d9a9f52c60.camel@mellanox.com>
         <20190625.140838.717376362398793833.davem@davemloft.net>
In-Reply-To: <20190625.140838.717376362398793833.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bc5e618-fb43-46b0-24ca-08d6fa69a9e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2294;
x-ms-traffictypediagnostic: DB6PR0501MB2294:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2294893392070E65E8A6A15BBEE20@DB6PR0501MB2294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(366004)(136003)(39860400002)(199004)(189003)(6486002)(5660300002)(966005)(73956011)(8936002)(5640700003)(71190400001)(6436002)(1730700003)(71200400001)(81166006)(4744005)(76116006)(6306002)(91956017)(26005)(186003)(6512007)(256004)(66446008)(66556008)(64756008)(81156014)(6916009)(66946007)(66476007)(2906002)(6246003)(478600001)(8676002)(7736002)(53936002)(305945005)(446003)(2616005)(476003)(6116002)(76176011)(486006)(14454004)(3846002)(102836004)(6506007)(4326008)(54906003)(86362001)(229853002)(2351001)(68736007)(11346002)(316002)(2501003)(58126008)(36756003)(99286004)(66066001)(25786009)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2294;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +8EODvHJxPIdV5JQNpeHWis1t7SwYGyG3JCn8WD8HhA3WLIZ18JyKnRg0/MDwLdoC+qbC00MiAlpR5+EtwLgtxEv8yUcQAyWPXxa/65Lfk8ZSAuUYY+DwDTuLQK3ih4GryeBWtUX637WhIc8DT2r69GM/4LzlzQX8ASPD2A0lSgGJJWrZEW7Zn0gh7vCNaXEJAJ/6GoGwHhqUuLJGGSwXiA8EJRN1oxI08RcYiomRj3v3xmozqJppQgg5SMuYkKXYbSgIgWHoVpcyNgz6gsfEWIzqdCbZBaz7cTiLM1Dzx/7OCRAYaZuC+Z2vpqq5E/RjbgJnxjmp0Hf3YHKMSIiXaakxu666+CvOHoUK5+KI9KcXKRrYUy7QzgmQHeP6mMXR0D5XmZABoxGilxkiRJxL+J+rCaa1roPpr2QMBaWJOM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC8BB035201E6C40BA6C90F33951C9BF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc5e618-fb43-46b0-24ca-08d6fa69a9e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 19:08:24.7738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2294
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDE0OjA4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUs
IDI1IEp1biAyMDE5IDIxOjAxOjU4ICswMDAwDQo+IA0KPiA+IEJUVyBpcyB0aGVyZSBhIHdheSB0
byBjbGVhciB1cCAiQXdhaXRpbmcgVXBzdHJlYW0iIGNsdXR0ZXIgWzFdIGZvcg0KPiA+IG1seDUN
Cj4gPiBwYXRjaGVzIHRoYXQgYXJlIGFscmVhZHkgcHVsbGVkID8NCj4gPiANCj4gPiBbMV0gDQo+
ID4gaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wcm9qZWN0L25ldGRldi9saXN0Lz9zZXJp
ZXM9JnN1Ym1pdHRlcj0mc3RhdGU9OCZxPW1seDUmYXJjaGl2ZT0mZGVsZWdhdGU9DQo+IA0KPiBJ
IGRvbid0IHVuZGVyc3RhbmQgd2hhdCB0aGUgcHJvYmxlbSBpcy4gIEV2ZXJ5dGhpbmcgdGhlcmUg
aXMgaW4gdGhlDQo+IGFwcHJvcHJpYXRlIHN0YXRlLg0KPiANCj4gV2hlbiBzb21ldGhpbmcgaGl0
cyBuZXRkZXYgdGhhdCBkb2Vzbid0IGdvIGRpcmVjdGx5IHRvIG15IHRyZWUsDQo+IHRoYXQncw0K
PiB0aGUgYXBwcm9wcmF0ZSBzdGF0ZSBmb3JldmVyLg0KPiANCg0KSSBzZWUsIFRoYW5rcyBmb3Ig
Y2xhcmlmeWluZy4gDQoNCg==
