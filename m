Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9A49F344
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346281AbiA1GGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346280AbiA1GGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:03 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E4EC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:03 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id y23so10435427oia.13
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g9+jt0eVpYcOaVMQlRYqf1iTfieifhfIM7pI7QZJI1s=;
        b=nGTFE8BNls02CyxhaiE6JCLGqFEqIBYHA6tyQmOuPAWzw5kSpj42lfb6sYyPcHkKIi
         CM5Iz2A6D94V+YMuPgUhDhErhlMqlAh8gu35+o4DhWjBOduXEwIsCFZmKLTo3wYL11r+
         RlCl1HHJgfnOvrzkAhX4CSrlUYsSL2QW4LeqW7FCt/BYWMVY/9EPMYrC/LVZjNh+oezG
         bT2fTYygRSGBjNIkq+ZC8AwkLrf0EJoFzTI8rZkkdlABoNO+JWV5iOdAxCZlcWSvpYxW
         yUC72Vtx4YvXx78T2mVxuiIPbqtULfyriRS2tbgUc6zxwBYz9ZPkvp5LXzrQCdb+B0cq
         MJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9+jt0eVpYcOaVMQlRYqf1iTfieifhfIM7pI7QZJI1s=;
        b=Idz8Je89oolgvfUF3SeGzLahGykF8SLScIfaTzCdbNKxLh9YkiA84ciw+zZabOeTj0
         YbAuUMWmmWNGZ/03pGS5ZITm6sEGpHbMAEu2GY50KPFAYkYYjgcgIsuZOxb7HfI+zPr4
         mr7SZYjjJprLbnnYV0AxLt5QrxGzABRJpnnqbxiZJ2+MolVGeaHQuinhxnCyfbsy4lVO
         GFJv9yjf2MFFW+jjXq3A6kVB4BVKbEDsGY/0wDsV5MN0O3p5ZzAk8y7cHmKELKeA/nLn
         lQckGdxKag8b+7BAFANI4CKb9OtbzLxRKNh1kWoa1fjyWsaRXD/wwloM/In5gAUBFH6B
         vCtQ==
X-Gm-Message-State: AOAM531MMtdqGNlXI+TWp/vf41YGQ7FsOu81TMEIGhO+0NTPmp9sjyL7
        D7W5ZBxaqCjYE8YPlexA3bzbmwR+fwpMOQ==
X-Google-Smtp-Source: ABdhPJxojL6f3DcZKSTYktSDMzYv1I9w9NmbnYN/czjCp0Zojob3113LVYVGXASK/M/l6L4L1mTXZg==
X-Received: by 2002:aca:c056:: with SMTP id q83mr9271667oif.294.1643349962607;
        Thu, 27 Jan 2022 22:06:02 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:02 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 07/13] net: dsa: realtek: rtl8365mb: rename extport to extint
Date:   Fri, 28 Jan 2022 03:05:03 -0300
Message-Id: <20220128060509.13800-8-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"extport" 0, 1, 2 was used to reference external ports id (ext0, ext1,
ext2). Meanwhile, port 0..9 is used as switch ports, including external
ports. "extport" was renamed to extint to make it clear it does not mean
the port number but the external interface number id.

The macros that map extint numbers to registers addresses now use inline
ifs instead of binary arithmetic.

Realtek uses in docs and drivers EXT_PORT0 (GMAC1) and EXT_PORT1
(GMAC2), with EXT_PORT0 being converted to ext_id == 1 and so on. It
might introduce some confusing while reading datasheets but it will not
be exposed to users.

"extint" was hardcoded to 1. However, some chips have multiple external
interfaces. It's not right to assume the CPU port uses extint 1 nor that
all extint are CPU ports. Now it came from a map between port number and
external interface id number.

This patch still does not allow multiple CPU ports nor extint as a non
CPU port.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 124 +++++++++++++++++-----------
 1 file changed, 76 insertions(+), 48 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index b411b620fec1..8bffdcb99a3d 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -105,6 +105,7 @@
 #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
 #define RTL8365MB_CPU_PORT_NUM_8365MB_VC	6
 #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
+static const int rtl8365mb_extint_port_map[] = { -1, -1, -1, -1, -1, -1, 1 };
 
 /* Family-specific data and limits */
 #define RTL8365MB_PHYADDRMAX	7
@@ -191,7 +192,7 @@
 /* The PHY OCP addresses of PHY registers 0~31 start here */
 #define RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE		0xA400
 
-/* EXT port interface mode values - used in DIGITAL_INTERFACE_SELECT */
+/* EXT interface port mode values - used in DIGITAL_INTERFACE_SELECT */
 #define RTL8365MB_EXT_PORT_MODE_DISABLE		0
 #define RTL8365MB_EXT_PORT_MODE_RGMII		1
 #define RTL8365MB_EXT_PORT_MODE_MII_MAC		2
@@ -207,39 +208,56 @@
 #define RTL8365MB_EXT_PORT_MODE_1000X		12
 #define RTL8365MB_EXT_PORT_MODE_100FX		13
 
