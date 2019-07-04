Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC11D5FCC5
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfGDSQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:10 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbfGDSQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXKIc3mFvtaC2V88MPmRMkcp5sE5DkoRDxUY9AVoeiQ=;
 b=S2Sg4UAV8NKzAzh6o/9EGXjKGJMgvE/QSyYebo9zXBX5nYAhoIv/I7ypFfL07qqbaMs6til/W5v+XZesPlSPeS6XztheBFUN9b1706ItXVHCP4yq1M+ZruMrMkECpy+I0uosobOdONLBslBRVia3AyZI3fqWnAeS9UGWFDgVQw0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/14] net/mlx5: Kconfig, Better organize compilation flags
Thread-Topic: [net-next 04/14] net/mlx5: Kconfig, Better organize compilation
 flags
Thread-Index: AQHVMpSD8GGC4o7D+kCHrcYPG43ZZQ==
Date:   Thu, 4 Jul 2019 18:15:52 +0000
Message-ID: <20190704181235.8966-5-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08453cc0-39d4-4004-f4c2-08d700aba633
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB258469702E5F6FC37C4A569DBEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PIo7FJyFR8dUTBMmmAUaz9JqQZGDNdqfY8KE+WXSl2mExh9BZ9DAJDVM4zT5FxOzknYr3Cm3EKDCbDU+H5PMkx1dXlm/0HnZbAFS0Z1mNi+wFmivFcOhop9TAAC69r9GEy2U/h0k3u8dbDctDVT2Wq9wqqAEXZAmP9L9WtA/L/4IGsWX8D+veXZ4dOP9d4GmjRAKpmVhlw+s3TOL757nk81XCmMH7on7DNQ6gHnlmFbF7ObvNBGYSeuNl2UYOTszjWSr0YBVIhkRFOkmyuZ5TMY7bF8bGMtqFP66Lf/MyDHLzHz9UcXmGIXL4Oi9OP+AcbtV25beHh5dl4CVxWRwLesPuxKFLQNXaUcaKLa/laAJ6Q0aIgOy4rgFU5aplqmtiBkAxbpHG83YejDU1vdReaEuCw6wXS9ku/AIuGGgJIE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08453cc0-39d4-4004-f4c2-08d700aba633
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:52.8768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Always contain all acceleration functions declarations in
'accel' files, independent to the flags setting.
For this, introduce new flags CONFIG_FPGA_{IPSEC/TLS} and use stubs
where needed.

This obsoletes the need for stubs in 'fpga' files. Remove them.

Also use the new flags in Makefile, to decide whether to compile
TLS-specific or IPSEC-specific objects, or not.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 43 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  7 +-
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c |  4 +
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h |  2 +-
 .../ethernet/mellanox/mlx5/core/accel/tls.c   |  3 +
 .../ethernet/mellanox/mlx5/core/accel/tls.h   |  4 +-
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.h  | 75 -------------------
 include/linux/mlx5/accel.h                    |  2 +-
 8 files changed, 47 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 7845aa5bf6be..6556490d809c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -97,26 +97,49 @@ config MLX5_CORE_IPOIB
 	---help---
 	  MLX5 IPoIB offloads & acceleration support.
=20
+config MLX5_FPGA_IPSEC
+	bool "Mellanox Technologies IPsec Innova support"
+	depends on MLX5_CORE
+	depends on MLX5_FPGA
+	default n
+	help
+	Build IPsec support for the Innova family of network cards by Mellanox
+	Technologies. Innova network cards are comprised of a ConnectX chip
+	and an FPGA chip on one board. If you select this option, the
+	mlx5_core driver will include the Innova FPGA core and allow building
+	sandbox-specific client drivers.
+
 config MLX5_EN_IPSEC
 	bool "IPSec XFRM cryptography-offload accelaration"
-	depends on MLX5_ACCEL
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
+	depends on MLX5_FPGA_IPSEC
 	default n
-	---help---
+	help
 	  Build support for IPsec cryptography-offload accelaration in the NIC.
 	  Note: Support for hardware with this capability needs to be selected
 	  for this option to become available.
=20
-config MLX5_EN_TLS
-	bool "TLS cryptography-offload accelaration"
-	depends on MLX5_CORE_EN
+config MLX5_FPGA_TLS
+	bool "Mellanox Technologies TLS Innova support"
 	depends on TLS_DEVICE
 	depends on TLS=3Dy || MLX5_CORE=3Dm
-	depends on MLX5_ACCEL
+	depends on MLX5_FPGA
 	default n
-	---help---
-	  Build support for TLS cryptography-offload accelaration in the NIC.
-	  Note: Support for hardware with this capability needs to be selected
-	  for this option to become available.
+	help
+	Build TLS support for the Innova family of network cards by Mellanox
+	Technologies. Innova network cards are comprised of a ConnectX chip
+	and an FPGA chip on one board. If you select this option, the
+	mlx5_core driver will include the Innova FPGA core and allow building
+	sandbox-specific client drivers.
+
+config MLX5_EN_TLS
+	bool "TLS cryptography-offload accelaration"
+	depends on MLX5_CORE_EN
+	depends on MLX5_FPGA_TLS
+	default y
+	help
+	Build support for TLS cryptography-offload accelaration in the NIC.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 6aa0fe6de878..da7adac6b4a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -53,10 +53,11 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) +=3D ipoib/ipoib.o =
ipoib/ethtool.o ipoib/ipoib
 #
 # Accelerations & FPGA
 #
