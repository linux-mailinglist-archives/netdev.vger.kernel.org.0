Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C03ED32D
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 12:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKCLlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 06:41:16 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:42051
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727764AbfKCLlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 06:41:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFd1QuiMhQ511DgFhoPGQQUVJQ+s//BtF8Jc6Ar7V+W+qrYhGNqGZWstQ6W8GQq/Tmxgsg1Owkn1a0TOIhuYglP1ZgAGc3kX6TPGLXQfIoWftyZ1Xp29xCaTqIAJ3kR2VaXMR5XbDzLQI6pFcL9lvgAlqL5QVqw63b4cOFxoxPsZwj6Kc+eRalUYxHMCtf+ennKNw+oTEvcoR4tl/IXm5ErHCvjlnuWO/vVDNalYN3IZdzVoloVli4Tu2FJXVdDTZVIrhFGk8Zn6x2KWwXH6wB1X3alvZ/oAyddXm5FkHgSZWx1l9VvITaSvW0MCK95A/Qv3fB2+YQfpQWmDkufooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpKiiAyzpaxIbKajWgtYRd9AXiMlwt2LIyYhDGdUn8s=;
 b=TpfFMPfKl+tsg1YXhC1RxLbeQVWv36FqHaRxne5BDXS9t9HS0mxqq6du5ZQEZ6LKwmlpXWzjVVwGWKG/em1fSaSkrj3pBgOggJDkj0dK569SA9Dn0AqWtVEqh/1/Hs7gjtB2cjXSfOnd1x9XBHEgV6uS6F3K9YOt8JOrh6CG3QVnHa3e0opPPzDPAaAmwfhhDNJMgQkpT+EmP2KI7sStRRkCEej824b/AtG+WSySoe1WzFyWCO4J3cTE+7lJkSDPHsAdzTmClZeIbPE2ktQj4UFbljT/pXxjHn0+fzord2jJ3hAr4riORQ/+UMQwpQzvPq9VOHVOU3InMSz/jZkZyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpKiiAyzpaxIbKajWgtYRd9AXiMlwt2LIyYhDGdUn8s=;
 b=Su4dndGZEVgS3dCV2DSxuJwjSKDJNyse/zXOdQNZvvCErhodYyploxjLigqVS4OsoBu7ckhxv27xnKM91bMrwF6x8pTomQ8ed9pMg9ggs0ZUUCll0NzVsSZr197A61iVfE/69MKuPzYqn49US7VD4DDAqgpzBFPhR4cpyPvCCrk=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6411.eurprd05.prod.outlook.com (20.179.44.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sun, 3 Nov 2019 11:41:11 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8c61:2788:89:69ce]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8c61:2788:89:69ce%5]) with mapi id 15.20.2408.024; Sun, 3 Nov 2019
 11:41:11 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Yuval Shaia <yuval.shaia@oracle.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dotanb@dev.mellanox.co.il" <dotanb@dev.mellanox.co.il>,
        Eli Cohen <eli@mellanox.com>,
        Vladimir Sokolovsky <vlad@mellanox.com>
Subject: Re: [PATCH v1] mlx4_core: fix wrong comment about the reason of
 subtract one from the max_cqes
Thread-Topic: [PATCH v1] mlx4_core: fix wrong comment about the reason of
 subtract one from the max_cqes
Thread-Index: AQHVkibAevwNukxCdke/TB6p1qOIhKd5UtuA
Date:   Sun, 3 Nov 2019 11:41:11 +0000
Message-ID: <68efcf5b-0c05-a626-d164-bf8bcbb60642@mellanox.com>
References: <20191103091135.1891-1-yuval.shaia@oracle.com>
In-Reply-To: <20191103091135.1891-1-yuval.shaia@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0004.eurprd02.prod.outlook.com
 (2603:10a6:200:89::14) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1eb09617-bf0b-46c2-d4ee-08d76052b9c1
