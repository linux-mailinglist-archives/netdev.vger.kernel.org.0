Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1902DF9AF
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 09:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgLUH6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 02:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbgLUH6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 02:58:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B67DC0613D3;
        Sun, 20 Dec 2020 23:58:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w1so7463637pjc.0;
        Sun, 20 Dec 2020 23:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vuo/TbErUnOTi/BtCcE2qLWY5PtEW/w4cxfuLrmrRGI=;
        b=KA1e7AOhJeu3VEaVRv+7iGg3OH8WFzJeus82szeqLp9hHrgBIchmk5Nm6caQn8+l9G
         Kv8GGimfUO4fBjucCrQPQ55pKti32hbBn3rwJycHm50Yp9lB0Exo3VmPkBN3yPg3DrjS
         5TOyKcQluDnzcpDm/LT74e05ydbq6NEYXdNtWCT3GYZZ+WwPl0b8OLiF85++FbBie503
         nhdC8lBTRwAxty9dV3nD6VeiBfMJZS9CMdB9ZMi1qLUM3EFw194DWr4NlF7YKerZsFCB
         LP5JlTxUPiL0F46Dbpn1UMsmL+qLiRjCoEWiOSx03J1d0eS3bRAh7AjhIjrtMAqAJ3Ae
         2AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vuo/TbErUnOTi/BtCcE2qLWY5PtEW/w4cxfuLrmrRGI=;
        b=toEsVI3/V2TCKuFhyeus8+ALNFxpei97X8N7/mVolJ3Kc50k5C9ZPfmevzbZiiAtKQ
         HIHqKvj0bb25ImqUsBsn9JK9lFV/ep16mq2im6oQJ0XQVuA3zipxnsPMYYVs8VcQvyPm
         zoHfI63+0cdFO/tDcy4PQOB4sNi2HCZv5ylpehaUP0rBlcx1ye4EZocQsNhNceDzjlRK
         7iycqe4hfLk0e3zYXr2gguZKZnbNGkGWUCB3EYf86z5pkA9+3mrC3cSngrnyOh06Yem3
         Pddp2cyEoiNgQYejTc/xgbEdM4tSaS7pd3dFQsUOiKU+dSAMM2g2dZkQcunMJug/YPqP
         B1xA==
X-Gm-Message-State: AOAM531a5IM0tHxXer9VlCpVGFXlc1+DfzsCHu0A1ULk0oQjCIZyHplZ
        eFyjGJw52gZbrWYlY71CCOY=
X-Google-Smtp-Source: ABdhPJwJP2qXWVmVIYNVyefaLddDcIwYNgdOALxCjBSSMN53Ed/gxMKUE2QVCKA/8wgUwewEa7qIPg==
X-Received: by 2002:a17:902:8c84:b029:dc:20bc:2812 with SMTP id t4-20020a1709028c84b02900dc20bc2812mr15299578plo.66.1608537482959;
        Sun, 20 Dec 2020 23:58:02 -0800 (PST)
Received: from localhost.localdomain ([103.248.31.152])
        by smtp.googlemail.com with ESMTPSA id 145sm9979738pge.88.2020.12.20.23.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 23:58:02 -0800 (PST)
From:   Amey Narkhede <ameynarkhede03@gmail.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amey Narkhede <ameynarkhede03@gmail.com>
Subject: [PATCH] qtnfmac_pcie: Use module_pci_driver
Date:   Mon, 21 Dec 2020 13:27:35 +0530
Message-Id: <20201221075735.197255-1-ameynarkhede03@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use module_pci_driver for drivers whose init and exit functions
only register and unregister, respectively.

Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index 5337e67092ca..d9d06af9adc6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -480,18 +480,7 @@ static struct pci_driver qtnf_pcie_drv_data = {
 #endif
 };

-static int __init qtnf_pcie_register(void)
-{
-	return pci_register_driver(&qtnf_pcie_drv_data);
-}
-
-static void __exit qtnf_pcie_exit(void)
-{
-	pci_unregister_driver(&qtnf_pcie_drv_data);
-}
-
-module_init(qtnf_pcie_register);
-module_exit(qtnf_pcie_exit);
+module_pci_driver(qtnf_pcie_drv_data)

 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna PCIe bus driver for 802.11 wireless LAN.");
--
2.29.2
