Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BCA758F7
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfGYUhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:37:04 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfGYUhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:37:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Blts8rKuNt/uDYJRXPgnBNThdpFppgUkBA/pICWW/EyP8sUElcazlcdX0msyzd2xGAcDYa9ESfpUnrzPuWu6BfP6b0WfGkiW2grhPXae3OdcuDr4V3kCd47bjMK2ov7Oi9ptWBSoV59gqwNIiYzGHEIZQ3eCBNAqQmkxV6qVwyPHtS6lC0iGWCQDl8EUrMqHs3GPYLv/gaBRaxNwynj69mUvL//8NDjGTihS5jmVUc3eY+IR1ifpSufFheNffdBwGTMtzfxMJ/ZZsCodbZnxndkhqtZHhv052LfswfrZW663+PmT7SC4geaJUskJSnF3fa/uyZ8hk6i03h+JOgkWsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcTxYQ+zq5MgYuXp7YCNGcYH9aTPGCvc7Pz1hTmTepA=;
 b=jLUUJnfdDSdLnOZJMrccpcvnsgmiPTkSy1XgZQHGX0njzAK895/Kz2bS9o+0fxNuWs4ublAdSIiEbfr8ATPHA4Vc6ZWpkevXX81PJpzjuVSWfcM/LzdiHqaLGTwKDi2H4lhSr1L/NS4+EZ7xd7E+AxkJsz4QUNVfXMkNXywkOKimb6IoLUp2l+vHozxqFHiwxM6lteFw/EX4U1IhCtTLdBlfNtAVrA3Hkx2PLvyNXPs/hNc0kvNuGTF+9tDWdC3YRt83yePJ4RHM0xiPvpMq1kgpJ0dLhOumfjCxOKBYrA5zRo/JoRCBSyk+VnUZnhsFhiX/5fDcaDE1YuWj28FN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcTxYQ+zq5MgYuXp7YCNGcYH9aTPGCvc7Pz1hTmTepA=;
 b=HhCfrYleM1EUZJDuihFFnPHfk5wC9hp/2BoHgXG6JL7t+w6gaD6kksqpwD+YDrX3XBrIaIZXvhh/m8vNiuAipKdRJrB7wtHn70hHo/cpTJTAxm6QZckEDiH6lYGsHSDHVKU/pJlXjbfPsKmJF+ka2GN2gBud5O0A5xLOg+hRJxo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 9/9] Documentation: TLS: fix stat counters description
Thread-Topic: [net 9/9] Documentation: TLS: fix stat counters description
Thread-Index: AQHVQyiwtUigFpgNKkqZqlkQydvL0Q==
Date:   Thu, 25 Jul 2019 20:36:52 +0000
Message-ID: <20190725203618.11011-10-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5936af04-ae56-4134-7ee4-08d7113fd347
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB25047DF859C87EEE3488A773BEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dgobN4VrsuVuHrh/1IwYdDntk01vAcHsqQDg2WPjtBCstYNcRt/8HR5mpUsy6CBnUg8bw9sJtHoPhODd3wTe+RgXoON2LsBrGSjXzSwVtoj4kDPYNwTDhtfztvSYK/bIIZ71pAsDbkK8d2Wu2xSAIcQhnde426QWduLq+hD7pf3SaO1hQfARXK4EiwnCK/chW67ifWk20ZCYj4nFpdNgT7TTL1OUS/71NWXH+9NztPp3Oj/UZKW68p061Bpf37PW5WWTL3V/ZuLZCRgMtZ9q0ZpKSa+4CtbunWpwhoNjmiXskhLJju8y1QlihWe5vbmAU/Rc07/+uaBEGwNizdsc4k4xqb4t4wzW9f958uPQrr+p38Fnr9SNGCxg04YizxLtoCNKbDMHtUyZy0dxpkrFh5pMYv5ABwYxIjWAzDwUrZQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5936af04-ae56-4134-7ee4-08d7113fd347
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:52.4383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add missing description of counters.
Split tx_tls_encrypted counter into two, to give packets
and bytes indications.

Fixes: f42c104f2ec9 ("Documentation: add TLS offload documentation")
Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/tls-offload.rst | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/netwo=
rking/tls-offload.rst
index 048e5ca44824..b70b70dc4524 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -424,13 +424,24 @@ Statistics
 Following minimum set of TLS-related statistics should be reported
 by the driver:
=20
- * ``rx_tls_decrypted`` - number of successfully decrypted TLS segments
- * ``tx_tls_encrypted`` - number of in-order TLS segments passed to device
-   for encryption
+ * ``rx_tls_decrypted_packets`` - number of successfully decrypted RX pack=
ets
+   which were part of a TLS stream.
+ * ``rx_tls_decrypted_bytes`` - number of TLS payload bytes in RX packets
+   which were successfully decrypted.
+ * ``tx_tls_encrypted_packets`` - number of TX packets passed to the devic=
e
+   for encryption of their TLS payload.
+ * ``tx_tls_encrypted_bytes`` - number of TLS payload bytes in TX packets
+   passed to the device for encryption.
+ * ``tx_tls_ctx`` - number of TLS TX HW offload contexts added to device f=
or
+   encryption.
  * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
-   but did not arrive in the expected order
- * ``tx_tls_drop_no_sync_data`` - number of TX packets dropped because
-   they arrived out of order and associated record could not be found
+   but did not arrive in the expected order.
+ * ``tx_tls_drop_no_sync_data`` - number of TX packets which were part of
+   a TLS stream dropped, because they arrived out of order and associated
+   record could not be found.
+ * ``tx_tls_drop_bypass_req`` - number of TX packets which were part of a =
TLS
+   stream dropped, because they contain both data that has been encrypted =
by
+   software and data that expects hardware crypto offload.
=20
 Notable corner cases, exceptions and additional requirements
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.21.0

