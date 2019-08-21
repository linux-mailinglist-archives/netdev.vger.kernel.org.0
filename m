Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CF8987DD
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbfHUX3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:29:03 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729635AbfHUX3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJccRyyuCjwEA+rcl8Chs45FPvXNWFv4F5YjpvPPOzxGisWa/BITr0BZXZ53JTx2GjC4TuO79F6ACoHEYQjOw9StX1lIAySbXiRDs6f63+sMtz6JlLSmeR0PeG950flg+X288QNVu72zBV6MHur1A73rqHsVsNcUR+zTAfV8Ii+ZFM9XMT6aVviJP2G7rHphNyq4fcDewgWHeheDeM6xQFYYYBaW2r+gaFCRUTTBRKNHfE+uH6kDthxajEhA9M3JDbg2e5qPagOwDGPMmwyqS5jsnT33B8GZH8eShjn0QtA64TrhZZZYgGdGtVUaTNqbYy7nnP0BNofL9VRSZ7eplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zWsJmpt/k54o6K/az5zwypP5T9jXD/1cvJp+No5OUo=;
 b=FtakRv3XapEJ5FvajZodNcdVi7AnChi6HQVji8Ztm9S3JCiWFI1dUL9rRO+vapVBUP5elov7GIaRRlHAP32V0625LGNlzL6OkgnQZSpA9pwPOcvbxzpoykyCAoRT1JBiU/i2VYFbDuyamfR87LqeuxvsUnKyo2esb0l8LH6azj8LI6Mz+1Vf6Pz7V6O3K+VUYK9TXuuMwqvwXQMrh/idfD7KiMuypQ7HD4CpFP0C1BpiDZZ4kbCUiav+LdpnVN4FW9GoFpvQyqrzqvcEp9nLHXcUmdW+5DGkdJWx/Am5j0h5cOHrIPNbRC1QqrqLX/4p1spl4/7SAQnvFnCnEDOZSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zWsJmpt/k54o6K/az5zwypP5T9jXD/1cvJp+No5OUo=;
 b=XfGRAwDhUCno028aBD8y1C61MJ0kfDd7HXxSOI0t5pPxENPLM48DvkE6V6i8E1prb3CgAnbJsolKXD0Mj/D5ST3PylEaLNd9viD/emZRyX7IQPXzRdJ0jvX8V1Id8Eszd6Av3wU0d3r3v0p0TI6VACpa+01hGHQ79Eu5kqUWd0Y=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:52 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/11] net/mlx5e: Add trace point for neigh used value
 update
Thread-Topic: [net-next 10/11] net/mlx5e: Add trace point for neigh used value
 update
Thread-Index: AQHVWHgxUO73pAZERUWgMKhpEbJJeg==
Date:   Wed, 21 Aug 2019 23:28:51 +0000
Message-ID: <20190821232806.21847-11-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f0814cc-67db-479a-f54c-08d7268f534e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26743D50C2ED21858E98A7C7BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WjKd/kHGuWnDrJsBaM45Ybx1q8wVoPvXR/NG0kAHgU5KoErC7f3Y3iyeq9wZrdWx59dvrhaivAOxiq4WNSPqmUS2VwR/d71vUGXSS+aFJtCFomrY3V7kryiCXppj4s4TMbTup/OYNz8V3tXm3tB/oQvuq9eK+8cLczx5melYAytWxEUxgyi/wRzVqzi2HaGeX8HsT8z/l8j124fJfntYVctvTDuvMt+0lxFIlDzVca2Rir0YCknAFwB+bIPvFu+FdxjCMJg1iax9ZndQnu5jsRCUjOM1e1+A/HXNsm125Acao9r454dFMN6luS6SgfJzzZ1XZTdU4f8BMHa6pvpcPIyN4w048NliZA1N5HVi09xEfCuEJl0Xz5nHhJHBST2j28QDBLVR0BzyoOV/idZtguiHdK6enT9vR0Uf4kEu3SM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0814cc-67db-479a-f54c-08d7268f534e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:51.9305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbFJCU+432OqKWtoOd5MfeEBZEDp2C8pgDL7S/FAugc3W8hZPrGr/zWf+bFbWFxyxPZBbg6dr3qjh/GZI0byUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Allow tracing result of neigh used value update task that is executed
periodically on workqueue.

