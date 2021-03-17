Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8633EDDD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhCQKAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhCQKAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:00:31 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1242AC06174A;
        Wed, 17 Mar 2021 03:00:21 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b130so38212734qkc.10;
        Wed, 17 Mar 2021 03:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZAsbQNS29RWdCC9XL0/Dl6r/Tgfzn0XQQUMR2GsJUFY=;
        b=dU/zOewyXirtBUuLJ0DlIrl8p8JEQ/Hx15XiYfgkp8T6fBUbobwsEs5dYICZ0y/rcs
         xzCvpIoIacrDm6HvB54W2fHEtZT//7cmltieg3sC1In6YmDtoUm74pbRTwLZIEbnRjow
         jiLYmWGlu3mw97WnWe067xCeXx2UAdrxMZKaxE/Pr8ZR5kQKJ01HnQB3W3BlgT9+pH39
         jTbpRu8j4b0rMmQxEu0tDdqNZjO1/cnzCoy60Kg2Ss2/cwCnYBZ1lJriQC75sTRGrU8T
         CxaIqUYCA+EcSqI71OWlx19kMSSXoN8xnCtuPG2OK/JiWqm23hKbZDBv0WhL0BSb82zO
         P2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZAsbQNS29RWdCC9XL0/Dl6r/Tgfzn0XQQUMR2GsJUFY=;
        b=exE3LzWRpPa3JZJ2DrqfepMz5snIF8GNdJWP/vl6ZiCQDAnx7uKbntWdwS2z5Fun0t
         DrRIAmEW91dFANb0jKxgE/kr1hvlfKAHS+p4VtNcuTvQzKDV0Hpfae5kswCE9n6HN+og
         yaf/REp+ddab0W3qoLYDnyrKaNlxbLt3NKUMCKQxjRX/wRfIV5NVb+9V7hD65ubbbk/W
         OG9VCub8DGQ+2P7y5JeNoUo1q2SPLnbSBGP9V2c0wcd1BjOqcBZOtPxV2/O+X+c2aunf
         GIQWSm83Q+hdKb1rlth1MyVfAg5zkX04x6bhfkGaG5FVUzxhoUqF0enfpX4UYKcSiI/2
         Zq4g==
X-Gm-Message-State: AOAM530GaHXwkaPYejj4KFz/MZ2ZghUB0z6iKkAc51j9lP+5CvF+dunG
        XPlfNNprz5EPZNlphdkskvVdp4oDpyZTCpVw
X-Google-Smtp-Source: ABdhPJzQwKfIs+XgGLc0O+S/sc0kIbyhsPuBqFAUjCWQwH6YWZf5V0ru07v5NU5r0IxELMlerP6FUg==
X-Received: by 2002:a37:96c4:: with SMTP id y187mr3986614qkd.231.1615975220384;
        Wed, 17 Mar 2021 03:00:20 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.48])
        by smtp.gmail.com with ESMTPSA id v137sm5161436qkb.109.2021.03.17.03.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:00:19 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c
Date:   Wed, 17 Mar 2021 15:30:01 +0530
Message-Id: <20210317100001.2172893-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/Reprogam/Reprogram/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index c00332d2e02a..72e6ebffea33 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -361,7 +361,7 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 	}

 #ifdef IXGBE_FCOE
-	/* Reprogam FCoE hardware offloads when the traffic class
+	/* Reprogram FCoE hardware offloads when the traffic class
 	 * FCoE is using changes. This happens if the APP info
 	 * changes or the up2tc mapping is updated.
 	 */
--
2.30.2

