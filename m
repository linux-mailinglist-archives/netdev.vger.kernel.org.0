Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB392F706A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbhAOCNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbhAOCNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:13:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF88C061786
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id by27so7873470edb.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TjkHuAiFYqsFIICWOSNAAOvSaisW4vEE5hJr5o9KitM=;
        b=B1CbS0QbwtcN8Z/d8eUhpFZj21X7iU5hZq9JMb8GKlceelh5YWgJu0FfIXKyYQ1+0v
         NaLKu+jno9NSmJgOuhMQbDsxRpjUTi9pSb7H3DYA+g8h1dIdfzD8+RUawRAg9ysC4ZAj
         luo3jyoaKIHr4BpVNDkYKsOXHgUsJ1KboXCEXSwIqlY0VVbJv+Yk/xAM46DcLBHMbkGZ
         oknWsf1Irfe1kWMwjj8LbmGn6hFrzNDQI05f0RdjZNICQMlwoiUkgr3UKfVLOi25Jdrd
         LTVqzug+sRD9Fa3wY972gTAPcUnXViawK+2Zc8sWBi7fL/QFteBgB6u7XPBOBdkZ0lr/
         m8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TjkHuAiFYqsFIICWOSNAAOvSaisW4vEE5hJr5o9KitM=;
        b=az2rvWM2bANK0lAWS4U4K21YtptX7r/HRm4+rHakz51G/5ty8fIf0zZ/eTFRFgyy91
         vRDBkeKpdlDqEOvZ10Yh6mbthuCemN7Fjp4qedNxSVIOTMZyHjhWCrvqnfMJrLPWH8Ye
         9FOXSr2T7aa4yexKiZb1nlDAmfNJBuQ2q9drF1hbeQ+mrEcy2XxVX+IX92JnlOaW3Xuh
         i1pZxQy7MyiaGjO49qqbYgwQIy4XIgyR5jfORop+hDQ9xgSwKhl9E1P3hv+xe+rwgOBE
         Y1spsPlGaVuUFHySSFUgtD7QEb8CNkBXb88CIaNpcdLUr5hdvOAfPjIhgmbYClBvsynU
         SCew==
X-Gm-Message-State: AOAM532zfd2mqh79UoaRx5Q1zBQ28lcB56Kf6k4ztN/v3ymxPNGU9yRb
        g03BwXwma46QSgOMFxTxMhY=
X-Google-Smtp-Source: ABdhPJyJMksKr6gTDzVn1NoIQ7/VUYxJGWZFC6uTOi2yL6YpJLWzEmC+pk5RO6Nbo2Xm9jSeYGCnkg==
X-Received: by 2002:a05:6402:158:: with SMTP id s24mr8097695edu.19.1610676715125;
        Thu, 14 Jan 2021 18:11:55 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Fri, 15 Jan 2021 04:11:17 +0200
Message-Id: <20210115021120.3055988-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
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
Changes in v6:
None.

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

