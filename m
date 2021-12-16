Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F816477D2F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhLPUOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241260AbhLPUOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:42 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CDFC06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:42 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id t6so119080qkg.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0LmjyK+2zVn20q1+6xXaTvbtM6sOZn2sG53WToXfZ4c=;
        b=kk1oE63Y6bFdcwviI88NY1pEfgZaBWxlbVC2RCqqKiK9ce9B0aWX1Etf+YcfNPjCNf
         W5BHoRZdtc/JTopi/ss8w7/xlli8zONdzyvDMOyGMEF5oBVPkC1MZTgoK2fSnGoMgj6y
         eQh5H4+UO+7aknWOGwynAgIYZTg7s/t9yWAcbyZUn55weL+mFeOzNCTCr17eUEdHynoj
         seCgS1QJPb81B/NINsKVuDDTU/zJc0t6HNyLdi1PYKBgAtAynZ7mZ9VV8R39n1s9V5i3
         KKEhPr4dcVnOfAAzsOY5vGbSg5clDvBINpm+m21MKyzZ8MXLPJgxSIub+TZfivg8ckyk
         4Ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0LmjyK+2zVn20q1+6xXaTvbtM6sOZn2sG53WToXfZ4c=;
        b=jNL5hy/SgUTsnvhC8mHbfJc5QFOwkK2blPVYBdu1/+ExZLHkTs8vCy2/KOmBUbJoBZ
         FPlwooGwoIvB+Y9jd90B4PJqrpnyn85xdDHIsiuNb+MMXJIg6886AnEbmtBVDiyIMZh6
         hPR7s078V/WuTmE2mWhl2jYpqGdgV2cEio6Id5YRIZYtZm31xFjk88PYmMgL3F6hGcTp
         a6xJiUkHT1Zl0GFoJ3sjRuE5URvNubu2iEshyVFiciPJNx58uE2G8Zw6/oRSEKfTo0ur
         2W5iKA8RZwJkm1z3dJUTufLtX8IGLLqovGnrgV1Eyz0AjH5JMjFSZIFLQDU66o+Cfdsc
         XcIg==
X-Gm-Message-State: AOAM530xUxKaOqej0dbs/Btr4rPP2wxDPZRcUqfZIZcqH1bprkfOHGx5
        +gKdHsSr2lW9Xg657JvkR6UYFzvuNej1lQ==
X-Google-Smtp-Source: ABdhPJxHuFD/XuxGF4Tu2uIwW4LhNk+ywoNiPBh7b2uoqRcnC8pebKPDoYGuB9nOMmmfo+qCi25V8w==
X-Received: by 2002:a05:620a:4507:: with SMTP id t7mr13504498qkp.582.1639685681171;
        Thu, 16 Dec 2021 12:14:41 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:40 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 10/13] net: dsa: realtek: rtl8367c: rename extport to extint, add "realtek,ext-int"
Date:   Thu, 16 Dec 2021 17:13:39 -0300
Message-Id: <20211216201342.25587-11-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

"extport" 0, 1, 2 was used to reference external ports (ext0,
ext1, ext2). Meanwhile, port 0..9 is used as switch ports,
including external ports. "extport" was renamed to extint to
make it clear it does not mean the port number but the external
interface number.

The macros that map extint numbers to registers addresses now
use inline ifs instead of binary arithmetic.

"extint" was hardcoded to 1. Now it can be defined with a device-tree
port property "realtek,ext-int";

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-smi.txt          |   4 +
 drivers/net/dsa/realtek/rtl8367c.c            | 106 ++++++++++++------
 2 files changed, 74 insertions(+), 36 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index 3a60e77ceed4..acdb026e5307 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -56,6 +56,10 @@ See net/mdio.txt for additional MDIO bus properties.
 See net/dsa/dsa.txt for a list of additional required and optional properties
 and subnodes of DSA switches.
 
+Optional properties of dsa port:
+
+- realtek,ext-int: defines the external interface number (0, 1, 2). By default, 1.
+
 Examples:
 
 An example for the RTL8366RB:
diff --git a/drivers/net/dsa/realtek/rtl8367c.c b/drivers/net/dsa/realtek/rtl8367c.c
index 98ec793a82bc..6aca48165d1f 100644
--- a/drivers/net/dsa/realtek/rtl8367c.c
+++ b/drivers/net/dsa/realtek/rtl8367c.c
@@ -197,22 +197,26 @@
 #define RTL8367C_EXT_PORT_MODE_100FX		13
 
 /* EXT port interface mode configuration registers 0~1 */
