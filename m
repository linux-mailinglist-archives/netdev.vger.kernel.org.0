Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E34DBB21
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347188AbiCPXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347439AbiCPXgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:36:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A922F1704A;
        Wed, 16 Mar 2022 16:34:58 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n35so589642wms.5;
        Wed, 16 Mar 2022 16:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czb5GwTUyEvC7IMUlG+JKwSJsAnO/p2dBLvaBSaNXLA=;
        b=iDCbQgbiZq+8IvrMnKeOeawaUdO3LsMT8jnftvaGuNAL3nPgvv/sDb1H42RWnm9+Yf
         Pe4eEMsnbekD+aResRO7lWDXu6jzx1v+MhrWU7L/hReR5k9oCAAzFsW5q/zkGbIrGB9Z
         ECGrTJNjHQ2SmVgMqzfGB4w3XdtiqBKUNmsCtomjbgziW4QQR2jJ/DM4NFS2Ohaho00S
         GjvcakwYQhBUfzG53IDkfvp+VLsoTi6LqFqVsScAbGltu71EAG18EgmJotR3VQSLwks6
         RlpSvz8GsVTQiw3bx3BzK0sxcYnt+Qj5SkI2MyogbWZE9589jvByY4FZ3r/35g2FBaxP
         WcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czb5GwTUyEvC7IMUlG+JKwSJsAnO/p2dBLvaBSaNXLA=;
        b=BpsKWvnXyypR3ZDNSXHkXqIaJ6VpNqegElZbi23cL6cliSxEdi1PM9AHRHuW1G0t6g
         UuemwSpSHvK+f4e3lcqZkdD3IcY4vXx+YjSd5ezF3lCactFRY7QgA6kwumMW+J+iJHLd
         Y5FE8/epxILLiifwV8pgv7Sl35M9oCE0IgB2BW9A7tDGaFlJnzkcMFBBh9fJlP57rdfC
         hWj9TcN1dcOsIycXwFAW4UsUVBXIIBvjUKGB9HZLCUxBIB1pNPFem6FAsaWfbpaeR53f
         4REN4ksL1wMk2/KU1hbUXgEdIwwjMxVKfx9cVgDDUBjSx7VC2ppvbKEfh9eAeJrn768q
         7UkQ==
X-Gm-Message-State: AOAM533w7hPVxKW/9YoV8IdaqQxfevwSFlVpgMURunR5ip7wwJa7I8kX
        sw2GjRaBN70LZfDTq3TKLMs=
X-Google-Smtp-Source: ABdhPJwIIykESqrAfmSiWWHIlY7LWpsjskTeHu7aH4ceJjl9bAu/ldNrHkb70U7oiCcQUxylvgWSbw==
X-Received: by 2002:a05:600c:5009:b0:38b:3693:cf86 with SMTP id n9-20020a05600c500900b0038b3693cf86mr9220340wmr.95.1647473697063;
        Wed, 16 Mar 2022 16:34:57 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id q16-20020a056000137000b001f046a21afcsm2826471wrz.15.2022.03.16.16.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:34:56 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@intel.com>
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: ethernet: ti: Fix spelling mistake and clean up message
Date:   Wed, 16 Mar 2022 23:34:55 +0000
Message-Id: <20220316233455.54541-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message and the MAX_SKB_FRAGS
value does not need to be printed between parentheses. Fix this.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b818e4579f6f..16507bff652a 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2082,7 +2082,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	netcp->tx_pool_region_id = temp[1];
 
 	if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
-		dev_err(dev, "tx-pool size too small, must be atleast(%ld)\n",
+		dev_err(dev, "tx-pool size too small, must be at least %ld\n",
 			MAX_SKB_FRAGS);
 		ret = -ENODEV;
 		goto quit;
-- 
2.35.1

