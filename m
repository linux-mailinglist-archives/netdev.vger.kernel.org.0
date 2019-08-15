Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFCA8F500
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbfHOTqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:22 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:39650
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbfHOTqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYC0SOqO58NQv80nHnTNJALNsXCs7RcL3R4yONDtaax8AHAOlBVql6iwFj26/cXx2cLzyKgDREAVnf8bFeiMpIL3MsWJ+xEyJ2l5lZ/6GEiA4pCgv3+NHUXDfYePQWVhULRHdQ54mhIjoLXhdFJc4/oET/nKbMf5KM7JmJMl1aE/EgtlYGx7c6XeJW04OMXP89OXM0hWzT9iSoo9Pe9YHU6hS2WmK6OvkBpyNSjrZ5EfAlLDtWqKX5PcEm7QtYdOLNLd1RTwZDi0Q5MvXScmbGKukdMILjR+bzLzbHgllF1j6rM3PWV5WKkvzv7oevefkRa9WuUVH/Cwm66BiJBcdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtvBMMBkplldhVGdqqddT0GP2k24jm4oPhmPy3zm2XQ=;
 b=Vz82PYYbaDO3CFK1xXSsdUZrX6sGOLtOez9jZhIahLj7OuRbfzS4HgUDpqNvRcFuinxMm6TAo0SNeohTob9z3Na2b8taj9GzW0HQH9bw7lVPj8UIvCN7Y3TjzJrYTJ9cvF4Ne+qDlr5V2K74oCA3XLsio6qOI4J3815WEVi9/P3r2a62XwwnWbkvKjrNkWs4R8zlSMo+58DEkr9YaaQrh2XM1UofhfwsMphOpTXPzjax9Or5Gbzk3Pp8RVpIxqEoMnTguIN52vAO6r9CjRuhx9Z3chh7E0Zq4qdIUUaLM/zquU0w7ZQIzuwe1NsJjkOsAYDqVoZR/5gurGvZI+FeuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtvBMMBkplldhVGdqqddT0GP2k24jm4oPhmPy3zm2XQ=;
 b=Sdui/K+aOM69ZU2H5SHhLFi/yh93+CnGnPrXr+nOxR797e7lTRS+AAZAqOqqzgTQEqVmUNKErDE1UEjs4AMIPxd1UyEEljIrsJUkmlYVUYchPv1n2SAk9vLT8ATaK/zfCnVMpFqDuo4MpBM6LlR/CPrtqBxeb8q9PppFWtmFi9E=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 19:46:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Add missing include file to
 lib/crypto.c
Thread-Topic: [PATCH mlx5-next 1/5] net/mlx5: Add missing include file to
 lib/crypto.c
Thread-Index: AQHVU6IVaP0LILAx+0OZsGxE0rVD/A==
Date:   Thu, 15 Aug 2019 19:46:08 +0000
Message-ID: <20190815194543.14369-2-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2931ec2-4a5a-4ea8-9726-08d721b93759
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB27594F35E7AB03CF705E65AABEAC0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(5660300002)(25786009)(7736002)(110136005)(14454004)(66476007)(66556008)(64756008)(66446008)(2906002)(305945005)(54906003)(6486002)(316002)(66946007)(14444005)(256004)(6636002)(76176011)(478600001)(1076003)(52116002)(99286004)(3846002)(2616005)(102836004)(6512007)(6116002)(6436002)(6506007)(386003)(4326008)(36756003)(186003)(26005)(8676002)(81156014)(81166006)(71200400001)(86362001)(66066001)(50226002)(11346002)(446003)(53936002)(450100002)(8936002)(476003)(71190400001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EihiefiYFWbQ17X4xAC/4RACjNJ6UCgz7EcOqHIFsz+vmq9ujQvOEZhmYeeAynqmB7B+z/yUBwgK1QFzMzH3jzOT49T3w43ZqYBfMSB4rMIcvqOFPKP3J3/R5sLMNpTD4u/E2RnwSqcwS3b88/6zCpdsgQgfrbuIf/hVGD3gRHQnVOjP3p2o9ctJEI2dlYEiIgd7FaVMMk3i6fffowL9joyCxmssfSB43KNUDQc170OuZH4yRoYgCOIOGj7QqS1b22A4g/aDuilRAQqWtICIQgfabWfILT1w37I6vVbfL1PJEOG0rkNCxDiXQn5rrWSMHkvRFoGt9QxZZkBb96nG4yc9AHZdg+rc9yyxof8UjDVfmEDymBkmGy8kN/KupcbFmNtuQIjIOr0ykwwHh35JENDhDUMUFV16ZdIWLTMWR8M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94A0DBE8CCE44E4CA4C249FFCA2FE01F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2931ec2-4a5a-4ea8-9726-08d721b93759
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:08.1977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3iJTCbGZ6aM8ZL37HhHfk+AnTFN4FIyPGrAZ8F92P1fnpw1xurWg79NVDj1+fUv6o5k5cd1ruEACmgd1diTKFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIG1pc3NpbmcgaW5jbHVkZSBmaWxlIHRvIGF2b2lkIGNvbXBpbGVyIHdhcm5pbmdzOg0KZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlLy9saWIvY3J5cHRvLmM6Njo1Og0K
d2FybmluZzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciDigJhtbHg1X2NyZWF0ZV9lbmNyeXB0
aW9uX2tleeKAmQ0KICAgIDYgfCBpbnQgbWx4NV9jcmVhdGVfZW5jcnlwdGlvbl9rZXkoc3RydWN0
IG1seDVfY29yZV9kZXYgKm1kZXYsDQogICAgICB8ICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlLy9saWIvY3J5cHRv
LmM6NjA6NjoNCiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIOKAmG1seDVfZGVz
dHJveV9lbmNyeXB0aW9uX2tleeKAmQ0KICAgNjAgfCB2b2lkIG1seDVfZGVzdHJveV9lbmNyeXB0
aW9uX2tleShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwgLi4uDQoNCkZpeGVzOiA0NWQzYjU1
ZGM2NjUgKCJuZXQvbWx4NTogQWRkIGNyeXB0byBsaWJyYXJ5IHRvIHN1cHBvcnQgY3JlYXRlL2Rl
c3Ryb3kgZW5jcnlwdGlvbiBrZXkiKQ0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvbGliL2NyeXB0by5jIHwgMSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvbGliL2NyeXB0by5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2xpYi9jcnlwdG8uYw0KaW5kZXggZWE5ZWU4ODQ5MWU1Li4yMmJjNDVjODMxZDIgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2NyeXB0by5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2NyeXB0
by5jDQpAQCAtMiw2ICsyLDcgQEANCiAvLyBDb3B5cmlnaHQgKGMpIDIwMTkgTWVsbGFub3ggVGVj
aG5vbG9naWVzLg0KIA0KICNpbmNsdWRlICJtbHg1X2NvcmUuaCINCisjaW5jbHVkZSAibGliL21s
eDUuaCINCiANCiBpbnQgbWx4NV9jcmVhdGVfZW5jcnlwdGlvbl9rZXkoc3RydWN0IG1seDVfY29y
ZV9kZXYgKm1kZXYsDQogCQkJICAgICAgIHZvaWQgKmtleSwgdTMyIHN6X2J5dGVzLA0KLS0gDQoy
LjIxLjANCg0K
