Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDECB1A73BF
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 08:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406047AbgDNGeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 02:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406042AbgDNGee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 02:34:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAC3C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 23:34:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n24so1569635plp.13
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 23:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCgKt0xDcuY135+09OPgT/EcdOM3zQzZDMMz+79/NNk=;
        b=GugkgpIEKM7VxKSpkpL0XWrFfsRSLr9R6sAT3M4Ho0by3ZOIaiRFiQwgmJxfblDGDt
         AmSot/Bf8QkjceqzqEiSBrmiB+0nJT5vzwQPFcPwYWiRa51uA8v8zvHyVW7+NQ+loWtd
         RcoNSCUvS1o+p6lyezjhC9jrPoglJbG3KaAsUjpvvRQajFiz0Zuoe2Yk65uWLlED1TyH
         ktBPQHGAzulACRYuF7ATq3FTHTEp4t3EkLe28BQn6+J8ZOg8UwJN+MVuPm1aa2OWOsUn
         T+IVtxqlq/OyDn6ZP7DoQTF3v70G+QcI82zJhdrwWeWwKTCMaUHzqE8PL8KlZ2g+mhJR
         hjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCgKt0xDcuY135+09OPgT/EcdOM3zQzZDMMz+79/NNk=;
        b=Zo7q+eHgjqVsQy8pI1M1MnKr1XeXUgNJIqz2+TL2vqRBVNgMfYWFx6JM5gQswgOv57
         lUebxUHcuhraASUkctL/lS1ZA3UaSlluWnaU8pcRIjeakxd2GXjIDB8fh+i80sCH5ER5
         rRuRtkaJAmk7GF2WluZOMK/vQinNEhJfT4qbwXscdmlnrfuA87DNfys4GoRGe6Wu+69q
         Nne9A9xm/w7iT2wf5UdhkP9hmJbhsDfHdfxfr35tzvHO1C+rMHcjvFwLr6wgH16VrI+Q
         RmpnRnCCFTx+oskFzZJye/F+I54ZS8OD0Y/SobDKvRYSUkGV86otay+dIdqo5Rf/PLCK
         43aw==
X-Gm-Message-State: AGi0PuY0iiJTXmEKUj3oTxF45ojWqio13kDeFfkbyO354OdBMWxy+iB8
        XOGsMhDm8o1vimAIOIPfb4/oDbzOOiCKuHZN
X-Google-Smtp-Source: APiQypI7bn1wRxKkG/AA79N2PtMpYLo3Khjme9hkksmNcibqEQKSlAuUAYStAhVxm92yzcMwNgmVAQ==
X-Received: by 2002:a17:90a:a111:: with SMTP id s17mr27456565pjp.129.1586846073031;
        Mon, 13 Apr 2020 23:34:33 -0700 (PDT)
Received: from example.com ([2408:84f3:1457:b125:9ead:97ff:fed1:5059])
        by smtp.gmail.com with ESMTPSA id i190sm8400774pfc.119.2020.04.13.23.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 23:34:32 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Stijn Segers <foss@volatilesystems.org>,
        Chuanhong Guo <gch981213@gmail.com>, riddlariddla@hotmail.com,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Szabolcs Hubai <szab.hu@gmail.com>,
        CHEN Minqiang <ptpt52@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH net-next v2] net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode
Date:   Tue, 14 Apr 2020 14:34:08 +0800
Message-Id: <20200414063408.4026-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In VLAN-unaware mode, the Egress Tag (EG_TAG) field in Port VLAN
Control register must be set to Consistent to let tagged frames pass
through as is, otherwise their tags will be stripped.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Changes since v1:
- Fix build error

---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++------
 drivers/net/dsa/mt7530.h |  7 +++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2d0d91db0ddb..951a65ac7f73 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -846,8 +846,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	 */
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_MATRIX_MODE);
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		if (dsa_is_user_port(ds, i) &&
@@ -863,8 +864,8 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	if (all_user_ports_removed) {
 		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
 			     PCR_MATRIX(dsa_user_ports(priv->ds)));
-		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT),
-			     PORT_SPEC_TAG);
+		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
+			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 }
 
@@ -890,8 +891,9 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
 	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_USER) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
 }
 
 static void
@@ -1380,6 +1382,10 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_cpu_port_enable(priv, i);
 		else
 			mt7530_port_disable(ds, i);
+
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
 	/* Setup port 5 */
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ef9b52f3152b..2528232d3325 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -172,9 +172,16 @@ enum mt7530_port_mode {
 /* Register for port vlan control */
 #define MT7530_PVC_P(x)			(0x2010 + ((x) * 0x100))
 #define  PORT_SPEC_TAG			BIT(5)
+#define  PVC_EG_TAG(x)			(((x) & 0x7) << 8)
+#define  PVC_EG_TAG_MASK		PVC_EG_TAG(7)
 #define  VLAN_ATTR(x)			(((x) & 0x3) << 6)
 #define  VLAN_ATTR_MASK			VLAN_ATTR(3)
 
+enum mt7530_vlan_port_eg_tag {
+	MT7530_VLAN_EG_DISABLED = 0,
+	MT7530_VLAN_EG_CONSISTENT = 1,
+};
+
 enum mt7530_vlan_port_attr {
 	MT7530_VLAN_USER = 0,
 	MT7530_VLAN_TRANSPARENT = 3,
-- 
2.26.0

