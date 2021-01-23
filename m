Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87253018F8
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 00:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbhAWXvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 18:51:19 -0500
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:22582
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbhAWXvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 18:51:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqs2n3k6YdT0b3wDW1JZxNX+52Gxgz2TV0d8XXYvcqEmDc5cdEC2DoQ0cjLH+PzQFTkhGJx0fNXFSIe/DYvQE0XPG3XoloPXQjF1wu+WuziIpCTgn+bJUyXzldsc0kote9mgRWX7gQmXK2+/Ju/QfsiQl/DeJmARz4TfD/m65DGJeK0nIXvnvYuXfYIU6pKhsBvGJA8g8uy9+M9qABeSBEprBE7997vN9YpFrbccLmCOCRDj5Lttw8g1ScwBJIFVaowkIBAzZzINLFRrcQsdWw/poJQoAsYz2h5CfUQDQIQqRIBmO6Vtnkyc4SDMMhS00td7oDcIDCj8SpnQDre4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILQ26fpNK3mJhdTA0zMWip7nrhKBPj9NJr9cF7zIAFo=;
 b=E2VyKBT/1wYQzXDH2kmY5/SO+ImZrtvB51cGfuVyrfdt4qLXLwIPd1To1obvOh7oCJB76g+I0HT5fC+M6Td66dK3w0CZd2hrF9nLaW9HPnlQ3GHXg+XsQggNmCUzts1x3JPyWwEngZZb4wUjM+k7zqpjtxK0/ZunYRDsoSFo3POIPgybkV3ZP2Ke+gqrAxY9XuLeKScofmE8Th+E8RuK3vWkc0ZPXROUebMDuGhpcEukThsUmSbdcraKzFm5LLc/F7cFIossIPGAC0WmCsse1hI+hXJUr0Uz5eQX/zaseeoqmqdJs8bm3NGCczPnZLXTtjujauwTTQbSFtobBNM8PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILQ26fpNK3mJhdTA0zMWip7nrhKBPj9NJr9cF7zIAFo=;
 b=hgCzKMha8o9j2aaSbGoqDwJlxvtBUtYTaoB++DAv9FWPVx5nJyEeLPa6V8NAWfzCp4CtcDDJc1LBRkp14zPe4WBVMBWXgWGIl3FWTmUEvsw0QTiudzaKpf0wr+ifzwTf30Q3LbQUAef8DLoQaK9x8eR4Dol5cDIRjOIwwM9Luos=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 23:50:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Sat, 23 Jan 2021
 23:50:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>
