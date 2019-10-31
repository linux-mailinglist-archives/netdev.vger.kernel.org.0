Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEDAEB332
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfJaOwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:52:14 -0400
Received: from mail-eopbgr10041.outbound.protection.outlook.com ([40.107.1.41]:40846
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbfJaOwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:52:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK0Qwq1uVONjub0LxcXnS9LutOJ6pmNCPAiXCcRYPNVmklVNvDAtCEMEYt0QuQ0WQ9ei4ktT93qg5hLq1ibO+PUgmPSA59qEiW6yIIJwpVGf8t+pR4Nrjpv6IBlDT/TrVEKyFlDLEDeuZs9qPFm2lLxW/IAsina7kZngZo9dOTzHdVrycAJd1dSFkD7BoPYwmoGbeCjCaqb6DpSDqXUfsOoZ4E9yBF+Ox7YK8p9ZF7Ulcr4iUFLwGuHpssTbTaGhngjOOTSVgt00p+rHBz3PQkKTK06JlT68ZJsJXwKTQyGclV+Yk7ivFl5OBK5sGrtkFQNi5zZ7ZkHfZeu/vGgIRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJSvDEk3ImGrNciSLrSTfUMPSqHSidO0NHUB0ZbinFw=;
 b=QxGZOFSiDgONVLoqyIMnLgA0TWmA/7BQlsnyHRqAdCA2OoVUDgOvsDbP+chsej9sG/YL2etZe8fze7OToqkBktKxQKQpMNjQcMROjZfHtcPAvjhkWmQai4QmPKIQIpWPEJBYjU99qE94h3udSwO40bMEucwKa2VZu/lMklRAXD99tcMad3ccaGQInDpN4QpzVmIoV/8x2kL8QnWnB4ky7KPlKcmgy/5BskBKFQt6HJ5SLJ4ywfaYKKrKgBoy3yYY/RNqhJfa5CVxeLcH5RsRGjxxluunULMgdvmPr6UBrHj4otlzX1vNvBoSivxk0pwELq1yDg8LjcIpVg7J4JZIWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJSvDEk3ImGrNciSLrSTfUMPSqHSidO0NHUB0ZbinFw=;
 b=CAXJwQz+5Nsx2cpAgWzS7KPgLPkMBf0h4JGcRERkUdnAAVgtU5X3263R27yy9UIYVt60PkXitZcMkM9MKrM35bLO/u/G3BYKGgORNkYeo3zIrrFB2JqDfRuyYv8sqv75r3e2Db2nieI6PsQQBsrRiM9jFO37xA4p9KntU40qgLA=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6556.eurprd05.prod.outlook.com (20.179.41.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Thu, 31 Oct 2019 14:52:09 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8c61:2788:89:69ce]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8c61:2788:89:69ce%5]) with mapi id 15.20.2408.018; Thu, 31 Oct 2019
 14:52:09 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Yuval Shaia <yuval.shaia@oracle.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dotanb@dev.mellanox.co.il" <dotanb@dev.mellanox.co.il>,
        Eli Cohen <eli@mellanox.com>,
        Vladimir Sokolovsky <vlad@mellanox.com>
Subject: Re: [PATCH] mlx4_core: fix wrong comment about the reason of subtract
 one from the max_cqes
Thread-Topic: [PATCH] mlx4_core: fix wrong comment about the reason of
 subtract one from the max_cqes
Thread-Index: AQHVj7/MLr7HVp7cQUKjB+F0Jw6ouKd01gQA
Date:   Thu, 31 Oct 2019 14:52:09 +0000
Message-ID: <6c0f87dd-bb63-cf0e-66c1-ed01b2a42382@mellanox.com>
References: <20191031074931.20715-1-yuval.shaia@oracle.com>
In-Reply-To: <20191031074931.20715-1-yuval.shaia@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR04CA0001.eurprd04.prod.outlook.com
 (2603:10a6:208:122::14) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a2cbd38e-2e02-4a64-c722-08d75e11e7eb
