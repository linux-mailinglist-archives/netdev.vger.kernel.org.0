Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6139F174760
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgB2Ob3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:29 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33101 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgB2Ob2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so11496586wmc.0
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hH0t7NX96AJWvKvK79DFse3KK1YTF0HTKIuAFUkO47w=;
        b=D0QU+H97YMc/IcTeTWAZMEblk8O8zM3fkERvsOibGvoQ1nfPKeSoAjsZtDUV8+KDTg
         9Og89y0VQfdcmhzo2IyXtSoJyATWgI3xsuM7Nre2DfJllbT0cdpyUGF0Uw9imCq4o7H2
         lvzOYfUom3luSWSs1ieg9Jyc5jSTS3wASxToZdPQP6EDwSOjbMWMoVyogjcQO2x7iCRr
         OiXdFmFGAjAQBIzL8ACLpJ2AQJ+3WI6jwlpZEYLO//cKSrOEuIpWjxyaHQVdc+OqOU7A
         YN1bUa/yucaQDXwgLyuBRfIWFoDkV5I/bJnPKg+YJBSNtz6Mlvb7/nDY5/cyISFEotjh
         u/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hH0t7NX96AJWvKvK79DFse3KK1YTF0HTKIuAFUkO47w=;
        b=aqGa3FrlCZsR2EVXlUl68TYZkkHKDs246RGbu7HWJHBcphRG+gdicK8SQ+Wdc5mKKQ
         G3JZ9v/SRYufCRZl9mgJ7nRxYabRllURLyb6For4GvsXXlvmSupzThL/8HM3/4YKRMxR
         iYuQawTWzRXvLR20yNhJK9jjzE+aUwGCzPs0SFgRHwwtKT10vnhy3VO0pvUmuQrEQznl
         CdteVmIaJ0bTTQM6WkGipgEcmFlodINqbMFOitnC3H4aqCAuU1srv6XqBAENmyTGR7B0
         QwJFRe2K3g+tRdhSCs+moRWU83onzIfy/yOKBgxxT3TLkI9ASu3+t06tomkmv2vmF+O3
         lx3w==
X-Gm-Message-State: APjAAAXZBcrtCSWgH+YlRZC/xdl4LxkEy3eMA8d+K+vBy63CWWNba2u2
        8vrJ0yiyNbx81gomwfXxi00=
X-Google-Smtp-Source: APXvYqw1PEiUy1CpbGE8FZdHnMzaxpuY5QfyT9kW7N0555sUo90bcL1almAuyWRc0gF36c5x+V91/g==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr10173127wmi.35.1582986685826;
        Sat, 29 Feb 2020 06:31:25 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 05/10] net: mscc: ocelot: spell out full "ocelot" name instead of "oc"
Date:   Sat, 29 Feb 2020 16:31:09 +0200
Message-Id: <20200229143114.10656-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a cosmetic patch that makes the name of the driver private
variable be used uniformly in ocelot_ace.c as in the rest of the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_ace.c | 45 ++++++++++++++------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 375c7c6aa7d5..ec86d29d8be4 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -93,12 +93,12 @@ struct vcap_data {
 	u32 tg_mask; /* Current type-group mask */
 };
 
-static u32 vcap_s2_read_update_ctrl(struct ocelot *oc)
+static u32 vcap_s2_read_update_ctrl(struct ocelot *ocelot)
 {
-	return ocelot_read(oc, S2_CORE_UPDATE_CTRL);
+	return ocelot_read(ocelot, S2_CORE_UPDATE_CTRL);
 }
 