Subject: Re: [PATCH] dsa: mv88e6xxx: Make global2 support mandatory
Thread-Topic: [PATCH] dsa: mv88e6xxx: Make global2 support mandatory
Thread-Index: AQHW8cmmgyg7z6oS/ESFjAtIjtOmHqo14XUA
Date:   Sat, 23 Jan 2021 23:50:25 +0000
Message-ID: <20210123235024.u5tfe2x57thdrisd@skbuf>
References: <20210123205148.545214-1-andrew@lunn.ch>
In-Reply-To: <20210123205148.545214-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ed7961e2-f32f-4fa8-7eb6-08d8bff9a828
x-ms-traffictypediagnostic: VI1PR04MB6943:
x-microsoft-antispam-prvs: <VI1PR04MB6943ED592FBBC3AE8786B774E0BF0@VI1PR04MB6943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 54qXDtVIsFhjATA2fkigutoVFGIAEpmfJfT5oOXGjZb9PNI0cCgtmtPv2PeO28pWtSGK8a1sIQyIcz7NthhOe3hOjW7ngBZDW3lxc5kxSCFEHdGQNOzWq9RnCK8egnELyM0h0gMFB5nrFEpLWlpkcQrd2cuCHMSp3PFdD4NaojWnteFWAlCps7zuiOZGFwTbqHya3fqnAez0DjEKzMNTbVycG9OkdwHfAPPztc6Igl9lOYefKSEKLn3X5EThbxwPDnAf1z1Iuus7QBSX0L/gUhVRIFN6uBwkiLnAX+jWjc1Vb7HRFpxY/UyjRLhlkQOmTcnWJ1k6nXVy8gOTC9jvEr51DizanxrpJeVfVb7yIoDUGoCoz7McqwJAcnz5niKsyYR9d5eKtvI3zmrtvf3F+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(366004)(396003)(39850400004)(376002)(346002)(6512007)(44832011)(86362001)(9686003)(33716001)(6486002)(4326008)(71200400001)(316002)(66476007)(83380400001)(6506007)(64756008)(66556008)(53546011)(478600001)(66946007)(66446008)(186003)(5660300002)(26005)(2906002)(8936002)(8676002)(110136005)(54906003)(1076003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Wqoin2D4ubviwmJvfy435bA7eZN58dSNQLqOiewPW5Kq2RUIyb0qIOJ1+7zY?=
 =?us-ascii?Q?la3Vk6v3m5pKjf5Pq127q7rUw7rxqtPFrDpq3sKdZoDpq3suZcFv6afw7HyW?=
 =?us-ascii?Q?iKHDUJutwJET3pNbNkN048XstuZORv/iB9qgmsFbND04N7GylA7dpbWYJ22M?=
 =?us-ascii?Q?MqgMBwOIsjT0NS9Z8AupZxTFhC0oeEYeUItWygJrXtmmn5VyJK9449w7OCVS?=
 =?us-ascii?Q?6ljklzgIO2mizksXn9oZZKpXjfAn2BFy1x3lYgeMru/HdeYIbYsWNpHAw6Ef?=
 =?us-ascii?Q?Mosq6jpUTqtCjjlzDSLF/rOpVJ4pUjZ+d4vWGmlCU6J4INtPCGloXOQ9hlXy?=
 =?us-ascii?Q?85pdTRUcaT1rYFclUI3G+kzp/GHQMAIFkA/TrvhI1QW1ey/2vjb4F6ZDKc6V?=
 =?us-ascii?Q?ucwoIHuobfZkGvL/j5xbk8vOxd9dGSikiv+lHwtiHcWw1AQN+ITQ8TOQgZ2x?=
 =?us-ascii?Q?n6GBLI9+jeCOcFR0U1IWlT0ZB90QTBdY3IGfnFNh+6rrev9i/7v5g6igmeBD?=
 =?us-ascii?Q?/XRFvaoeBa5RHgURpWDNYA5wiPtOXJrHB3UjH5uqWpS/38mYxHSk0SNFgySi?=
 =?us-ascii?Q?9XQmLQv+ioc7fX502Hi2cSPKzgI5HNYGqxda9WjiE6DjrO+IJW89m8s8legg?=
 =?us-ascii?Q?t8uO1WgAp3wkw9d7PJmpwUSBaM5OHIQMExe9ugiX+gsp/OpvHFroGFqilV2B?=
 =?us-ascii?Q?qYVa+oz5u2wGQNoyrCUnibjtqh17oqa/BfwUyW2UeEkx9CEORwAXIstJHrp7?=
 =?us-ascii?Q?Dqd3PUKOBJkZmV3LkWOUllPp5m1YmpdXayRXjJc8Qu7DqRS/2qSZG+Nbk0ZG?=
 =?us-ascii?Q?nOo+60ZoOreNgFA1cghNtbYIkYX5Xp2BfFfdzZeIx1ZcPNKzspHvK93TDrgG?=
 =?us-ascii?Q?QPQlkEk1WtX55BJki4UULx+2zYYqrt4PhyxAE3Ym6Y71hmcFoF/bhQIJt2ey?=
 =?us-ascii?Q?6vzRKTocUTrGKsyOePLbqDm+EB0cvBKEoWwfM5omf6WRMcKkmUNwG0vAh9ZN?=
 =?us-ascii?Q?oeui?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C704297853B66418E13D2E217DE9AC2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7961e2-f32f-4fa8-7eb6-08d8bff9a828
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 23:50:25.7705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8u+iit3j6vPj/owRHeh6tCaXDndxfQ2Y4H6OekKD0ciVDDKxFs824Q+pGBJ55b4u5GpepIrJ15fxU00P09KaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Vivien who added the optional support in the first place
________________________________
From: Andrew Lunn <andrew@lunn.ch>
Sent: Sat, Jan 23, 2021 at 09:51:48PM +0100
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev <netdev@vger.kernel.org>, Vladimir Oltean <vladimir.oltean@nxp.c=
om>, Florian Fainelli <f.fainelli@gmail.com>, tobias@waldekranz.com, Andrew=
 Lunn <andrew@lunn.ch>
Subject: [PATCH] dsa: mv88e6xxx: Make global2 support mandatory

Early generations of the mv88e6xxx did not have the global 2
registers. In order to keep the driver slim, it was decided to make
the code for these registers optional. Over time, more generations of
switches have been added, always supporting global 2 and adding more
and more registers. No effort has been made to keep these additional
registers also optional to slim the driver down when used for older
generations. Optional global 2 now just gives additional development
and maintenance burden for no real gain.

Make global 2 support always compiled in.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/Kconfig   |  12 --
 drivers/net/dsa/mv88e6xxx/Makefile  |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c    |   4 -
 drivers/net/dsa/mv88e6xxx/global2.h | 194 ----------------------------
 4 files changed, 3 insertions(+), 213 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/=
Kconfig
index 51185e4d7d15..8e7dcd57927c 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -9,21 +9,9 @@ config NET_DSA_MV88E6XXX
 	  This driver adds support for most of the Marvell 88E6xxx models of
 	  Ethernet switch chips, except 88E6060.
=20
-config NET_DSA_MV88E6XXX_GLOBAL2
-	bool "Switch Global 2 Registers support"
-	default y
-	depends on NET_DSA_MV88E6XXX
-	help
-	  This registers set at internal SMI address 0x1C provides extended
-	  features like EEPROM interface, trunking, cross-chip setup, etc.
-
-	  It is required on most chips. If the chip you compile the support for
-	  doesn't have such registers set, say N here. In doubt, say Y.
-
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX_GLOBAL2
 	depends on PTP_1588_CLOCK
 	imply NETWORK_PHY_TIMESTAMPING
 	help
diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx=
/Makefile
index 4b080b448ce7..c8eca2b6f959 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -5,9 +5,9 @@ mv88e6xxx-objs +=3D devlink.o
 mv88e6xxx-objs +=3D global1.o
 mv88e6xxx-objs +=3D global1_atu.o
 mv88e6xxx-objs +=3D global1_vtu.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) +=3D global2.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) +=3D global2_avb.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) +=3D global2_scratch.o
