Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6541A5565C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfFYRyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:54:20 -0400
Received: from mail-eopbgr30057.outbound.protection.outlook.com ([40.107.3.57]:34784
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfFYRyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhiohodLnhn4I72LpLaF+m7yl9oxKCAhTj1yE8L27Z8=;
 b=i/wBX+jrMAOZRvdXrPz1WaENkZQ5ciYnVTKxcBy5q4o+RAn9cwxkXhWUfdxwUs+PxauMcdWwo82NdxD6ucwUpxGCucg5MNu0X9RFhsuQ7wCfo5zI3V6o/9d3T2R6itq3RnZXhxi8rybaPVrKob8u4vu3k+vude8jTRi4XqIk4mk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:54:16 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:54:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/1] Fix broken build of mlx5
Thread-Topic: [PATCH 0/1] Fix broken build of mlx5
Thread-Index: AQHVK2p5cHu0NxJ3VEyhqsMR/NsxyqaspysA
Date:   Tue, 25 Jun 2019 17:54:16 +0000
Message-ID: <134e3a684c27fddeeeac111e5b4fac4093473731.camel@mellanox.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
In-Reply-To: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f71b392c-fe99-4460-5f32-08d6f9962434
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-microsoft-antispam-prvs: <DB6PR0501MB26801E3AE6D924AE8673B0E0BEE30@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(39860400002)(136003)(199004)(189003)(6116002)(5640700003)(4744005)(14444005)(6512007)(58126008)(2501003)(5660300002)(8936002)(3846002)(54906003)(316002)(25786009)(66446008)(64756008)(446003)(36756003)(4326008)(66946007)(2906002)(256004)(2616005)(66476007)(118296001)(486006)(73956011)(76116006)(66556008)(91956017)(478600001)(11346002)(1361003)(476003)(8676002)(99286004)(26005)(6436002)(2351001)(66066001)(81156014)(6486002)(229853002)(81166006)(6246003)(14454004)(71200400001)(71190400001)(186003)(102836004)(6916009)(305945005)(7736002)(76176011)(68736007)(6506007)(53936002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sMiAXLajAl09gtH6EyX/N/e5cC+X76PBJz9cGz0cgV8A/7pTQuAfSNV5+04wzHojfvg+WOixLVfOADsdO238Fy0W5zERW4yfbMSud1c81l5a+q/K/RT6S/3POQfgVfBjHIloTIsTElh0cfO5DWlE7wy8DhnaDkq7moaW5DdIOnTaUQvCSZXxcUi65FlFGdx6mk1CrKeVbsgb7XIMrBZmXC5lr6+KKeMnt+ZXPKSUkXm5FDhg0kMkI6gwTk+LFFB3KhBN4fW+iFfHIPwm4qgChJPaCGuM1WMESP/2uUGls3etYyCsC54EZDXHpSyygwTchdG0r4JApRVA0PAPMDRtPus7keBDr8epLbvOC/hWE+LX7IXS6VZhcDXmerSU5/YLOsMfzy39ClV9TsYfyK7igp71kKpVDATSfbpWYleqMdA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04D60889E10A1545A2FE09FF0409E90C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71b392c-fe99-4460-5f32-08d6f9962434
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:54:16.6045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDExOjI3IC0wNDAwLCBKZXMgU29yZW5zZW4gd3JvdGU6DQo+
IEZyb206IEplcyBTb3JlbnNlbiA8anNvcmVuc2VuQGZiLmNvbT4NCj4gDQo+IFRoaXMgZml4ZXMg
YW4gb2J2aW91cyBidWlsZCBlcnJvciB0aGF0IGNvdWxkIGhhdmUgYmVlbiBjYXVnaHQgYnkNCj4g
c2ltcGx5IGJ1aWxkaW5nIHRoZSBjb2RlIGJlZm9yZSBwdXNoaW5nIG91dCB0aGUgcGF0Y2guDQo+
IA0KDQpIaSBKZXMsDQoNCkp1c3QgdGVzdGVkIGFnYWluLCBhcyBJIGhhdmUgdGVzdGVkIGJlZm9y
ZSBzdWJtaXR0aW5nIHRoZSBibGFtZWQgcGF0Y2gsDQphbmQgYXMgd2UgdGVzdCBvbiBldmVyeSBz
aW5nbGUgbmV3IHBhdGNoIGluIG91ciBidWlsZCBhdXRvbWF0aW9uLg0KDQpib3RoIGNvbWJpbmF0
aW9ucyBDT05GSUdfTUxYNV9FTl9SWE5GQz15L24gd29yayBvbiBsYXRlc3QgbmV0LW5leHQsDQp3
aGF0IGFtIGkgbWlzc2luZyA/DQoNCj4gQ2hlZXJzLA0KPiBKZXMNCj4gDQo+IA0KPiBKZXMgU29y
ZW5zZW4gKDEpOg0KPiAgIG1seDU6IEZpeCBidWlsZCB3aGVuIENPTkZJR19NTFg1X0VOX1JYTkZD
IGlzIGRpc2FibGVkDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX2V0aHRvb2wuYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