-mlx5_core-$(CONFIG_MLX5_ACCEL) +=3D accel/ipsec.o accel/tls.o
+mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) +=3D fpga/ipsec.o
+mlx5_core-$(CONFIG_MLX5_FPGA_TLS)   +=3D fpga/tls.o
+mlx5_core-$(CONFIG_MLX5_ACCEL)      +=3D accel/tls.o accel/ipsec.o
=20
-mlx5_core-$(CONFIG_MLX5_FPGA) +=3D fpga/cmd.o fpga/core.o fpga/conn.o fpga=
/sdk.o \
-				 fpga/ipsec.o fpga/tls.o
+mlx5_core-$(CONFIG_MLX5_FPGA) +=3D fpga/cmd.o fpga/core.o fpga/conn.o fpga=
/sdk.o
=20
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) +=3D en_accel/ipsec.o en_accel/ipsec_rxt=
x.o \
 				     en_accel/ipsec_stats.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/driver=
s/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index d1e76d5a413b..eddc34e4a762 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -31,6 +31,8 @@
  *
  */
=20
+#ifdef CONFIG_MLX5_FPGA_IPSEC
+
 #include <linux/mlx5/device.h>
=20
 #include "accel/ipsec.h"
@@ -112,3 +114,5 @@ int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xf=
rm *xfrm,
 	return mlx5_fpga_esp_modify_xfrm(xfrm, attrs);
 }
 EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/driver=
s/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index 93b3f5faddb5..530e428d46ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -37,7 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/accel.h>
=20
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_FPGA_IPSEC
=20
 #define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
 			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/=
net/ethernet/mellanox/mlx5/core/accel/tls.c
index da7bd26368f9..a2c9eda1ebf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -35,6 +35,8 @@
=20
 #include "accel/tls.h"
 #include "mlx5_core.h"
+
+#ifdef CONFIG_MLX5_FPGA_TLS
 #include "fpga/tls.h"
=20
 int mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
@@ -78,3 +80,4 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev)
 {
 	mlx5_fpga_tls_cleanup(mdev);
 }
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/=
net/ethernet/mellanox/mlx5/core/accel/tls.h
index def4093ebfae..e5d306ad7f91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -37,8 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/tls.h>
=20
-#ifdef CONFIG_MLX5_ACCEL
-
+#ifdef CONFIG_MLX5_FPGA_TLS
 enum {
 	MLX5_ACCEL_TLS_TX =3D BIT(0),
 	MLX5_ACCEL_TLS_RX =3D BIT(1),
@@ -88,7 +87,6 @@ static inline bool mlx5_accel_is_tls_device(struct mlx5_c=
ore_dev *mdev) { return
 static inline u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev) {=
 return 0; }
 static inline int mlx5_accel_tls_init(struct mlx5_core_dev *mdev) { return=
 0; }
 static inline void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev) { }
-
 #endif
=20
 #endif	/* __MLX5_ACCEL_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers=
/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index 2b5e63b0d4d6..382985e65b48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -37,8 +37,6 @@
 #include "accel/ipsec.h"
 #include "fs_cmd.h"
=20
-#ifdef CONFIG_MLX5_FPGA
-
 u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
 unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev);
 int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counter=
s,
@@ -66,77 +64,4 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm=
 *xfrm,
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
=20
-#else
-
-static inline u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline unsigned int
-mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev=
,
-						u64 *counters)
-{
-	return 0;
-}
-
-static inline void *
-mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
-			      struct mlx5_accel_esp_xfrm *accel_xfrm,
-			      const __be32 saddr[4],
-			      const __be32 daddr[4],
-			      const __be32 spi, bool is_ipv6)
-{
-	return NULL;
-}
-
-static inline void mlx5_fpga_ipsec_delete_sa_ctx(void *context)
-{
-}
-
-static inline int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev)
-{
-}
-
-static inline void mlx5_fpga_ipsec_build_fs_cmds(void)
-{
-}
-
-static inline struct mlx5_accel_esp_xfrm *
-mlx5_fpga_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			  const struct mlx5_accel_esp_xfrm_attrs *attrs,
-			  u32 flags)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static inline void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *=
xfrm)
-{
-}
-
-static inline int
-mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			  const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline const struct mlx5_flow_cmds *
-mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
-{
-	return mlx5_fs_cmd_get_default(type);
-}
-
-#endif /* CONFIG_MLX5_FPGA */
-
 #endif	/* __MLX5_FPGA_SADB_H__ */
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 70e7e5673ce9..5613e677a5f9 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -114,7 +114,7 @@ enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN	=3D 1 << 7,
 };
=20
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_FPGA_IPSEC
=20
 u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev);
=20
--=20
2.21.0

