Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CEB2EF6E9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbhAHSDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAHSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:54 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BBFC06129D
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:41 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id d17so15632920ejy.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IL3rzUKtT91yJjvVm/PEpRIcsHQmJVk80kX3o/NtNeE=;
        b=EmLaT5NQkMuLIeITEtFD5lVY+cPevyBntlmnVoSNNMfqSnds299peNqisZyMbr6PjM
         xr8tq3j1y3emGZIpjnhopU3c35smSAjkvi6+89nrxThg1Bh1VcLNyg1PFVzSRnQiJyDc
         EGV9wg3USX9y0u93fQUzfDNcA3hifibPwG95burMK9qIpXblezkOUS5dH5ctCCyNntjX
         7OFCOaDXn6AlxxCtvMufyUx4fxOobZkgKkqvEuD0BJf1ALW90ntdnz6yLAgr/qj9UTOe
         5cmsWfuE1A9VUWak4BAKpKSUL0181OymBC7WLQCGW/NJrDtLtYirrhzZjU+LK7dKO5US
         cAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IL3rzUKtT91yJjvVm/PEpRIcsHQmJVk80kX3o/NtNeE=;
        b=rlAp+PfBAmTYNv2J0QPXCsh3fu21XDJRdTA8d42d29azLbYfKlbpQDcjhwuWyDQwHY
         h5FjqcCkIOsbswP0T36JokK1frJ70XZOGqfKV7IgditHH4Gfjkhq1ZVxwc8H364EmK3i
         M3h/5GiWU9YoWv2lK/RNSZ3VicwdIxiHd8SEE3/tpGnQBji60SfRzlUuQU1JD3vhkFIC
         0oyEPlEJuFNwNn7RjGlE/M/O2R2aySBMMO6/sajmnZVJ/b/jFiLZeSx7K7SRsw42Iitj
         LHBZXVmYc02wVeTricaZKNOQ5GHq/9SVwbDHxicho6JICEwYT/wXmPIWgldWQu1HtJLl
         tFzQ==
X-Gm-Message-State: AOAM532JyWktkX63XQcdINVQ7zjXVjnLxT3vymPzfoHM7/OWkDePO2TK
        OnAarXHVGhs/2Mmn2q+8zJPRtNxfVsk=
X-Google-Smtp-Source: ABdhPJwhtVA4FzakzTtG1z4t4d0IXkRZtULQrLgHZDZuc6chlkuUImRb8HfqGApH1YEow3iOPCqu9A==
X-Received: by 2002:a17:906:ae55:: with SMTP id lf21mr3366908ejb.101.1610128960085;
        Fri, 08 Jan 2021 10:02:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Fri,  8 Jan 2021 19:59:47 +0200
Message-Id: <20210108175950.484854-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a leftover of commit 69df578c5f4b ("net: mscc: ocelot: eliminate
confusion between CPU and NPI port") which renamed that function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

