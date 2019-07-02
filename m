Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C45D8D1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGCA3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:29:48 -0400
Received: from mail-eopbgr130044.outbound.protection.outlook.com ([40.107.13.44]:61870
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbfGCA3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1Wo7sm0dSi1achw/mk8G6VLATbGAi1CywKuDxJQ4CI=;
 b=UviZ23nsQ9fVH94P2p51ZuK1KDnvq06PZmycNAt5R0H6UgckcjPOepQicNNV5cbg5nSSsaimoRHMbDmDX5Ut4/ll5H2fHdYSvtGmZVBhf2B5xLcgP2pHpBbjqUqlxr3EuVL4UDWUKcf/WbDzJ/lVduzUo27M0z7lS2lslXXQd74=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2565.eurprd05.prod.outlook.com (10.168.74.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 23:55:11 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 23:55:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shay Agroskin <shayag@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 2/2] net/mlx5: Added devlink info callback
Thread-Topic: [PATCH net-next 2/2] net/mlx5: Added devlink info callback
Thread-Index: AQHVMTGVr7B+oXUr20aTu8Fl1Lgr6A==
Date:   Tue, 2 Jul 2019 23:55:11 +0000
Message-ID: <20190702235442.1925-3-saeedm@mellanox.com>
References: <20190702235442.1925-1-saeedm@mellanox.com>
In-Reply-To: <20190702235442.1925-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:74::40) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c2e9b9d-e2ab-4e65-a85f-08d6ff48b7e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2565;
x-ms-traffictypediagnostic: DB6PR0501MB2565:
x-microsoft-antispam-prvs: <DB6PR0501MB25650A81B6192E1DCA468A5DBEF80@DB6PR0501MB2565.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(199004)(189003)(386003)(99286004)(66066001)(52116002)(76176011)(6916009)(6506007)(1076003)(81166006)(8676002)(478600001)(50226002)(3846002)(81156014)(71190400001)(71200400001)(305945005)(6116002)(68736007)(36756003)(14444005)(14454004)(6486002)(66476007)(107886003)(6512007)(6436002)(86362001)(53936002)(7736002)(66556008)(66446008)(64756008)(73956011)(5660300002)(4326008)(2906002)(25786009)(66946007)(2616005)(54906003)(486006)(446003)(26005)(102836004)(186003)(476003)(256004)(316002)(11346002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2565;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: snHI7UpsDnVgZe0mFZNEBaKGUbeqsFME+7mUImz9+K98zhn4u0NWPE3gCk8Ks5FAGZR7seTl9xfDMl2ozXIypobbEQn9OzoWX0MB8dMGAEPtkPocNH0RxoB0Nwfy16Cj8QWRpL3qkSTxf8V6ZeQ3CiatHoqJI4PKVLkNws6MitPT4i8RdnG7O9RctXKnYSEMFKohXJgZXRl9j33icuDd8I0qllk4KmX16NtcD3A7cMTZZphdX5edgoxTt2cMsUclp0mcu3XTaEgbiA4g4RuGElrSW7TWOAp+3/ulAvqPdlyNk6UfmhfMzCRyChlLQN7c6zjPoM2JwWw7gN4ew776c8g3O9q27DGMZHhdWHbHNo97gSGhbU4v213j7EQUAse59Ow+FpjldhJXPKxwshp7bPCnNiLl8SZ5hgOJ4f70ghI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2e9b9d-e2ab-4e65-a85f-08d6ff48b7e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 23:55:11.1588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayag@mellanox.com>

The callback is invoked using 'devlink dev info <pci>' command and returns
the running and pending firmware version of the HCA and the name of the
kernel driver.

If there is a pending firmware version (a new version is burned but the
HCA still runs with the previous) it is returned as the stored
firmware version. Otherwise, the running version is returned for this
field.

Output example:
$ devlink dev info pci/0000:00:06.0
pci/0000:00:06.0:
  driver mlx5_core
  versions:
      fixed:
        fw.psid MT_0000000009
      running:
        fw.version 16.26.0100
      stored:
        fw.version 16.26.0100

Signed-off-by: Shay Agroskin <shayag@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 19 ++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 60 +++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index 4eeef2df912f..214325897732 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -10,6 +10,7 @@ Contents
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
 - `Enabling the driver and kconfig options`_
+- `Devlink info`_
 - `Devlink health reporters`_
=20
 Enabling the driver and kconfig options
@@ -101,6 +102,24 @@ Enabling the driver and kconfig options
 - CONFIG_VXLAN: When chosen, mlx5 vxaln support will be enabled.
 - CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enable=
d (via devlink and ethtool).
=20
+Devlink info
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The devlink info reports the running and stored firmware versions on devic=
e.
+It also prints the device PSID which represents the HCA board type ID.
+
+User command example::
+
+   $ devlink dev info pci/0000:00:06.0
+      pci/0000:00:06.0:
+      driver mlx5_core
+      versions:
+         fixed:
+            fw.psid MT_0000000009
+         running:
+            fw.version 16.26.0100
+         stored:
+            fw.version 16.26.0100
=20
 Devlink health reporters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 1533c657220b..a400f4430c28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -25,6 +25,65 @@ static int mlx5_devlink_flash_update(struct devlink *dev=
link,
 	return mlx5_firmware_flash(dev, fw, extack);
 }
=20
+static u8 mlx5_fw_ver_major(u32 version)
+{
+	return (version >> 24) & 0xff;
+}
+
+static u8 mlx5_fw_ver_minor(u32 version)
+{
+	return (version >> 16) & 0xff;
+}
+
+static u16 mlx5_fw_ver_subminor(u32 version)
+{
+	return version & 0xffff;
+}
+
+#define DEVLINK_FW_STRING_LEN 32
+
+static int
+mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *re=
q,
+		      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	char version_str[DEVLINK_FW_STRING_LEN];
+	u32 running_fw, stored_fw;
+	int err;
+
+	err =3D devlink_info_driver_name_put(req, DRIVER_NAME);
+	if (err)
+		return err;
+
+	err =3D devlink_info_version_fixed_put(req, "fw.psid", dev->board_id);
+	if (err)
+		return err;
+
+	err =3D mlx5_fw_version_query(dev, &running_fw, &stored_fw);
+	if (err)
+		return err;
+
+	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
+		 mlx5_fw_ver_major(running_fw), mlx5_fw_ver_minor(running_fw),
+		 mlx5_fw_ver_subminor(running_fw));
+	err =3D devlink_info_version_running_put(req, "fw.version", version_str);
+	if (err)
+		return err;
+
+	/* no pending version, return running (stored) version */
+	if (stored_fw =3D=3D 0)
+		stored_fw =3D running_fw;
+
+	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
+		 mlx5_fw_ver_major(stored_fw), mlx5_fw_ver_minor(stored_fw),
+		 mlx5_fw_ver_subminor(stored_fw));
+	err =3D devlink_info_version_stored_put(req, "fw.version", version_str);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -35,6 +94,7 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.eswitch_encap_mode_get =3D mlx5_devlink_eswitch_encap_mode_get,
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
+	.info_get =3D mlx5_devlink_info_get,
 };
=20
 struct devlink *mlx5_devlink_alloc(void)
--=20
2.21.0

