Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4072F62E5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbhANORC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:17:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBEDC061793
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:51 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id by1so1988216ejc.0
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xfu2GRfS703YHJGDdEBQ58UKcJe6eg/gA+qWw22+GDg=;
        b=KxB/yTDKTsWCrcp7hLXV5mCVWrUX+7iUs+2aSClju6OG3RcVp5q6IkwGpFOmW5U/5W
         ZJPLBdvjWM1hXBqK+OTrpTJoha8jGrdoUNtLMUdS2cdyAT/jFQutzehPpwOFmrFdkQgu
         shcIPhlDqWdoyTL0Z9CSfBuVzdmdu+2o80i7FNkjikIg0auco5xxrHiVklKL3vj/vUka
         uqk4/B7YzI9eyo1rRphZIvEVK/+xqzmNGOunu01Aq48WCCgZV/XKP776WtmHxY8uzk7t
         zSUL3unrOG6ZBrmQOQywo6kpDw9bMxHop02HiWnO7ZvKu3jVh/l4/7fu9xriwjsFycbW
         ApcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfu2GRfS703YHJGDdEBQ58UKcJe6eg/gA+qWw22+GDg=;
        b=Qz47HYfQVyK6LS/WYOPYUt82C6PtG4wxScFYfQQpLfTju4t6A+rxuBZ6mBpHQREtHL
         nuAEp42xF4WpFna747aw0XXRf6NdyQ16pHz7Dq6cMDv70EQ8O6lTsReDsvS+Q7JGJM5i
         lf1aP4YXL8xoQ3KkKIuZpIv/KV7Gt6q8w+2hBMeRyaDzNJe20lc+F1RuHBTt9iTNh/dH
         s2seeJhSHNHQboetPTA36W1eSvps60DewgS8C9co9SVnF6GP7jxXM3VT6G376XJFwbhD
         hJQF6iQ9yDdhmmfokgUUMUlSghJT+NF4DXOsAMjnYd6g+qRStEDmnY9gWFjWN8q5R6C9
         aJ2A==
X-Gm-Message-State: AOAM5307/8MOnJ3RYBMNjJwaxNA0I9fz4Vui3r4txeXoSZBrRp3Yx4Ei
        wKLlgOiWEYA+j/33oZhtBPU=
X-Google-Smtp-Source: ABdhPJzWomPQMiNr+eN7pTOTGqKK8NVJPpA7yORNwo92NoI81Kp/vKV8ERuZxv7nI17iy5LEOrhlng==
X-Received: by 2002:a17:906:b106:: with SMTP id u6mr5229165ejy.313.1610633750469;
        Thu, 14 Jan 2021 06:15:50 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Thu, 14 Jan 2021 16:15:19 +0200
Message-Id: <20210114141522.2478059-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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
Changes in v5:
None.

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