x-ms-traffictypediagnostic: DBBPR05MB6411:|DBBPR05MB6411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6411641154E01E468EADB99FAE7C0@DBBPR05MB6411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(189003)(199004)(6636002)(2201001)(14444005)(2906002)(256004)(6116002)(3846002)(478600001)(305945005)(31696002)(25786009)(71190400001)(31686004)(2501003)(86362001)(7736002)(14454004)(11346002)(446003)(2616005)(476003)(486006)(6246003)(66476007)(64756008)(6436002)(66556008)(66446008)(71200400001)(76176011)(6512007)(52116002)(66946007)(8936002)(81166006)(186003)(8676002)(81156014)(6506007)(53546011)(66066001)(229853002)(110136005)(26005)(386003)(99286004)(316002)(102836004)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6411;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwfW0evr39ff87h6AzastmWQT3iNw1CZbb++IWlejFFicKELRswPr572BXoFMDNpBk4RnAtt/3kIfcYJ+Ab7aRVV2jf/kv3y73KHH2XvT3F3QbJsz/xpDzc5tJQQXTk904GkcwSw6z2aIa6GHiBN95eJVya0DGHempmxxlOyPqzDwQ3yw6wTWClwAeehmGd1NCeXy+QPlPQKBlAYCeH7gXLxmzzO8R+BasTFaQBLcwGRdjLujMJ8SY8m5CSpb/XLD9Jkkj5oCQhl8NPAcigkPm01I0hAO+aCJMOtjKpCP9zZIbTabi1A7XuVL6ZdjcqaGXUbD1sHK+x5FVwH2yqjueboXHFHa3aQX/FrvW4KU6Rrjm41P5311JLYaKq9nQ8bCAKKn6EUhgO84IL+02LdHT07e1reJ3gcFk1C4hvr3ZsP+nZqqrOlGM9DuxyxZjDZ
Content-Type: text/plain; charset="utf-8"
Content-ID: <E01A47EE5E9E034F82C1AC4EF5AFB7B7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb09617-bf0b-46c2-d4ee-08d76052b9c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2019 11:41:11.7716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pgz3chKat92oMAxIvDj1EPoz+UltVITbmLd9Y/Ms+DTpVgm+RkH2sS0JB1tYT34oB2AN4xIgxh1tZypKuRGDaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzMvMjAxOSAxMToxMSBBTSwgWXV2YWwgU2hhaWEgd3JvdGU6DQo+IEZyb206IERv
dGFuIEJhcmFrIDxkb3RhbmJAZGV2Lm1lbGxhbm94LmNvLmlsPg0KPiANCj4gVGhlIHJlYXNvbiBm
b3IgdGhlIHByZS1hbGxvY2F0aW9uIG9mIG9uZSBDUUUgaXMgdG8gZW5hYmxlIHJlc2l6aW5nIG9m
DQo+IHRoZSBDUS4NCj4gRml4IGNvbW1lbnQgYWNjb3JkaW5nbHkuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBEb3RhbiBCYXJhayA8ZG90YW5iQGRldi5tZWxsYW5veC5jby5pbD4NCj4gU2lnbmVkLW9m
Zi1ieTogRWxpIENvaGVuIDxlbGlAbWVsbGFub3guY28uaWw+DQo+IFNpZ25lZC1vZmYtYnk6IFZs
YWRpbWlyIFNva29sb3Zza3kgPHZsYWRAbWVsbGFub3guY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZ
dXZhbCBTaGFpYSA8eXV2YWwuc2hhaWFAb3JhY2xlLmNvbT4NCj4gLS0tDQo+IHYwIC0+IHYxOg0K
PiAJKiBBZGQgLiBhdCBFT0wNCj4gCSogQWRkIGNvbW1pdCBtZXNzYWdlDQo+IC0tLQ0KPiAgIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWFpbi5jIHwgMyArLS0NCj4gICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tYWluLmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21haW4uYw0KPiBpbmRleCBmY2U5YjNhMjQzNDcu
LjY5YmI2YmIwNmU3NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NC9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NC9tYWluLmMNCj4gQEAgLTUxNCw4ICs1MTQsNyBAQCBzdGF0aWMgaW50IG1seDRfZGV2X2NhcChz
dHJ1Y3QgbWx4NF9kZXYgKmRldiwgc3RydWN0IG1seDRfZGV2X2NhcCAqZGV2X2NhcCkNCj4gICAJ
ZGV2LT5jYXBzLm1heF9ycV9kZXNjX3N6ICAgICA9IGRldl9jYXAtPm1heF9ycV9kZXNjX3N6Ow0K
PiAgIAkvKg0KPiAgIAkgKiBTdWJ0cmFjdCAxIGZyb20gdGhlIGxpbWl0IGJlY2F1c2Ugd2UgbmVl
ZCB0byBhbGxvY2F0ZSBhDQo+IC0JICogc3BhcmUgQ1FFIHNvIHRoZSBIQ0EgSFcgY2FuIHRlbGwg
dGhlIGRpZmZlcmVuY2UgYmV0d2VlbiBhbg0KPiAtCSAqIGVtcHR5IENRIGFuZCBhIGZ1bGwgQ1Eu
DQo+ICsJICogc3BhcmUgQ1FFIHRvIGVuYWJsZSByZXNpemluZyB0aGUgQ1EuDQo+ICAgCSAqLw0K
PiAgIAlkZXYtPmNhcHMubWF4X2NxZXMJICAgICA9IGRldl9jYXAtPm1heF9jcV9zeiAtIDE7DQo+
ICAgCWRldi0+Y2Fwcy5yZXNlcnZlZF9jcXMJICAgICA9IGRldl9jYXAtPnJlc2VydmVkX2NxczsN
Cj4gDQoNClJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQoN
ClRoYW5rcy4NCg==
