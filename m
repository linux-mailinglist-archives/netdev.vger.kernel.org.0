Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB628F437
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbfHOTKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:49 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfHOTKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCNXwO4rOhs+zhjyhAQr3JKZWIPhM+mslQZ9vmr64C1awCldi/Swuh1FB0bgU7ZDbx70O9nMuFaVJOrnSyeNtp5D7P0t7r4xuOjIs4RZ9TusLxgIrP8mb1iUQ2pTPZXDQ2ChcERouZHtQQUPzzj10Z/DbWrptW23MsH3jo4pwKNE6azeLquVgL4Q6rbWl6QrZ4VcTQLv1G5bd9KrznlWSXCcN43S3wSN48n8ciunpsOvE3SDmbWyDK1HWkETglFD3yLE1Rhue1VoiEb/Kfm0GAp0oCK70rk5BjdLQ1NmXywgxVjYOxswipFUC0p9NFSvBPynjKRd3oFZNRLyhMkcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OSPYuIbgbpd/GH1h+irXHO1UpbUmAR0+Ggk1gLbpUE=;
 b=KeqzDzWK5PFE5wyIZz5MYmGrZepsiZ/VlKTLgIx0hfVrzNgUiKzXxSc+F8BvTtiTyNFd/X9MQUCUicM+UuW+pePyy+3WOGvKkS5gmSD6dlvFEk0ZEQ6bSwrsmaYDSIrI6kyNUrcSIffrLDBCCjaoZkV0aLAbsIxJ52mydFhqb74ZroJmFHTbySLfbLGKT3PYJxNqUDra9mXmhCZY1m/loH/RtswdT8Tm+S2Mqfzakv3+yTqZoOisEbsw8L2rroObsnDTt+t6K1EjZC3S26sLodZUjnVpXpj4lDhSlwt7p5MSFqm9keK6hIz9eyBHo1HBjLQ3VfCcHEQ0AseYoWc1Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OSPYuIbgbpd/GH1h+irXHO1UpbUmAR0+Ggk1gLbpUE=;
 b=nmhklmiuXIpVXecilTyTIUMzUauAAVS/9LiUFhRki6pnjbuIsVpBFAF+sYBwr9EDvG7R3Y9TxNrrmZXbaJCKCU0cUif/V05tE5Ww/v8nrMxYnghxpm8+tOaggSM1DzaU88miqECEN7dXQu448XD2S/BQX2LlPODuVe0qS3TEReo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:13 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] Documentation: net: mlx5: Devlink health
 documentation updates
Thread-Topic: [net-next 14/16] Documentation: net: mlx5: Devlink health
 documentation updates
Thread-Index: AQHVU50QWhJh3RVljEa2MOINQDAhTg==
Date:   Thu, 15 Aug 2019 19:10:13 +0000
Message-ID: <20190815190911.12050-15-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1939ceb1-b1dd-4708-0156-08d721b43351
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440FE3DBEEF7CCD9701FF53BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(51234002)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(15650500001)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PKwwNzn+nIEsbYCq6CZIpbWLcdkHElXn0mOHlyW4F4+Kv8U3KOeCtgz8R22i386oMIzKqg9azOyGi71hHRvotPasLHeLBKIL56ce6M+AnOrA2A5MrLT0W4LDn0KdfBhgoOjrcD9mFL1rKEZfKEez1qwO7BjiAbklYWRVAjOP2NYoNIULKPqvlB5BF/UgVetS6O1N5Qeyqm5PawLaup5YNMOWCUG2GNPjVScOxH+Vf6wLBNIVEn3dSn0bXAVXshLjmljqKl6PW8P5zrPLWnqxa7sk/Uw5/gT1Ef+5a/p7GkQJiQ7woa0UdUxGwl0tbn2URT+JCaiPl8XluKK089Gr5ja3+woFPveHe2umUzvIvXuXU2FkpoSvR59M1zDam1OWHyCPnUxCP9c72q+fVG/tTcoWoTRnMEObcT7UVczXEfY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1939ceb1-b1dd-4708-0156-08d721b43351
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:13.8009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tYe07r1A28RUk1dIgNtgzrN1pBSBGnAo+HhCUbcBCduz0razBOdJ4ogWBSptD6yGl7/RSFbkal0q63V2x6D0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
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