-/* EXT port interface mode configuration registers 0~1 */
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extport)   \
-		(RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 + \
-		 ((_extport) >> 1) * (0x13C3 - 0x1305))
-#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extport) \
-		(0xF << (((_extport) % 2)))
-#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extport) \
-		(((_extport) % 2) * 4)
-
-/* EXT port RGMII TX/RX delay configuration registers 1~2 */
-#define RTL8365MB_EXT_RGMXF_REG1		0x1307
-#define RTL8365MB_EXT_RGMXF_REG2		0x13C5
-#define RTL8365MB_EXT_RGMXF_REG(_extport)   \
-		(RTL8365MB_EXT_RGMXF_REG1 + \
-		 (((_extport) >> 1) * (0x13C5 - 0x1307)))
+/* Realtek docs and driver uses logic number as EXT_PORT0=16, EXT_PORT1=17,
+ * EXT_PORT2=18, to interact with switch ports. That logic number is internally
+ * converted to either a physical port number (0..9) or an external interface id (0..2),
+ * depending on which function was called. The external interface id is calculated as
+ * (ext_id=logic_port-15), while the logical to physical map depends on the chip id/version.
+ *
+ * EXT_PORT0 mentioned in datasheets and rtl8367c driver is used in this driver
+ * as extid==1, EXT_PORT2, mentioned in Realtek rtl8367c driver for 10-port switches,
+ * would have an ext_id of 3 (out of range for most extint macros) and ext_id 0 does
+ * not seem to be used as well for this family.
+ */
+
+/* EXT interface mode configuration registers 0~1 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /* EXT1 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /* EXT2 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
+		((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
+		 0x0)
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
+		(0xF << (((_extint) % 2)))
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
+		(((_extint) % 2) * 4)
+
+/* EXT interface RGMII TX/RX delay configuration registers 0~2 */
+#define RTL8365MB_EXT_RGMXF_REG0		0x1306 /* EXT0 */
+#define RTL8365MB_EXT_RGMXF_REG1		0x1307 /* EXT1 */
+#define RTL8365MB_EXT_RGMXF_REG2		0x13C5 /* EXT2 */
+#define RTL8365MB_EXT_RGMXF_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_EXT_RGMXF_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_EXT_RGMXF_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_EXT_RGMXF_REG2 : \
+		 0x0)
 #define   RTL8365MB_EXT_RGMXF_RXDELAY_MASK	0x0007
 #define   RTL8365MB_EXT_RGMXF_TXDELAY_MASK	0x0008
 
-/* External port speed values - used in DIGITAL_INTERFACE_FORCE */
+/* External interface port speed values - used in DIGITAL_INTERFACE_FORCE */
 #define RTL8365MB_PORT_SPEED_10M	0
 #define RTL8365MB_PORT_SPEED_100M	1
 #define RTL8365MB_PORT_SPEED_1000M	2
 
-/* EXT port force configuration registers 0~2 */
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0			0x1310
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1			0x1311
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2			0x13C4
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extport)   \
-		(RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 + \
-		 ((_extport) & 0x1) +                     \
-		 ((((_extport) >> 1) & 0x1) * (0x13C4 - 0x1310)))
+/* EXT interface force configuration registers 0~2 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0		0x1310 /* EXT0 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1		0x1311 /* EXT1 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2		0x13C4 /* EXT2 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2 : \
+		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_EN_MASK		0x1000
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_NWAY_MASK		0x0080
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_TXPAUSE_MASK	0x0040
@@ -755,20 +773,25 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	struct dsa_port *dp;
 	int tx_delay = 0;
 	int rx_delay = 0;
-	int ext_port;
+	int ext_int;
 	u32 val;
 	int ret;
 
-	if (port == priv->cpu_port) {
-		ext_port = 1;
-	} else {
-		dev_err(priv->dev, "only one EXT port is currently supported\n");
+	if (port != priv->cpu_port) {
+		dev_err(priv->dev, "only one EXT interface is currently supported\n");
 		return -EINVAL;
 	}
 
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
+	ext_int = rtl8365mb_extint_port_map[port];
+
+	if (ext_int <= 0) {
+		dev_err(priv->dev, "Port %d is not an external interface port\n", port);
+		return -EINVAL;
+	}
+
 	/* Set the RGMII TX/RX delay
 	 *
 	 * The Realtek vendor driver indicates the following possible
@@ -798,7 +821,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			tx_delay = val / 2;
 		else
 			dev_warn(priv->dev,
-				 "EXT port TX delay must be 0 or 2 ns\n");
+				 "EXT interface TX delay must be 0 or 2 ns\n");
 	}
 
 	if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
@@ -808,11 +831,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			rx_delay = val;
 		else
 			dev_warn(priv->dev,
-				 "EXT port RX delay must be 0 to 2.1 ns\n");
+				 "EXT interface RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
+		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_int),
 		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
 			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -821,11 +844,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return ret;
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
-		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
+		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_int),
+		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int),
 		RTL8365MB_EXT_PORT_MODE_RGMII
 			<< RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
-				   ext_port));
+				   ext_int));
 	if (ret)
 		return ret;
 
@@ -841,14 +864,19 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
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
-		dev_err(priv->dev, "only one EXT port is currently supported\n");
+	if (port != priv->cpu_port) {
+		dev_err(priv->dev, "only one EXT interface is currently supported\n");
+		return -EINVAL;
+	}
+
+	ext_int = rtl8365mb_extint_port_map[port];
+
+	if (ext_int <= 0) {
+		dev_err(priv->dev, "Port %d is not an external interface port\n", port);
 		return -EINVAL;
 	}
 
@@ -898,7 +926,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 			 r_duplex) |
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
 	ret = regmap_write(priv->map,
-			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_port),
+			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_int),
 			   val);
 	if (ret)
 		return ret;
@@ -1831,10 +1859,6 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
-		/* Set up per-port private data */
-		p->priv = priv;
-		p->index = i;
-
 		/* Forward only to the CPU */
 		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
 		if (ret)
@@ -1850,6 +1874,10 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		 * administratively down by default.
 		 */
 		rtl8365mb_port_stp_state_set(priv->ds, i, BR_STATE_DISABLED);
+
+		/* Set up per-port private data */
+		p->priv = priv;
+		p->index = i;
 	}
 
 	/* Set maximum packet length to 1536 bytes */
-- 
2.34.1