+mv88e6xxx-objs +=3D global2.o
+mv88e6xxx-objs +=3D global2_avb.o
+mv88e6xxx-objs +=3D global2_scratch.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) +=3D hwtstamp.o
 mv88e6xxx-objs +=3D phy.o
 mv88e6xxx-objs +=3D port.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/c=
hip.c
index 2f976050a0d7..2a70d379aa4c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5227,10 +5227,6 @@ static int mv88e6xxx_detect(struct mv88e6xxx_chip *c=
hip)
 	/* Update the compatible info with the probed one */
 	chip->info =3D info;
=20
-	err =3D mv88e6xxx_g2_require(chip);
-	if (err)
-		return err;
-
 	dev_info(chip->dev, "switch 0x%x detected: %s, revision %u\n",
 		 chip->info->prod_num, chip->info->name, rev);
=20
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xx=
x/global2.h
index 253a79582a1d..4127f82275ad 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -296,13 +296,6 @@
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_TRIG	1
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_EVREQ	2
=20
-#ifdef CONFIG_NET_DSA_MV88E6XXX_GLOBAL2
-
-static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
-{
-	return 0;
-}
-
 int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
 int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg,
@@ -370,191 +363,4 @@ int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xx=
x_chip *chip,
 int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 =
bin);
 int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats);
=20
-#else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
-
-static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
-{
-	if (chip->info->global2_addr) {
-		dev_err(chip->dev, "this chip requires CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 =
enabled\n");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static inline int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, =
u16 *val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg,=
 u16 val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip,
-					int reg, int bit, int val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6352_g2_irl_init_all(struct mv88e6xxx_chip *chip,
-					    int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6390_g2_irl_init_all(struct mv88e6xxx_chip *chip,
-					    int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_smi_phy_read(struct mv88e6xxx_chip *chip,
-					    struct mii_bus *bus,
-					    int addr, int reg, u16 *val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_smi_phy_write(struct mv88e6xxx_chip *chip,
-					     struct mii_bus *bus,
-					     int addr, int reg, u16 val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip,
-					      u8 *addr)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_get_eeprom8(struct mv88e6xxx_chip *chip,
-					   struct ethtool_eeprom *eeprom,
-					   u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_eeprom8(struct mv88e6xxx_chip *chip,
-					   struct ethtool_eeprom *eeprom,
-					   u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_get_eeprom16(struct mv88e6xxx_chip *chip,
-					    struct ethtool_eeprom *eeprom,
-					    u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_eeprom16(struct mv88e6xxx_chip *chip,
-					    struct ethtool_eeprom *eeprom,
-					    u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_pvt_write(struct mv88e6xxx_chip *chip,
-					 int src_dev, int src_port, u16 data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_misc_4_bit_port(struct mv88e6xxx_chip *chip=
)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void mv88e6xxx_g2_irq_free(struct mv88e6xxx_chip *chip)
-{
-}
-
-static inline int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
-					      struct mii_bus *bus)
-{
-	return 0;
-}
-
-static inline void mv88e6xxx_g2_irq_mdio_free(struct mv88e6xxx_chip *chip,
-					      struct mii_bus *bus)
-{
-}
-
-static inline int mv88e6185_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6352_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops =3D {};
-static const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops =3D {};
-static const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops =3D {};
-
-static const struct mv88e6xxx_avb_ops mv88e6165_avb_ops =3D {};
-static const struct mv88e6xxx_avb_ops mv88e6352_avb_ops =3D {};
-static const struct mv88e6xxx_avb_ops mv88e6390_avb_ops =3D {};
-
-static const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops =3D {};
-
-static inline int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip =
*chip,
-						    bool external)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chi=
p,
-						int num, bool hash, u16 mask)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *=
chip,
-						   int id, u16 map)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip =
*chip,
-						    int target, int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
-					     u16 kind, u16 bin)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip,
-					     u16 *stats)
-{
-	return -EOPNOTSUPP;
-}
-
-#endif /* CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
-
 #endif /* _MV88E6XXX_GLOBAL2_H */
--=20
2.30.0
