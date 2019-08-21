Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5899987DE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfHUX3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:29:06 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko2BlRNR0FtPu0UEKUzhu62bXzyw4sqd8lyT3Hm6mR+5MD7gzEcvi/SdqS6IEEX7H98hs5mHLmp5RERgVnFg0MRE4KSXqR3cCtW6a1jcvRNhipdSSnnTqe5ctdWeTbMT500s5iDq2HyeO3giepJt+So3iK6s6ctT1ELkGt0PgeKk7nRIKyC5lSnnC9yCTFA3WLLSgkhivs0PAJoXqO7u13IwnbQ6k0F1nmcQz7Og8qBIiRAkiS778C5uz7VL1JfMpp3FP6LlS/s6q6gFRntVoI4JZ0dtGZLORsMMzCtC0CERePNDOiDC1DXa2oX36D1KDftdlYWP+L6Z+Zutrthn9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go5HKSXbsW8/JU74lDSG/wczgEDWX0EmX2JV7MpIiKE=;
 b=h9QW81tTDvNMFTp0IhEzfOdUH6wl+HbRXNoNB6Amz4odUsrYwAEEao5kVlJsBK83nzSYFesvjVm8pHVR8POMK2U5TGS7/Z+P1m/kP+yqVZI62/6fd70e6XoYpeob2QpDcYk+SuXGnxDkkOrQRGtzRpDbAjqzBIPHCeFQceEOiNFhj8gd/Pcrh5iwyR5JUK1QhFFxOBh1Q2bO5nlH9fyrzr8X1v25Wq9ZmEToiw38+aDNiu0PJdYQJhUZfqUiKtAd1opKQ5mC65L9GRGHKgPmSxKZBYyPJpni1CeCkDjjWRBGxZRpE2R0pQXh91ioryhAluwQmnowvF2IM4NEQElU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go5HKSXbsW8/JU74lDSG/wczgEDWX0EmX2JV7MpIiKE=;
 b=h9udVVG9cFtJlKZ/Pt5NwbWwOci8Qy51/DlL6EL5EpuiZ1vfJz1w7k32kR6343afikaPm4r0wVTDJMVAEcU/CPlbQvsVfoLIu7bbPQRTqxR7gKs9JPV8II562cUXp6/eQJLWInGOS9tpRSnh576Q26KNNpKZPeo41eY+Mb35KNc=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:53 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/11] net/mlx5e: Add trace point for neigh update
Thread-Topic: [net-next 11/11] net/mlx5e: Add trace point for neigh update
Thread-Index: AQHVWHgx4lAEHDzkzU2vhxLX9VhHCQ==
Date:   Wed, 21 Aug 2019 23:28:53 +0000
Message-ID: <20190821232806.21847-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 8ac091cd-c2df-4466-d0a9-08d7268f5456
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674E29F3B2D556B487713C2BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IX0XRXqAGWIwkCDTCSbOG0k0+fuSgqdAYYAIvHdXspSTIizXSNq3QeqexOTNMJNaBnjneCfnOE/L/n3wkPNYbCPW+noiJWZlKauzmfVj8UCIkMfaY5uHo9l7/TSoqcB2R+dIOxo0v50dmSLd5KWDtexZxkVksRWfaDKSq0J8Rtjs/pyFfI/fq5UhrwD8e+uuPj7er238Pe74ZXBuOuHhguwOoyEL+uMiw2XEVvfar/R1gytyiliNfo9NlKOu97iMLy1Kx/8OSGdOezmIsM07GgHsYXT9bmApDrJgjGy84HL9199X91ZqSE2ge3FzKVmlIaPD7cJLZSL19E46xE7p9EQjK2GLSUtdEmUPAjZBUy7CgefDEIq2eseQfM9XhE1RO9p5d2Q8t8NmJ1AZOYq4Mo2XeMVnBRYwqDXTAiOcZJ4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac091cd-c2df-4466-d0a9-08d7268f5456
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:53.5867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhh8iNk8SNENOWlPfh85JIlxuV6IRWvKg7y1V5yAuV22SKY0lJ1lq2s4VhNaWap0ISgEu9FLrJkvMiUOOWfVOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Allow tracing neigh state during neigh update task that is executed on
workqueue and is scheduled by neigh state change event.

