Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8379369
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbfG2Svn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:51:43 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:8134
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728342AbfG2Svm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:51:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCc0S8/zZ++O1Ol6BlO3lZA+NlLWnBs8GmGoNEYq8lQNm5/ytCx9TZcKK7pGxsfJcjdROPMrDHUxiFiuyfb/1UgQmu/ilA9IfgEVHPsBExPiElDh37NSZ2xEpRvqsjNdNXNnT/UDKPR5pa6goOppJ/RKluGLBxeKzIgEGPPQ+ZbdLkiT8+jmiQX/PbEP/2o6/56B+VRmf1bxduJgPE1FC1ybmQwC9SrAOmb6fRx1w0szJqE/K8q48SoNMtiqswzqMfVGpf0/8VOjhWXmb1CGWO/UZ1WIFAbPfYV5OAr8VYmGhXe1e9ze47b0Z4B1ADHTt3HfGl8f9NhtWQ6DOvOI7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS6ZyFGklzjUe8E9Wn/DzGAD6vBh1IX1sjSOdWdzqQQ=;
 b=JIaSMCGORev+vrtTCCc5iAejVNh9mQixoidSAcG+RzsB3M7J0eTmk8rk1rF+ErcJKO2VGHgumb6xdFHUSuwIfe5dvSZu3EOFoP6Omn1m1JSU3jw7pSqx7P7CmI2muhO63PLYdfFNMXbAIXwSk/Q6oSm0uZzn/lGWMGcrQ25caYupX3aUXrUqRAnVKIeB/zqFNfaPTlqvhTWC97SbfPk26kKgoUBFQXKU5ssuG0qHFZN/05XWHj5kJZqExLrMfjlLOOsXKj8B5SsTSrBoVcbk4xqR1SGcdlKgYOuxD/jtU+YzqvnETU3aY6FZNMj7S7EHtpvkWf1X8YaIPNWblwLHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS6ZyFGklzjUe8E9Wn/DzGAD6vBh1IX1sjSOdWdzqQQ=;
 b=L0uv2X3io+XeiRCBvKPuVLKnHU3yntux1+NaKj1n93k7ZPITbtW9Bk8vl1bglGrYqSOo+F9DWQIIrRyP8VdimGhBrILZbofJCQq4WhhvqOrl6o1I39DzPGnNdaYI8qYB1CNUiJnF0wWaVVpp/F81aLoayLK7VSrfwQ2+3sssykE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2822.eurprd05.prod.outlook.com (10.172.227.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 18:51:38 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 18:51:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>, Leon Romanovsky <leonro@mellanox.com>
CC:     Yishai Hadas <yishaih@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: fix -Wtype-limits compilation warnings
Thread-Topic: [PATCH] net/mlx5: fix -Wtype-limits compilation warnings
Thread-Index: AQHVQLxlv3OY64S2zEK8JohEEQAAcabh+9IA
Date:   Mon, 29 Jul 2019 18:51:38 +0000
Message-ID: <dc0c3064e253c4fdf2a2a8351995ff061d722588.camel@mellanox.com>
References: <1563820482-10302-1-git-send-email-cai@lca.pw>
In-Reply-To: <1563820482-10302-1-git-send-email-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5e70aa5-de7b-4ef1-0860-08d71455c9da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2822;
x-ms-traffictypediagnostic: DB6PR0501MB2822:
x-microsoft-antispam-prvs: <DB6PR0501MB2822036012FB5F6928080FC7BEDD0@DB6PR0501MB2822.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(189003)(199004)(6436002)(229853002)(7736002)(3846002)(305945005)(6116002)(58126008)(110136005)(54906003)(4326008)(316002)(478600001)(6636002)(26005)(2906002)(14444005)(71190400001)(71200400001)(6506007)(14454004)(11346002)(446003)(102836004)(76176011)(2616005)(6486002)(36756003)(6512007)(25786009)(256004)(6246003)(53936002)(186003)(66556008)(64756008)(66446008)(81166006)(81156014)(8936002)(8676002)(66946007)(118296001)(476003)(486006)(2501003)(66066001)(91956017)(86362001)(99286004)(68736007)(66476007)(5660300002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2822;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6GPZEPXx3FXdbDfPmcrE7Mxthqv/Ry70jYpWAoG87f/+oTK2eUDdIyj0azirWUKHMcbLuqixTYdz5rS5sQeaoLznD6sXuJZLzj1JVdDKG/V4tEWTCIgrO07A8fbM2OBrNPp0VwbmX1U0nhrftSlNV8+wJ5xkhto3yGC2SQlVQeUUmLb0qnIghTm5CGziuKZ8ad98hRTc6QWPffGiPOnFQxj3oEkV/VUkuSXtm1A6FHk0oXsy/y60IREtd8e1nrakk4RW4QlivRk0O84WkT63KRq1PRVawGZsF+HrYycdqL3c2J0IknI58tixH70w2fvbYkB59SPm4qLtFoUMH9N5CGsnRx/ucStQNtNtAN/+fc+Ld/wnDGVPh7M11BYJiU6SJb4siw5US6Sw+XRScpTV0XvG7vgu+ssQjPSfsUUr9uc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE9B7DCC1A0B634F8A84CB41021A4424@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e70aa5-de7b-4ef1-0860-08d71455c9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 18:51:38.6280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2822
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTIyIGF0IDE0OjM0IC0wNDAwLCBRaWFuIENhaSB3cm90ZToNCj4gVGhl
IGNvbW1pdCBiOWE3YmE1NTYyMDcgKCJuZXQvbWx4NTogVXNlIGV2ZW50IG1hc2sgYmFzZWQgb24g
ZGV2aWNlDQo+IGNhcGFiaWxpdGllcyIpIGludHJvZHVjZWQgYSBmZXcgY29tcGlsYXRpb24gd2Fy
bmluZ3MgZHVlIHRvIGl0IGJ1bXBzDQo+IE1MWDVfRVZFTlRfVFlQRV9NQVggZnJvbSAweDI3IHRv
IDB4MTAwIHdoaWNoIGlzIGFsd2F5cyBncmVhdGVyIHRoYW4NCj4gYW4gInN0cnVjdCB7bWx4NV9l
cWV8bWx4NV9uYn0udHlwZSIgdGhhdCBpcyBhbiAidTgiLg0KPiANCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VxLmM6IEluIGZ1bmN0aW9uDQo+ICdtbHg1X2VxX25v
dGlmaWVyX3JlZ2lzdGVyJzoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VxLmM6OTQ4OjIxOiB3YXJuaW5nOg0KPiBjb21wYXJpc29uDQo+IGlzIGFsd2F5cyBmYWxz
ZSBkdWUgdG8gbGltaXRlZCByYW5nZSBvZiBkYXRhIHR5cGUgWy1XdHlwZS1saW1pdHNdDQo+ICAg
aWYgKG5iLT5ldmVudF90eXBlID49IE1MWDVfRVZFTlRfVFlQRV9NQVgpDQo+ICAgICAgICAgICAg
ICAgICAgICAgIF5+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
cS5jOiBJbiBmdW5jdGlvbg0KPiAnbWx4NV9lcV9ub3RpZmllcl91bnJlZ2lzdGVyJzoNCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VxLmM6OTU5OjIxOiB3YXJuaW5n
Og0KPiBjb21wYXJpc29uDQo+IGlzIGFsd2F5cyBmYWxzZSBkdWUgdG8gbGltaXRlZCByYW5nZSBv
ZiBkYXRhIHR5cGUgWy1XdHlwZS1saW1pdHNdDQo+ICAgaWYgKG5iLT5ldmVudF90eXBlID49IE1M
WDVfRVZFTlRfVFlQRV9NQVgpDQo+IA0KPiBGaXggdGhlbSBieSByZW1vdmluZyB1bm5lY2Vzc2Fy
eSBjaGVja2luZ3MuDQo+IA0KPiBGaXhlczogYjlhN2JhNTU2MjA3ICgibmV0L21seDU6IFVzZSBl
dmVudCBtYXNrIGJhc2VkIG9uIGRldmljZQ0KPiBjYXBhYmlsaXRpZXMiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBRaWFuIENhaSA8Y2FpQGxjYS5wdz4NCj4gDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0Lg0K
DQpUaGFua3MsDQpTYWVlZC4NCg0K
