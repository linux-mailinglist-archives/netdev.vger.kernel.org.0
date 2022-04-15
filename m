Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC268502F12
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348748AbiDOTLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiDOTLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9B6DB2E1;
        Fri, 15 Apr 2022 12:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 371B061BB8;
        Fri, 15 Apr 2022 19:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7C9C385A4;
        Fri, 15 Apr 2022 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049716;
        bh=o4MX8UK2Ayi2FU0PSYzgH1W7goqrO0bs8RfgMd3gAVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cweHab1Gdg6zDAzegVfOlAcwLW0ZwyDacOnsclAJlJquxFoXV6FmDWc3aQd5lF7UK
         BCj2JeCoOaAm0MV5HhGtowfZX5F/tpn4QARtoxmMlDxgFzQr3KWzQOHH9Zv6W34+Ez
         uNkS2GjiA9M5zDb41OTuhdLm6hl1safKJ+7xyYZyNWUPI8UwsntYxXmlul+LZVXL5/
         6TLKtRMfgV0r8kxWTabiWAdVZHYscdPBqfySCuuha7mxFzQ9t60jFezg3F9f+tqhsV
         mFqTtjcCEbIr4trxsLK8ztpzsoa9De11Z2III0lnWhLbz2LgR9UQpK60LlFOKjysH2
         SxpHeGecr7ioA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Chas Williams <3chas3@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/7] net: remove comments that mention obsolete __SLOW_DOWN_IO
Date:   Fri, 15 Apr 2022 14:08:13 -0500
Message-Id: <20220415190817.842864-4-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415190817.842864-1-helgaas@kernel.org>
References: <20220415190817.842864-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/atm/nicstarmac.c                     | 5 -----
 drivers/net/ethernet/dec/tulip/winbond-840.c | 2 --
 drivers/net/ethernet/natsemi/natsemi.c       | 2 --
 3 files changed, 9 deletions(-)

diff --git a/drivers/atm/nicstarmac.c b/drivers/atm/nicstarmac.c
index e0dda9062e6b..791f69a07ddf 100644
--- a/drivers/atm/nicstarmac.c
+++ b/drivers/atm/nicstarmac.c
@@ -14,11 +14,6 @@ typedef void __iomem *virt_addr_t;
 
 #define CYCLE_DELAY 5
 
-/*
-   This was the original definition
-#define osp_MicroDelay(microsec) \
-    do { int _i = 4*microsec; while (--_i > 0) { __SLOW_DOWN_IO; }} while (0)
-*/
 #define osp_MicroDelay(microsec) {unsigned long useconds = (microsec); \
                                   udelay((useconds));}
 /*
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 86b1d23eba83..1db19463fd46 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -474,8 +474,6 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
    No extra delay is needed with 33Mhz PCI, but future 66Mhz access may need
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
-   The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   deprecated.
 */
 #define eeprom_delay(ee_addr)	ioread32(ee_addr)
 
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 82a22711ce45..50bca486a244 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -989,8 +989,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
    No extra delay is needed with 33Mhz PCI, but future 66Mhz access may need
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
-   The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   deprecated.
 */
 #define eeprom_delay(ee_addr)	readl(ee_addr)
 
-- 
2.25.1

