Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092EB1BE796
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD2Tqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726971AbgD2Tqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275F2C03C1AE;
        Wed, 29 Apr 2020 12:46:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so1517818pgo.3;
        Wed, 29 Apr 2020 12:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IC8rInsRsfxQQkeZ96jiqZI2NB9+ZDmlgZxQ89+Ot80=;
        b=paR6J4V7t7ggij3212zO9WTKEHqxQ694sFMqY5KOZ6Kj80QQQWcOfaNTFW9mNpeNJB
         zkfylNpl61H4q3BShKA6SvHuadb/M+9lFT+342Bi3z49vxWc6nfdHfZGIOcwGm/AEAOd
         4Go4ygTVo5yEtEbGz852J0YB73dNU9wi96IgXKRqIoKvUigvUiH83f74ld28/nIOK40d
         u4/u6nRLBMNlsHNblfS3AxXpH5O1CG65TpopLnOz5lSwtGEiJrbZgt6AAv7FcFizP2RW
         6qe3h9qzLjFWF4DD4OrCp4uIiWt/NB/gxKWsYnWjqENgRwiZN6iIAWiOYvwVsbKEFOMh
         xGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IC8rInsRsfxQQkeZ96jiqZI2NB9+ZDmlgZxQ89+Ot80=;
        b=jNsg1T66rWoBmADRifCwzt2roVcclcJNB/mEEAjETfm2D4ckAw0OI4nTtGSGZsG04K
         B5VGaKdh+V6G5K+xI1GX5r6o12qDiLElbud9c0QuJoC7OZVikNsLMd1ULn1SEc68V0jc
         tRh7e0qfFakC7znXioB3EvtRz7pcZS4bE072pWc6/Fwoskv4R+7YS+tIr9Jbtiq4p2cX
         VBzT+YlWMtDk60jrkWev4F4Sjz6PqewmwNjbEVYNFejoNgkuieUpYZKoIyYn4j7WPT03
         hVV3Iut1VJtEBRDg6WBV5RnfgyWLtZJQxxl40PfNfddDL1yYcWORfCmc0J4whHXep0Eg
         KMMg==
X-Gm-Message-State: AGi0Pub3Oc+zztkxmBlDlkRF1PJ+4nvjb7oOwEGbMC5PFU6xTen+9wm2
        eEyuit6+brJS5b9waEsti1E=
X-Google-Smtp-Source: APiQypKb6CuWqjtblFyZXArLk7f3xcyxGSQoP6KBmr2h3ic5miU4eeuz6w4pDkhmY0pz+y1l2qmk/g==
X-Received: by 2002:aa7:948f:: with SMTP id z15mr29197733pfk.129.1588189602515;
        Wed, 29 Apr 2020 12:46:42 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:41 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 4/7] Revert "net: bcmgenet: remove unused function in bcmgenet.c"
Date:   Wed, 29 Apr 2020 12:45:49 -0700
Message-Id: <1588189552-899-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit e2072600a24161b7ddcfb26814f69f5fbc8ef85a.

This commit restores the previous implementation of Hardware Filter
Block functions to the file for use in subsequent commits.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 122 +++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 57b8608feae1..b37ef05c5083 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2759,6 +2759,128 @@ static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 }
 
+static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
+					   u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	return !!(reg & (1 << (f_index % 32)));
+}
+
+static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg |= (1 << (f_index % 32));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
+						     u32 f_index, u32 rx_queue)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = f_index / 8;
+	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
+	reg &= ~(0xF << (4 * (f_index % 8)));
+	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
+	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
+}
+
+static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
+					   u32 f_index, u32 f_length)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_LEN_V3PLUS +
+		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
+		 sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg &= ~(0xFF << (8 * (f_index % 4)));
+	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
+{
+	u32 f_index;
+
+	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
+		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
+			return f_index;
+
+	return -ENOMEM;
+}
+
+/* bcmgenet_hfb_add_filter
+ *
+ * Add new filter to Hardware Filter Block to match and direct Rx traffic to
+ * desired Rx queue.
+ *
+ * f_data is an array of unsigned 32-bit integers where each 32-bit integer
+ * provides filter data for 2 bytes (4 nibbles) of Rx frame:
+ *
+ * bits 31:20 - unused
+ * bit  19    - nibble 0 match enable
+ * bit  18    - nibble 1 match enable
+ * bit  17    - nibble 2 match enable
+ * bit  16    - nibble 3 match enable
+ * bits 15:12 - nibble 0 data
+ * bits 11:8  - nibble 1 data
+ * bits 7:4   - nibble 2 data
+ * bits 3:0   - nibble 3 data
+ *
+ * Example:
+ * In order to match:
+ * - Ethernet frame type = 0x0800 (IP)
+ * - IP version field = 4
+ * - IP protocol field = 0x11 (UDP)
+ *
+ * The following filter is needed:
+ * u32 hfb_filter_ipv4_udp[] = {
+ *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+ *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
+ *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
+ * };
+ *
+ * To add the filter to HFB and direct the traffic to Rx queue 0, call:
+ * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
+ *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
+ */
+int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
+			    u32 f_length, u32 rx_queue)
+{
+	int f_index;
+	u32 i;
+
+	f_index = bcmgenet_hfb_find_unused_filter(priv);
+	if (f_index < 0)
+		return -ENOMEM;
+
+	if (f_length > priv->hw_params->hfb_filter_size)
+		return -EINVAL;
+
+	for (i = 0; i < f_length; i++)
+		bcmgenet_hfb_writel(priv, f_data[i],
+			(f_index * priv->hw_params->hfb_filter_size + i) *
+			sizeof(u32));
+
+	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
+	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+	bcmgenet_hfb_enable_filter(priv, f_index);
+	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
+
+	return 0;
+}
+
 /* bcmgenet_hfb_clear
  *
  * Clear Hardware Filter Block and disable all filtering.
-- 
2.7.4