x-ms-traffictypediagnostic: DBBPR05MB6556:|DBBPR05MB6556:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB655692B51CCC2DC8FAEE5AF7AE630@DBBPR05MB6556.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:240;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(199004)(189003)(66446008)(476003)(386003)(71190400001)(2201001)(446003)(11346002)(6116002)(3846002)(6246003)(5660300002)(6506007)(53546011)(71200400001)(110136005)(2906002)(486006)(66556008)(66476007)(66946007)(6436002)(14444005)(6636002)(256004)(64756008)(186003)(52116002)(229853002)(6486002)(6512007)(25786009)(36756003)(8936002)(8676002)(14454004)(81166006)(81156014)(102836004)(7736002)(99286004)(31686004)(31696002)(66066001)(478600001)(26005)(76176011)(316002)(2616005)(2501003)(305945005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6556;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k0AUfv2iUuZodcNI6i8K0sR5ZRaJqkIXoZIaDCCEkyfkOJ1aoAPdVRt7v5TpHZhA3G/IiHZEmCJqCPj8i4esL8cjz3mBo0fYDKuchgCXQBap0Eogy2vMOMaxIb2i1sX8EvI0zH2adNPuneVW27HkO6TQrvDgYn9BiR7aaxi2sEBsb/QZ1i2+3SoWPG3kyse7k7CBYn70WVrPZsja9oNVGUPRaxVCze0tXojqVf3ZGfhbHxCecsATqXNLMESHdmofVLaLvoZ/3UthARaGj0/DFVDyoP7eax/4ogVObCUK+VJcYqvUyEwT6tcZZOE/UzAjU4ew3LGhNCGi7Df7qJGA1kAUqzapIBAtKOOTHRqDtkYhhprnn2U2yjVVSFQu9UEs3QgrfaT9TI/CBRqLUZlw4XKtJlhBzl80yJ5RYDZnxTvLYuRe0ExTMy3WdO8N4oJC
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B2741D21624A844A28DDCE6E5668819@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cbd38e-2e02-4a64-c722-08d75e11e7eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 14:52:09.7086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzaDc399VWIl6QBxkcPMdh0svZMB+/sUbkdiY7JNa2W0frk8tlQuyvfnwnjABm8y3ZlwsfTiMQpdsCoqh7rCPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6556
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzMxLzIwMTkgOTo0OSBBTSwgWXV2YWwgU2hhaWEgd3JvdGU6DQo+IEZyb206IERv
dGFuIEJhcmFrIDxkb3RhbmJAZGV2Lm1lbGxhbm94LmNvLmlsPg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogRG90YW4gQmFyYWsgPGRvdGFuYkBkZXYubWVsbGFub3guY28uaWw+DQo+IFNpZ25lZC1vZmYt
Ynk6IEVsaSBDb2hlbiA8ZWxpQG1lbGxhbm94LmNvLmlsPg0KPiBTaWduZWQtb2ZmLWJ5OiBWbGFk
aW1pciBTb2tvbG92c2t5IDx2bGFkQG1lbGxhbm94LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWXV2
YWwgU2hhaWEgPHl1dmFsLnNoYWlhQG9yYWNsZS5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDQvbWFpbi5jIHwgMyArLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg0L21haW4uYw0KPiBpbmRleCBmY2U5YjNhMjQzNDcuLmRjZjZiNDYy
OGM1OCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9t
YWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tYWluLmMN
Cj4gQEAgLTUxNCw4ICs1MTQsNyBAQCBzdGF0aWMgaW50IG1seDRfZGV2X2NhcChzdHJ1Y3QgbWx4
NF9kZXYgKmRldiwgc3RydWN0IG1seDRfZGV2X2NhcCAqZGV2X2NhcCkNCj4gICAJZGV2LT5jYXBz
Lm1heF9ycV9kZXNjX3N6ICAgICA9IGRldl9jYXAtPm1heF9ycV9kZXNjX3N6Ow0KPiAgIAkvKg0K
PiAgIAkgKiBTdWJ0cmFjdCAxIGZyb20gdGhlIGxpbWl0IGJlY2F1c2Ugd2UgbmVlZCB0byBhbGxv
Y2F0ZSBhDQo+IC0JICogc3BhcmUgQ1FFIHNvIHRoZSBIQ0EgSFcgY2FuIHRlbGwgdGhlIGRpZmZl
cmVuY2UgYmV0d2VlbiBhbg0KPiAtCSAqIGVtcHR5IENRIGFuZCBhIGZ1bGwgQ1EuDQo+ICsJICog
c3BhcmUgQ1FFIHRvIGVuYWJsZSByZXNpemluZyB0aGUgQ1ENCj4gICAJICovDQoNClBsZWFzZSB1
c2UgYSBkb3QgYXQgRU9MLg0KDQpUaGlzIGlzIG5vdCBjbGVhciBlbm91Z2gsIGVzcGVjaWFsbHkg
d2l0aG91dCBhIGNvbW1pdCBtZXNzYWdlLg0KDQo+ICAgCWRldi0+Y2Fwcy5tYXhfY3FlcwkgICAg
ID0gZGV2X2NhcC0+bWF4X2NxX3N6IC0gMTsNCj4gICAJZGV2LT5jYXBzLnJlc2VydmVkX2Nxcwkg
ICAgID0gZGV2X2NhcC0+cmVzZXJ2ZWRfY3FzOw0KPiANCg==