Usage example:
 ># cd /sys/kernel/debug/tracing
 ># echo mlx5:mlx5e_rep_neigh_update >> set_event
 ># cat trace
    ...
    kworker/u48:7-2221  [009] ...1  1475.387435: mlx5e_rep_neigh_update:
netdev: ens1f0 MAC: 24:8a:07:9a:17:9a IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 =
neigh_connected=3D1

Added corresponding documentation in
    Documentation/networking/device-driver/mellanox/mlx5.rst

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          |  7 +++
 .../mlx5/core/diag/en_rep_tracepoint.h        | 54 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 ++
 3 files changed, 65 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tra=
cepoint.h

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index b2f21ce9b090..b30a63dbf4b7 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -258,3 +258,10 @@ tc and eswitch offloads tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     kworker/u48:4-8806  [009] ...1 55117.882428: mlx5e_tc_update_neigh_use=
d_value: netdev: ens1f0 IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_used=3D1
+
+- mlx5e_rep_neigh_update: trace neigh update tasks scheduled due to neigh =
state change events::
+
+    $ echo mlx5:mlx5e_rep_neigh_update >> /sys/kernel/debug/tracing/set_ev=
ent
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u48:7-2221  [009] ...1  1475.387435: mlx5e_rep_neigh_update: n=
etdev: ens1f0 MAC: 24:8a:07:9a:17:9a IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 n=
eigh_connected=3D1
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint=
.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
new file mode 100644
index 000000000000..1177860a2ee4
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_EN_REP_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_EN_REP_TP_
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+#include "en_rep.h"
+
+TRACE_EVENT(mlx5e_rep_neigh_update,
+	    TP_PROTO(const struct mlx5e_neigh_hash_entry *nhe, const u8 *ha,
+		     bool neigh_connected),
+	    TP_ARGS(nhe, ha, neigh_connected),
+	    TP_STRUCT__entry(__string(devname, nhe->m_neigh.dev->name)
+			     __array(u8, ha, ETH_ALEN)
+			     __array(u8, v4, 4)
+			     __array(u8, v6, 16)
+			     __field(bool, neigh_connected)
+			     ),
+	    TP_fast_assign(const struct mlx5e_neigh *mn =3D &nhe->m_neigh;
+			struct in6_addr *pin6;
+			__be32 *p32;
+
+			__assign_str(devname, mn->dev->name);
+			__entry->neigh_connected =3D neigh_connected;
+			memcpy(__entry->ha, ha, ETH_ALEN);
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
+	    TP_printk("netdev: %s MAC: %pM IPv4: %pI4 IPv6: %pI6c neigh_connected=
=3D%d\n",
+		      __get_str(devname), __entry->ha,
+		      __entry->v4, __entry->v6, __entry->neigh_connected
+		      )
+);
+
+#endif /* _MLX5_EN_REP_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ./diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE en_rep_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 5217f39828a4..3c0d36b2b91c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -46,6 +46,8 @@
 #include "en/tc_tun.h"
 #include "fs_core.h"
 #include "lib/port_tun.h"
+#define CREATE_TRACE_POINTS
+#include "diag/en_rep_tracepoint.h"
=20
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
         max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
@@ -657,6 +659,8 @@ static void mlx5e_rep_neigh_update(struct work_struct *=
work)
=20
 	neigh_connected =3D (nud_state & NUD_VALID) && !dead;
=20
+	trace_mlx5e_rep_neigh_update(nhe, ha, neigh_connected);
+
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
 		if (!mlx5e_encap_take(e))
 			continue;
--=20
2.21.0

