Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B1A668D60
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjAMGZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbjAMGYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:24:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469BF5BA26;
        Thu, 12 Jan 2023 22:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pE5vHsweVi9sw+XFtbQOjd8ZmlFDvTP0hqXRxtOPgdI=; b=UPm4fiFNqG828TmS+12Rola8gO
        eqHlHcKs17NiINhJVso8pQaJLXAawxXFCKuLlP7HRjKIjJN2ZXqL/cl3jIEux4plqaePmjKWoVYai
        QlJizCpTb7yVhQxL/QJWjJ37KmX8qVxA7Rot4hYXsbm50Ukgoehbb75E6d7ZbOqa0NS55yCF1vD12
        hTv+9XqO7HKABDyO220qXwurWxcmgcwBxl9/GRlKpDUCPyGWGMAz1KKVnajqZK+KC0juYlZ2W8UlT
        3xv/hB5gSMNo2fI0kJb/GNm6IFqQb0S3ZTYgJMi4xbRkGq5u2ysaI8Zc1eFL7BGimSK1gVFq75foe
        LEx3cuRw==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDTf-000lNa-NO; Fri, 13 Jan 2023 06:23:48 +0000
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
Subject: [PATCH 02/22] usb: remove the dead USB_OHCI_SH option
Date:   Fri, 13 Jan 2023 07:23:19 +0100
Message-Id: <20230113062339.1909087-3-hch@lst.de>
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

USB_OHCI_SH is a dummy option that never builds any code, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/host/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 8d799d23c476e1..ca5f657c092cf4 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -548,17 +548,6 @@ config USB_OHCI_HCD_SSB
 
 	  If unsure, say N.
 
-config USB_OHCI_SH
-	bool "OHCI support for SuperH USB controller (DEPRECATED)"
-	depends on SUPERH || COMPILE_TEST
-	select USB_OHCI_HCD_PLATFORM
-	help
-	  This option is deprecated now and the driver was removed, use
-	  USB_OHCI_HCD_PLATFORM instead.
-
-	  Enables support for the on-chip OHCI controller on the SuperH.
-	  If you use the PCI OHCI controller, this option is not necessary.
-
 config USB_OHCI_EXYNOS
 	tristate "OHCI support for Samsung S5P/Exynos SoC Series"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-- 
2.39.0

