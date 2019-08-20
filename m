Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F896A4B
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfHTUY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:56 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731053AbfHTUYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP8KYXdAZeMjfm/g8m+d4ZiDJPu2msdy3PmZrme4tjuB8VZDfaj3q9jFhIGxqnaxE3x83fZ32Dilak1CVi6MpX6GbzvrYCjUgGJBDiuAdVoFeI2njUlZCNe+CXSKvnca0xi9L/FbgNd35q2ZV5jALxpIabZu20Gst1vGsm494pwkoamYKzVhbK6T0PnMwL8ESJJeJfunr+UP+KaHAR1+t7u9z+Jkmx7fApsv27dvJAxYj0+Bno6wuGzArU1eT6Ae8CI/n2gPvpkAc3OteJ7puUbdaMltPcxfr5Apy5kQgFkYhKlf1sDCSy3pw9gZ8xkdCkiVOebYvpzXCSiMfaMAZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OSPYuIbgbpd/GH1h+irXHO1UpbUmAR0+Ggk1gLbpUE=;
 b=JB3Qug+WlMlYw0QosLQ3wNMYgyCUstFY7MPe2XbhQ9IzROYxcAgFXL7eiBOwrOVrg/SWHvugXknM3kQqdpwDVm9ora0WqqOxtP0vapH83DS+hggaTk6KmZfAM0qS6CXff/UJEzkk5mOrhPK0Cu0hOMT+YeEvErgUbd5olNhU01qkwgZL0WmNZaVBbArjnjd8ADrdvAxn+8F+iultux65MCA7FQlb2d+pFlFXpcQ6RR7kkXLyFITyDkUJ38Tc2RjKje8B+UHr4KZ5a/6UyIzzfG+GzMiWoOcUoWxDv2IcARWiEWhi/LOo/Cc0Eo6jhn1IKyFiN+LRaVSHGcXPLA6g/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OSPYuIbgbpd/GH1h+irXHO1UpbUmAR0+Ggk1gLbpUE=;
 b=a7gxQ1wOw12NK3zy70HXQEO6t2C/6ai1iuWyNRdDrNgNQn2lTq1PTMXiTcUU9otcqg5hVzRBQVfxpIMgMPH+F5WhrmACgOFJq9AN7yfx+VTNRBsxibf6uCkixjeitaUkVkQ0TJxqNu3GSW9sanIxp7nkQ5w5x2eQRnXucp8Ul8w=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 14/16] Documentation: net: mlx5: Devlink health
 documentation updates
Thread-Topic: [net-next v2 14/16] Documentation: net: mlx5: Devlink health
 documentation updates
Thread-Index: AQHVV5VJxEcdrBsS5k2AJHFfQ8YWVQ==
Date:   Tue, 20 Aug 2019 20:24:37 +0000
Message-ID: <20190820202352.2995-15-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b074a742-b739-402a-5227-08d725ac6bdc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680B9032A3BC551D9376A06BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(51234002)(446003)(11346002)(15650500001)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Zk11qC/69onfsLmjcKlGZlhwM4K/LwVehOKVccdQvsCLlPpsw5vsBh2NxBP7s3lH1IAM64ooKKKzR42R/rs6jNzMdpkP8axrVNsLBURzw3mawTx8aOKbjvoNIp/fSR2yPUhk9iOl6qJEUeZNmookXYi9iE+G69TKZCuryF3tpj7l0LSA3dBHL3Juor1lnP0pkF3auoizaAPpeTRxIPAI4IWEYTOiNxwvVGnHVGQWWsUK+yK8yZqd5u9HMLMYvWSu260b9/xiJLGDadrouaYMl1h2QYGyQZNIien11q7LkkKOgRcypai+rExNgoCNzATeu0/OWEGVT87fCgnglA1dtL7Ff7DdviWh6kppvMGiGieoeextthJTEEmjOqMloZZTm1IIU7pQDBsZ+zVyTN54W+FzDHQPkDKZeBeouczmE20=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b074a742-b739-402a-5227-08d725ac6bdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:37.1757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwkPzBXQuFxfjFY47+xQxt76CRDLpXzoE78cjvubyqwvSuWbJK0feeJlyiwMK7atMo6qqBG2sKUx7u9GzgnCgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add documentation for devlink health rx reporter supported by mlx5.
Update tx reporter documentation.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index 214325897732..cfda464e52de 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -126,7 +126,7 @@ Devlink health reporters
=20
 tx reporter
 -----------
-The tx reporter is responsible of two error scenarios:
+The tx reporter is responsible for reporting and recovering of the followi=
ng two error scenarios:
=20
 - TX timeout
     Report on kernel tx timeout detection.
@@ -135,7 +135,7 @@ The tx reporter is responsible of two error scenarios:
     Report on error tx completion.
     Recover by flushing the TX queue and reset it.
=20
-TX reporter also support Diagnose callback, on which it provides
+TX reporter also support on demand diagnose callback, on which it provides
 real time information of its send queues status.
=20
 User commands examples:
@@ -144,11 +144,40 @@ User commands examples:
=20
     $ devlink health diagnose pci/0000:82:00.0 reporter tx
=20
+NOTE: This command has valid output only when interface is up, otherwise t=
he command has empty output.
+
 - Show number of tx errors indicated, number of recover flows ended succes=
sfully,
   is autorecover enabled and graceful period from last recover::
=20
     $ devlink health show pci/0000:82:00.0 reporter tx
=20
+rx reporter
+-----------
+The rx reporter is responsible for reporting and recovering of the followi=
ng two error scenarios:
+
+- RX queues initialization (population) timeout
+    RX queues descriptors population on ring initialization is done in
+    napi context via triggering an irq, in case of a failure to get
+    the minimum amount of descriptors, a timeout would occur and it
+    could be recoverable by polling the EQ (Event Queue).
+- RX completions with errors (reported by HW on interrupt context)
+    Report on rx completion error.
+    Recover (if needed) by flushing the related queue and reset it.
+
+RX reporter also supports on demand diagnose callback, on which it
+provides real time information of its receive queues status.
+
+- Diagnose rx queues status, and corresponding completion queue::
+
+    $ devlink health diagnose pci/0000:82:00.0 reporter rx
+
+NOTE: This command has valid output only when interface is up, otherwise t=
he command has empty output.
+
+- Show number of rx errors indicated, number of recover flows ended succes=
sfully,
+  is autorecover enabled and graceful period from last recover::
+
+    $ devlink health show pci/0000:82:00.0 reporter rx
+
 fw reporter
 -----------
 The fw reporter implements diagnose and dump callbacks.
--=20
2.21.0

