Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85EF5599C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFYVCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:02:04 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:38774
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfFYVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 17:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rcZJyAy0djTBb/QGfffW21WO3JTTv4l62QZvWSlSdk=;
 b=i2EVdQactKeRhdpObURPA70JSkoaD3XcjRL35sEJUMed6Arn6si92SN1Cp4HGdOrg5oYIoMsZQtDm+DtgcYPsjPKvvmlE3eUzPhgiZ0EA1oC8wT9WjKrymojmZLEKVxq9/BtVrtrYfCT3UbfZKZEEl8kXrUN/vdWeFo2gB5DMj8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2792.eurprd05.prod.outlook.com (10.172.225.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 21:01:59 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 21:01:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled
Thread-Topic: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is
 disabled
Thread-Index: AQHVK2p9akCcAZ4D0Eim+TyKOGELBqas09MAgAAHyQA=
Date:   Tue, 25 Jun 2019 21:01:58 +0000
Message-ID: <91260adb2227e477647afda66fdff9d9a9f52c60.camel@mellanox.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
         <20190625152708.23729-2-Jes.Sorensen@gmail.com>
         <20190625.133404.1626801368802216614.davem@davemloft.net>
In-Reply-To: <20190625.133404.1626801368802216614.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6894a31b-91d7-48c1-a3f4-08d6f9b05d12
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2792;
x-ms-traffictypediagnostic: DB6PR0501MB2792:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2792C0F973B75A0A473C5B42BEE30@DB6PR0501MB2792.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(2616005)(91956017)(76116006)(36756003)(8936002)(486006)(54906003)(256004)(26005)(446003)(68736007)(476003)(71190400001)(229853002)(7736002)(71200400001)(58126008)(4744005)(81156014)(99286004)(66476007)(66446008)(64756008)(14454004)(66556008)(73956011)(66946007)(6306002)(2501003)(8676002)(81166006)(6512007)(2906002)(186003)(102836004)(478600001)(11346002)(316002)(118296001)(110136005)(305945005)(6436002)(76176011)(6506007)(3846002)(6486002)(66066001)(14444005)(5660300002)(86362001)(25786009)(966005)(6246003)(4326008)(53936002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2792;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G3uUfAJe6ChmSWLxKF5EbxqIagLQ/cfomHEeief8AKHgD6B4wWzoUAEG55Lh0HRGaJtC8M9nDdiz6GKExmUQ2shPZN8WcJchfUDuoYhof5gbxH58Mls0PesXe1J0Eip5v8FgV37zp7IsSBmrY1hL3L5IkAKgj+ZIlm5+hpl4S+jyhyUtJAFgw5aqENdhOtvnSmTPuFpSDXuAjK71Nv+Uto33X/Hu4PKvOIfnY4XXymJwVxjRvh70hzQFobbi1OuuoaDlb7qFn+qnprK+xGbvtGJYBF1Tw7gtmH/IWqROSx1ypXpZi8FzH2jNrS0pkOrzUhTjQJp/Q8EKsyB1NTcwfhv6hJzxI1HVIzOVY8uCM6G6e1lV8ujXLPmFVkdJU9KANNN+0DH+pHGV/dcmqodfxEq4K6bUqYS3A1wcHQaqCxY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F45638A7EA182047A15960DFCC3B56BB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6894a31b-91d7-48c1-a3f4-08d6f9b05d12
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 21:01:59.0146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDEzOjM0IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEplcyBTb3JlbnNlbiA8amVzLnNvcmVuc2VuQGdtYWlsLmNvbT4NCj4gRGF0ZTogVHVl
LCAyNSBKdW4gMjAxOSAxMToyNzowOCAtMDQwMA0KPiANCj4gPiBGcm9tOiBKZXMgU29yZW5zZW4g
PGpzb3JlbnNlbkBmYi5jb20+DQo+ID4gDQo+ID4gVGhlIHByZXZpb3VzIHBhdGNoIGJyb2tlIHRo
ZSBidWlsZCB3aXRoIGEgc3RhdGljIGRlY2xhcmF0aW9uIGZvcg0KPiA+IGEgcHVibGljIGZ1bmN0
aW9uLg0KPiA+IA0KPiA+IEZpeGVzOiA4ZjA5MTZjNmRjNWMgKG5ldC9tbHg1ZTogRml4IGV0aHRv
b2wgcnhmaCBjb21tYW5kcyB3aGVuDQo+ID4gQ09ORklHX01MWDVfRU5fUlhORkMgaXMgZGlzYWJs
ZWQpDQo+ID4gU2lnbmVkLW9mZi1ieTogSmVzIFNvcmVuc2VuIDxqc29yZW5zZW5AZmIuY29tPg0K
PiANCj4gU2FlZWQsIEknbSBhc3N1bWluZyBJIHdpbGwgZ2V0IHRoaXMgdmlhIHlvdXIgbmV4dCBw
dWxsIHJlcXVlc3Qgb25jZQ0KPiB0aGluZ3MNCj4gYXJlIHNvcnRlZC4NCj4gDQoNCldlbGwsIGkg
dGhpbmsgdGhlcmUgaXMgbm8gaXNzdWUgaW4gdXBzdHJlYW0sIGJ1dCB5ZXMgYmFzaWNhbGx5IHlv
dSBjYW4NCmRlbGVnYXRlIHRoaXMgdG8gbWUuDQoNCkJUVyBpcyB0aGVyZSBhIHdheSB0byBjbGVh
ciB1cCAiQXdhaXRpbmcgVXBzdHJlYW0iIGNsdXR0ZXIgWzFdIGZvciBtbHg1DQpwYXRjaGVzIHRo
YXQgYXJlIGFscmVhZHkgcHVsbGVkID8NCg0KWzFdIA0KaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJz
Lm9yZy9wcm9qZWN0L25ldGRldi9saXN0Lz9zZXJpZXM9JnN1Ym1pdHRlcj0mc3RhdGU9OCZxPW1s
eDUmYXJjaGl2ZT0mZGVsZWdhdGU9DQoNCj4gVGhhbmtzLg0K
