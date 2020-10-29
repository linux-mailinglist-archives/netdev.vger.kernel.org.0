Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7209729E802
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgJ2J60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgJ2J6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:58:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2D9C0613D5;
        Thu, 29 Oct 2020 02:58:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z24so1918669pgk.3;
        Thu, 29 Oct 2020 02:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOpZkXoCG56ttvootXx2Du0q4G+Dw2s2HQILRuJryPQ=;
        b=W0XdM6abeQJafX3wPoDnTOdAI6IxN7rbSdEi3J6/0KaDeFR4yzh0gYk/aM7idgbPSS
         lqbhE+8meKUg5DHatEjcfmhJaUUos5gQ3usVnfEP6ZhzDSRSgl3JQmIFdQ7InS6CUpFQ
         3TSC08m4lNjgZIbMJP6Z1NKnfOl+GOSWUV8BXvHsKR4sf8njJPzC3DYtkuyTHF9kGxCt
         N28DaPJVlmM+em42eqbIV7Nhq9jBa7sYtrNZI8avfHn243QYOsKJbg64PSTY/zB/IOIm
         pQmuPwZSaXtUQHP5YFUF2HcPA032JsF/C9KYiFGAYyeqgs1HHTYhGUR8glCbwlib5VUL
         96DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOpZkXoCG56ttvootXx2Du0q4G+Dw2s2HQILRuJryPQ=;
        b=V/vX6KvAywBZoEEplua1smu4iHcYGMCqtNKElndyWlt20o3CDYhQDZSnY3pcePmWaN
         eFY/uDItqopqPc4pXgAOzbfKc1aH74TQTlurIs0F/K0A+yXREpqn6xxHK/ElRbAidNuP
         ReLkSbU0sUqpjqdNOvoVbZe6z7w7NkUAIC6b+90O8o3HydX0tYG4g9oYWPgJL6JDOt0X
         fQRLBW+ykABrQkm8yjSBw8kCJwcXYsy/Wq7WdIKwg2DYS6XPbE2k0qoFbibKH+7lrU4d
         mS8c+AA5xfycuEPSOUixPte3kU8QHl0Tt05Zr2G3YFvHXhWF7AEEIcvFu7HK8/npavNN
         uBBA==
X-Gm-Message-State: AOAM530rtPQK42+mKDXXYuy3UAWYj7nRUX1YRxbKlIrpUXCSWgyvLEYa
        uxvjj0l8DKaYJWCVmm0At1c=
X-Google-Smtp-Source: ABdhPJyvUiKjZgDWos0por6Ddaq749z3S6hP6PYbxZ5HRECZ3DmpzOnJvGQlqEWVsGG1kOQsvqQJ3Q==
X-Received: by 2002:a05:6a00:7cb:b029:152:94b3:b2ee with SMTP id n11-20020a056a0007cbb029015294b3b2eemr3599158pfu.58.1603965498257;
        Thu, 29 Oct 2020 02:58:18 -0700 (PDT)
Received: from localhost.localdomain (sau-465d4-or.servercontrol.com.au. [43.250.207.1])
        by smtp.gmail.com with ESMTPSA id t20sm2394747pfe.123.2020.10.29.02.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 02:58:17 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com
Cc:     gregkh@linuxfoundation.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: net: phy: Fix spelling in comment defalut to default
Date:   Thu, 29 Oct 2020 15:25:25 +0530
Message-Id: <20201029095525.20200-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed spelling in comment like below:

s/defalut/default/p

This is in linux-next.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..77540f5d2622 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -696,7 +696,7 @@ static void marvell_config_led(struct phy_device *phydev)

 static int marvell_config_init(struct phy_device *phydev)
 {
-	/* Set defalut LED */
+	/* Set default LED */
 	marvell_config_led(phydev);

 	/* Set registers from marvell,reg-init DT property */
--
2.26.2