-#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG0		0x1305
-#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG1		0x13C3
-#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG(_extport)   \
-		(RTL8367C_DIGITAL_INTERFACE_SELECT_REG0 + \
-		 ((_extport) >> 1) * (0x13C3 - 0x1305))
-#define   RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extport) \
-		(0xF << (((_extport) % 2)))
-#define   RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extport) \
-		(((_extport) % 2) * 4)
-
-/* EXT port RGMII TX/RX delay configuration registers 1~2 */
-#define RTL8367C_EXT_RGMXF_REG1		0x1307
-#define RTL8367C_EXT_RGMXF_REG2		0x13C5
-#define RTL8367C_EXT_RGMXF_REG(_extport)   \
-		(RTL8367C_EXT_RGMXF_REG1 + \
-		 (((_extport) >> 1) * (0x13C5 - 0x1307)))
+#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /*EXT1*/
+#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /*EXT2*/
+#define RTL8367C_DIGITAL_INTERFACE_SELECT_REG(_extint) \
+		(_extint==1 ? RTL8367C_DIGITAL_INTERFACE_SELECT_REG0 : \
+		 _extint==2 ? RTL8367C_DIGITAL_INTERFACE_SELECT_REG1 : \
+		 0x0)
+#define   RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
+		(0xF << (((_extint) % 2)))
+#define   RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
+		(((_extint) % 2) * 4)
+
+/* EXT port RGMII TX/RX delay configuration registers 0~2 */
+#define RTL8367C_EXT_RGMXF_REG0		0x1306 /*EXT0*/
+#define RTL8367C_EXT_RGMXF_REG1		0x1307 /*EXT1*/
+#define RTL8367C_EXT_RGMXF_REG2		0x13C5 /*EXT2*/
+#define RTL8367C_EXT_RGMXF_REG(_extint) \
+		(_extint==0 ? RTL8367C_EXT_RGMXF_REG0 : \
+		 _extint==1 ? RTL8367C_EXT_RGMXF_REG1 : \
+		 _extint==2 ? RTL8367C_EXT_RGMXF_REG2 : \
+		 0x0)
 #define   RTL8367C_EXT_RGMXF_RXDELAY_MASK	0x0007
 #define   RTL8367C_EXT_RGMXF_TXDELAY_MASK	0x0008
 
@@ -222,13 +226,14 @@
 #define RTL8367C_PORT_SPEED_1000M	2
 
 /* EXT port force configuration registers 0~2 */
-#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG0			0x1310
-#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG1			0x1311
-#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG2			0x13C4
-#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG(_extport)   \
-		(RTL8367C_DIGITAL_INTERFACE_FORCE_REG0 + \
-		 ((_extport) & 0x1) +                     \
-		 ((((_extport) >> 1) & 0x1) * (0x13C4 - 0x1310)))
+#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG0		0x1310 /*EXT0*/
+#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG1		0x1311 /*EXT1*/
+#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG2		0x13C4 /*EXT2*/
+#define RTL8367C_DIGITAL_INTERFACE_FORCE_REG(_extint) \
+		(_extint==0 ? RTL8367C_DIGITAL_INTERFACE_FORCE_REG0 : \
+		 _extint==1 ? RTL8367C_DIGITAL_INTERFACE_FORCE_REG1 : \
+		 _extint==2 ? RTL8367C_DIGITAL_INTERFACE_FORCE_REG2 : \
+		 0x0)
 #define   RTL8367C_DIGITAL_INTERFACE_FORCE_EN_MASK		0x1000
 #define   RTL8367C_DIGITAL_INTERFACE_FORCE_NWAY_MASK		0x0080
 #define   RTL8367C_DIGITAL_INTERFACE_FORCE_TXPAUSE_MASK		0x0040
