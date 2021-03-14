Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D233A56C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCNPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbhCNPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:24:07 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1638CC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:24:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e18so4434467wrt.6
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4S7+SiGWtGQqfPkY5vburN0PvRl86MZhD0BJtcpjBH8=;
        b=UJ+/rgcypjq90K9kXQIkNOt19PftEns49VOczDFEH15QE+DfQBB7FTxTq/qCaPP9i3
         RkotyT1GJcNlEcreLR6jSN18xrt9ddl1CZQW/Bp1xZN7YOWriQ6RO6Yqt84Ba2P5mUQK
         UjnUe3iAu6dqGXqs3RfQmeJTAlKBs3BrtsBw03GSN3u2Afb1srBKwcoRyChgjycybxle
         Da9T6Qqo/AUp5Giu38eyn03zE8R8vdZp7epFHwbxsSf5H5FqJOzGV41PlVfXIH3wX/Hd
         AcIgYklgmn1A8DWcogiGCxrnOVTaG05RIk/nzUDjnHxKiS2dZ8MWsbrf+iHWri2k1auz
         ilJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4S7+SiGWtGQqfPkY5vburN0PvRl86MZhD0BJtcpjBH8=;
        b=sKuh0bk1EJbS5Ys0uf9xPKo2bDHgqPdM4BRD6xL7snAszawjIOjhna9E5+5jS9P1G7
         hfaHO/WzzyaXg8R+QQRsjRwE9fSGDYPZNHuZZSGdtZe3tWhQXWGW+zAnAs2eFgOyLQcd
         vzD6so+RThnr3ESroCYW6b3fKuGP+ZGP+eugWe2aUZmv7N9bPcrxNOUtuTYg5uj70Wgc
         SiG0C8kyCZsSZukiE5A4G50HS56OWi6Zrwq3QcK0kUOBIxQeRJLrhrcYR3G6PyUPIOtn
         NLT91iwKWGg8027drAlhFOthnpt9+Srx4bOL6pJihnZF2XaNOi9uhKmIB3lpd72PAIZr
         Urpw==
X-Gm-Message-State: AOAM532iz+Dc52FTVGP9HNi2a6tq3QbuJ2D7N1iAR6OyOk6R8R60Sm5t
        jDC+mgzlQQGuAVhym2K0QtxcSCJs8Q==
X-Google-Smtp-Source: ABdhPJxWf3eibCTIvJthqR4hAWwG9KfV+dH2RiIywBgFt/MS/Dxt21OXZamg4nxgw00WQ0fE1YN2Rg==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr23178670wrd.424.1615735444177;
        Sun, 14 Mar 2021 08:24:04 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.83])
        by smtp.gmail.com with ESMTPSA id a17sm9689961wmj.9.2021.03.14.08.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 08:24:03 -0700 (PDT)
Date:   Sun, 14 Mar 2021 18:24:02 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] atm: delete include/linux/atm_suni.h
Message-ID: <YE4qksYA1qvYnsap@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file has been effectively empty since 2.3.99-pre3 !

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/atm/fore200e.c   |    1 -
 drivers/atm/suni.c       |    1 -
 include/linux/atm_suni.h |   12 ------------
 3 files changed, 14 deletions(-)

--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/atmdev.h>
 #include <linux/sonet.h>
-#include <linux/atm_suni.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -21,7 +21,6 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/capability.h>
-#include <linux/atm_suni.h>
 #include <linux/slab.h>
 #include <asm/param.h>
 #include <linux/uaccess.h>
deleted file mode 100644
--- a/include/linux/atm_suni.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* atm_suni.h - Driver-specific declarations of the SUNI driver (for use by
-		driver-specific utilities) */
-
-/* Written 1998,2000 by Werner Almesberger, EPFL ICA */
-
-
-#ifndef LINUX_ATM_SUNI_H
-#define LINUX_ATM_SUNI_H
-
-/* everything obsoleted */
-
-#endif