Usage example:
 ># cd /sys/kernel/debug/tracing
 ># echo mlx5:mlx5e_tc_update_neigh_used_value >> set_event
 ># cat trace
    ...
    kworker/u48:4-8806  [009] ...1 55117.882428: mlx5e_tc_update_neigh_used=
_value:
netdev: ens1f0 IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_used=3D1

Added corresponding documentation in
    Documentation/networking/device-driver/mellanox/mlx5.rst

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          |  7 +++++
 .../mlx5/core/diag/en_tc_tracepoint.h         | 31 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 ++
 3 files changed, 40 insertions(+)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index 1339dbf52431..b2f21ce9b090 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -251,3 +251,10 @@ tc and eswitch offloads tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     tc-6546  [010] ...1  2679.704889: mlx5e_stats_flower: cookie=3D0000000=
060eb3d6a bytes=3D0 packets=3D0 lastused=3D4295560217
+
+- mlx5e_tc_update_neigh_used_value: trace tunnel rule neigh update value o=
ffloaded to mlx5::
+
+    $ echo mlx5:mlx5e_tc_update_neigh_used_value >> /sys/kernel/debug/trac=
ing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u48:4-8806  [009] ...1 55117.882428: mlx5e_tc_update_neigh_use=
d_value: netdev: ens1f0 IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_used=3D1
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.=
h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
index a362100fe6d3..d4e6cfaaade3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
@@ -10,6 +10,7 @@
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 #include <net/flow_offload.h>
+#include "en_rep.h"
=20
 #define __parse_action(ids, num) parse_action(p, ids, num)
=20
@@ -73,6 +74,36 @@ TRACE_EVENT(mlx5e_stats_flower,
 		      )
 );
=20
+TRACE_EVENT(mlx5e_tc_update_neigh_used_value,
+	    TP_PROTO(const struct mlx5e_neigh_hash_entry *nhe, bool neigh_used),
+	    TP_ARGS(nhe, neigh_used),
+	    TP_STRUCT__entry(__string(devname, nhe->m_neigh.dev->name)
+			     __array(u8, v4, 4)
+			     __array(u8, v6, 16)
+			     __field(bool, neigh_used)
+			     ),
+	    TP_fast_assign(const struct mlx5e_neigh *mn =3D &nhe->m_neigh;
+			struct in6_addr *pin6;
+			__be32 *p32;
+
+			__assign_str(devname, mn->dev->name);
+			__entry->neigh_used =3D neigh_used;
+
+			p32 =3D (__be32 *)__entry->v4;
+			pin6 =3D (struct in6_addr *)__entry->v6;
+			if (mn->family =3D=3D AF_INET) {
+				*p32 =3D mn->dst_ip.v4;
+				ipv6_addr_set_v4mapped(*p32, pin6);
+			} else if (mn->family =3D=3D AF_INET6) {
+				*pin6 =3D mn->dst_ip.v6;
+			}
+			),
+	    TP_printk("netdev: %s IPv4: %pI4 IPv6: %pI6c neigh_used=3D%d\n",
+		      __get_str(devname), __entry->v4, __entry->v6,
+		      __entry->neigh_used
+		      )
+);
+
 #endif /* _MLX5_TC_TP_ */
=20
 /* This part must be outside protection */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index c40cca08c8cc..5581a8045ede 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1536,6 +1536,8 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_ne=
igh_hash_entry *nhe)
 		}
 	}
=20
+	trace_mlx5e_tc_update_neigh_used_value(nhe, neigh_used);
+
 	if (neigh_used) {
 		nhe->reported_lastuse =3D jiffies;
=20
--=20
2.21.0