@@ -511,6 +516,7 @@ struct rtl8367c_cpu {
  *         access via rtl8367c_get_stats64
  * @stats_lock: protect the stats structure during read/update
  * @mib_work: delayed work for polling MIB counters
+ * @ext_int: the external interface related to this port (-1 to none)
  */
 struct rtl8367c_port {
 	struct realtek_priv *priv;
@@ -518,6 +524,7 @@ struct rtl8367c_port {
 	struct rtnl_link_stats64 stats;
 	spinlock_t stats_lock;
 	struct delayed_work mib_work;
+	int ext_int;
 };
 
 /**
@@ -733,15 +740,15 @@ static int rtl8367c_ext_config_rgmii(struct realtek_priv *priv, int port,
 {
 	struct device_node *dn;
 	struct dsa_port *dp;
+	struct rtl8367c_port *p;
+	struct rtl8367c *mb;
 	int tx_delay = 0;
 	int rx_delay = 0;
-	int ext_port;
+	int ext_int;
 	u32 val;
 	int ret;
 
-	if (port == priv->cpu_port) {
-		ext_port = 1;
-	} else {
+	if (port != priv->cpu_port) {
 		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
@@ -749,6 +756,10 @@ static int rtl8367c_ext_config_rgmii(struct realtek_priv *priv, int port,
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	/* Set the RGMII TX/RX delay
 	 *
 	 * The Realtek vendor driver indicates the following possible
@@ -792,7 +803,7 @@ static int rtl8367c_ext_config_rgmii(struct realtek_priv *priv, int port,
 	}
 
 	ret = regmap_update_bits(
-		priv->map, RTL8367C_EXT_RGMXF_REG(ext_port),
+		priv->map, RTL8367C_EXT_RGMXF_REG(ext_int),
 		RTL8367C_EXT_RGMXF_TXDELAY_MASK |
 			RTL8367C_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8367C_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -801,11 +812,11 @@ static int rtl8367c_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return ret;
 
 	ret = regmap_update_bits(
-		priv->map, RTL8367C_DIGITAL_INTERFACE_SELECT_REG(ext_port),
-		RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
+		priv->map, RTL8367C_DIGITAL_INTERFACE_SELECT_REG(ext_int),
+		RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int),
 		RTL8367C_EXT_PORT_MODE_RGMII
 			<< RTL8367C_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
-				   ext_port));
+				   ext_int));
 	if (ret)
 		return ret;
 
@@ -816,22 +827,26 @@ static int rtl8367c_ext_config_forcemode(struct realtek_priv *priv, int port,
 					  bool link, int speed, int duplex,
 					  bool tx_pause, bool rx_pause)
 {
+	struct rtl8367c_port *p;
+	struct rtl8367c *mb;
 	u32 r_tx_pause;
 	u32 r_rx_pause;
 	u32 r_duplex;
 	u32 r_speed;
 	u32 r_link;
-	int ext_port;
+	int ext_int;
 	int val;
 	int ret;
 
-	if (port == priv->cpu_port) {
-		ext_port = 1;
-	} else {
+	if (port != priv->cpu_port) {
 		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	if (link) {
 		/* Force the link up with the desired configuration */
 		r_link = 1;
@@ -878,7 +893,7 @@ static int rtl8367c_ext_config_forcemode(struct realtek_priv *priv, int port,
 			 r_duplex) |
 	      FIELD_PREP(RTL8367C_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
 	ret = regmap_write(priv->map,
-			   RTL8367C_DIGITAL_INTERFACE_FORCE_REG(ext_port),
+			   RTL8367C_DIGITAL_INTERFACE_FORCE_REG(ext_int),
 			   val);
 	if (ret)
 		return ret;
@@ -1807,7 +1822,9 @@ static int rtl8367c_setup(struct dsa_switch *ds)
 
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
+		struct device_node *dn;
 		struct rtl8367c_port *p = &mb->ports[i];
+		u32 val;
 
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
@@ -1831,6 +1848,23 @@ static int rtl8367c_setup(struct dsa_switch *ds)
 		 * administratively down by default.
 		 */
 		rtl8367c_port_stp_state_set(priv->ds, i, BR_STATE_DISABLED);
+
+		dn = dsa_to_port(priv->ds, i)->dn;
+
+		if (!of_property_read_u32(dn, "realtek,ext-int", &val)) {
+			if (val < 0 || val > 2) {
+				dev_err(priv->dev,
+					 "realtek,ext-int must be between 0 and 2 \n");
+				return -EINVAL;
+			}
+			p->ext_int = val;
+		} else {
+			if (dsa_is_cpu_port(priv->ds, i))
+				/* existing default */
+				p->ext_int = 1;
+			else
+				p->ext_int = -1;
+		}
 	}
 
 	/* Set maximum packet length to 1536 bytes */
-- 
2.34.0

