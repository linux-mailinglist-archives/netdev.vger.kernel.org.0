Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA42ED59B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbhAGR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbhAGR27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF43C0612FC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c7so8509842edv.6
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgQjOMSXdVVW7Xq7cdGpe7cuI8mZgArgFHDD/RkSOwc=;
        b=kRW18qov1KFKm9wyWQFvFoAE3Kic+fuqJyHgzv6ldV2xr3OUH3SYpqv/ck0/pbjkEj
         GJMA1fzuX3uXgC5nhpHO/KXAcyIJFJHQUglO18zPyHMsWRL8Voo2QWvG0ZKoENb644RY
         dhV02NPIJt4MyLOYceTFQYPLFGi5ZFq8lJEHa4uzYwwb7pitnon5x9FoIM8T3o47DtK8
         BsooJv/DsIW67CnKAQ04p4j5oNyg/dIPZsnV7+k9iCxGRy9zQJZl/Q7CNe9h5scyriCN
         +De89mmdl4sVUOAqcNYuhDZvwSEg1dM0NA12sqbVHRNuuWecRGw+vzSGVVIf0bs+Am9i
         TyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgQjOMSXdVVW7Xq7cdGpe7cuI8mZgArgFHDD/RkSOwc=;
        b=Rtvj3Smf94dlWQCerFHPWjbi60krhXawVOE/gzLUtSLUXIKNlTOPIfndibEVVTiYPg
         mPoUrr7A1YBgc+5PohXOEO0+wbmP+6JzNvWmbywsJZAwSFLKDljUzPPKW0mb8yUq9BpZ
         TI6Ss/4GsQxWeNmvaFY3s4U48Zrqx+EuV1kTo8NpsoMAHxacbd2tn1w1lRluQooOiRr7
         y9mlv2OcbOhxZ5ltGYwBHt6rotorAjlQ1pI4nFyv4T0W8c5EjK0aKKZiCDFsr0tsngBg
         gP1dx+ehKn42kKCSzfO9bQzg2QJPhPM91KTJhHFCAFEyPdwcbOv9tg2NCz3E91d24Lk5
         PvGw==
X-Gm-Message-State: AOAM533BSMI0KMBhFFMVTIeqN0dw3C9MHLpS8M4uXy2bM3mlMCon3aeB
        te2qNhA5drtNYQG9o4v1lj9R2OcL9vw=
X-Google-Smtp-Source: ABdhPJwQJvAELz/4GSlKK0b5mi9EmqEppcHmgoNrG6C6Yszxw9cljgIjU/P5cT6wSblVimAqxu6+yQ==
X-Received: by 2002:aa7:d7d2:: with SMTP id e18mr2501099eds.256.1610040464594;
        Thu, 07 Jan 2021 09:27:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Thu,  7 Jan 2021 19:27:23 +0200
Message-Id: <20210107172726.2420292-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
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

