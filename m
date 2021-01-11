Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13BF2F1CE2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbhAKRo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387484AbhAKRoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:55 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB943C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id t16so755909ejf.13
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09ANKvrtXuGXu1v8xNA6s7Eeg28zKsj4U4YnsPfEQ0o=;
        b=I+LFKHWQUM/c9K6F0vR+cBwycs70UatyIn/tXulnjbaa0XfQva+x+hxQblZDNaJeFs
         EUW7Wzs8YobTtm5oYWk3CBshnVywrQNJtHCMg/IfJHS6oyTJ5/WR9fl5O5d5htEYKLV0
         PN7mV5Yq/I4H1IQA2n8dXpUKt8tHzrZZ51DXKdsj0u+3RG4q9j2vfY70DIZp7CbQdqWX
         /VAazRM89AOrZHzUzxD/dFhBdR+Z2p5lYz4/aWBhcdPq1+7H2yw58F82iWewiXHim6rP
         KY7FnqhprZL2KT/iHSe3ecxItZ2CNRvLNmnPK+SgJGsFgQDUuP0S7Ir4sWqXz7Y9Jqkb
         XONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09ANKvrtXuGXu1v8xNA6s7Eeg28zKsj4U4YnsPfEQ0o=;
        b=Rc9kYw4NQgKJPLKNSZk5Sg5stNTOSarp4OEfwES0kmxUxrmJooM3rZa8xEbtnQWPQt
         dyP67USfu/OznybjAXo7R8+mfVH5QFiEIeYOUOBUA8AwocKye4BmRnfP57C1JewamD0e
         sdfG+7lgIh+9sCU+vQt5GIiFJhUt/NyA7cQN8otvpcjoVAUZhyrgB0gpSC3x9MfueOtu
         NuMP+x+84a4GVwztps2DSPjwaFxW0JaH2rJpNaSOcow09N82iE1A4WTcHdKZDgY74CZl
         Wrsj501YfXDlD0yK5xS6n+Y/NUYedIvwk8WYw1+GF8v3lQsXwSmPkQHF2WOF4xmQLcb+
         XZrQ==
X-Gm-Message-State: AOAM531EmOojX/FAJFMvdCysHt6jaguIS7b4KkvObRck/nqPBLdPvAb7
        j6MpLF12jJCbqiw98GwXLY4=
X-Google-Smtp-Source: ABdhPJxaeDo0NB/af7SuYynmVjCmrc/s2XGXbqdalA4yDuLrVkZvppdK7lJapffjph2nbIOlLfROuQ==
X-Received: by 2002:a17:906:8255:: with SMTP id f21mr391698ejx.265.1610387021651;
        Mon, 11 Jan 2021 09:43:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Mon, 11 Jan 2021 19:43:13 +0200
Message-Id: <20210111174316.3515736-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a leftover of commit 69df578c5f4b ("net: mscc: ocelot: eliminate
confusion between CPU and NPI port") which renamed that function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 291d39d49c4e..519335676c24 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -122,10 +122,6 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
 
-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
-			 enum ocelot_tag_prefix injection,
-			 enum ocelot_tag_prefix extraction);
-
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
-- 
2.25.1