-static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
+static void vcap_cmd(struct ocelot *ocelot, u16 ix, int cmd, int sel)
 {
 	u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
 		     S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
@@ -116,42 +116,42 @@ static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
 	if (!(sel & VCAP_SEL_COUNTER))
 		value |= S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
 
-	ocelot_write(oc, value, S2_CORE_UPDATE_CTRL);
-	readx_poll_timeout(vcap_s2_read_update_ctrl, oc, value,
+	ocelot_write(ocelot, value, S2_CORE_UPDATE_CTRL);
+	readx_poll_timeout(vcap_s2_read_update_ctrl, ocelot, value,
 				(value & S2_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
 				10, 100000);
 }
 
 /* Convert from 0-based row to VCAP entry row and run command */
-static void vcap_row_cmd(struct ocelot *oc, u32 row, int cmd, int sel)
+static void vcap_row_cmd(struct ocelot *ocelot, u32 row, int cmd, int sel)
 {
-	vcap_cmd(oc, vcap_is2.entry_count - row - 1, cmd, sel);
+	vcap_cmd(ocelot, vcap_is2.entry_count - row - 1, cmd, sel);
 }
 
-static void vcap_entry2cache(struct ocelot *oc, struct vcap_data *data)
+static void vcap_entry2cache(struct ocelot *ocelot, struct vcap_data *data)
 {
 	u32 i;
 
 	for (i = 0; i < vcap_is2.entry_words; i++) {
-		ocelot_write_rix(oc, data->entry[i], S2_CACHE_ENTRY_DAT, i);
-		ocelot_write_rix(oc, ~data->mask[i], S2_CACHE_MASK_DAT, i);
+		ocelot_write_rix(ocelot, data->entry[i], S2_CACHE_ENTRY_DAT, i);
+		ocelot_write_rix(ocelot, ~data->mask[i], S2_CACHE_MASK_DAT, i);
 	}
-	ocelot_write(oc, data->tg, S2_CACHE_TG_DAT);
+	ocelot_write(ocelot, data->tg, S2_CACHE_TG_DAT);
 }
 
-static void vcap_cache2entry(struct ocelot *oc, struct vcap_data *data)
+static void vcap_cache2entry(struct ocelot *ocelot, struct vcap_data *data)
 {
 	u32 i;
 
 	for (i = 0; i < vcap_is2.entry_words; i++) {
-		data->entry[i] = ocelot_read_rix(oc, S2_CACHE_ENTRY_DAT, i);
+		data->entry[i] = ocelot_read_rix(ocelot, S2_CACHE_ENTRY_DAT, i);
 		// Invert mask
-		data->mask[i] = ~ocelot_read_rix(oc, S2_CACHE_MASK_DAT, i);
+		data->mask[i] = ~ocelot_read_rix(ocelot, S2_CACHE_MASK_DAT, i);
 	}
-	data->tg = ocelot_read(oc, S2_CACHE_TG_DAT);
+	data->tg = ocelot_read(ocelot, S2_CACHE_TG_DAT);
 }
 
-static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
+static void vcap_action2cache(struct ocelot *ocelot, struct vcap_data *data)
 {
 	u32 i, width, mask;
 
@@ -163,21 +163,24 @@ static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
 	}
 
 	for (i = 0; i < vcap_is2.action_words; i++)
-		ocelot_write_rix(oc, data->action[i], S2_CACHE_ACTION_DAT, i);
+		ocelot_write_rix(ocelot, data->action[i],
+				 S2_CACHE_ACTION_DAT, i);
 
 	for (i = 0; i < vcap_is2.counter_words; i++)
-		ocelot_write_rix(oc, data->counter[i], S2_CACHE_CNT_DAT, i);
+		ocelot_write_rix(ocelot, data->counter[i],
+				 S2_CACHE_CNT_DAT, i);
 }
 
-static void vcap_cache2action(struct ocelot *oc, struct vcap_data *data)
+static void vcap_cache2action(struct ocelot *ocelot, struct vcap_data *data)
 {
 	u32 i, width;
 
 	for (i = 0; i < vcap_is2.action_words; i++)
-		data->action[i] = ocelot_read_rix(oc, S2_CACHE_ACTION_DAT, i);
+		data->action[i] = ocelot_read_rix(ocelot, S2_CACHE_ACTION_DAT,
+						  i);
 
 	for (i = 0; i < vcap_is2.counter_words; i++)
-		data->counter[i] = ocelot_read_rix(oc, S2_CACHE_CNT_DAT, i);
+		data->counter[i] = ocelot_read_rix(ocelot, S2_CACHE_CNT_DAT, i);
 
 	/* Extract action type */
 	width = vcap_is2.action_type_width;
-- 
2.17.1

