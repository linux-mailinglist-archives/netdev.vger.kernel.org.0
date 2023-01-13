Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B541C668DCD
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbjAMGaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240857AbjAMG1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:27:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4926B19F;
        Thu, 12 Jan 2023 22:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=V1vQGE3XW96qQp3ejFsm70w3mnOS9+pWBLCZirkv1tk=; b=2+SiOyCvTzvDZZCeuwWrAYwhzj
        EWAQESOIDtQymDuYM0T7JpVes3xvB7NFWQ+KmJV1uAOpOiRJUBjTMIMZUpzF2ix6MOt0hGo62CWng
        diwLKN81u+WjRqFmLkwMZ873sIws+XMLCIUxrN4I7r+ZaeFve8swojZ2Nb8EGuKmlXeIEB1nRyph2
        AGmxrxbCZm5edKIVp4yRI47qeIEa85kNn0gl7iBuYuEaOtP2HtGe1Lkv6xia/XchQLm3DtxOaVah4
        5sBY0LpYQziGvInjmbVYYVxDsXL3Jm0yMz0PJd+Su5dRSgTKQwyncOI0wCWZmAu3ILcI2jS/gxiK0
        qG4NqsbA==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUo-000m9z-Df; Fri, 13 Jan 2023 06:24:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 22/22] drivers: platform: remove early_platform_cleanup
Date:   Fri, 13 Jan 2023 07:23:39 +0100
Message-Id: <20230113062339.1909087-23-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This weak stub was only overriden by the now remove sh architecture.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/platform.c         | 4 ----
 include/linux/platform_device.h | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 968f3d71eeab2e..eb3feabf6c2f53 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1506,14 +1506,10 @@ struct device *platform_find_device_by_driver(struct device *start,
 }
 EXPORT_SYMBOL_GPL(platform_find_device_by_driver);
 
-void __weak __init early_platform_cleanup(void) { }
-
 int __init platform_bus_init(void)
 {
 	int error;
 
-	early_platform_cleanup();
-
 	error = device_register(&platform_bus);
 	if (error) {
 		put_device(&platform_bus);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 894939a74dd20f..86692f730e3a12 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -352,7 +352,4 @@ extern int platform_pm_restore(struct device *dev);
 #define USE_PLATFORM_PM_SLEEP_OPS
 #endif
 
-/* For now only SuperH uses it */
-void early_platform_cleanup(void);
-
 #endif /* _PLATFORM_DEVICE_H_ */
-- 
2.39.0

