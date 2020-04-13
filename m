Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872891A6B63
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbgDMRdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732821AbgDMRda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:33:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2725AC0A3BE2
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ng8so4125361pjb.2
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GkeOUvir9RrtjilaEF2A+QBm23S09t4qVEt8kMgOjMM=;
        b=XoQYcybgR0IZA9P20hYwGBEd7yx9+U0H8wKZSjQw9lbGTb/L/IZ48G5KMBOmpq1Tet
         xIFzBXR/3ITlbE1q7PK9frkNXUw+2oj+IGv4M9xl5qSgBkFBPDpcgKjOvdrvi74SbC3B
         cmLVFXhk0p+idl11zdkKkD0WT1gs1PNaBlUuWCYONIMw65NajDeXdz5V2iYqEocpDc4n
         Oy4j8ao21pIHRIlC1aZO+l3sCS5rga+q/FBOlTqXsYOxOaS6B/y8+voYDxsAG3scJoNr
         A/h3t5b2H/o23e2tgh8G71i8LqxhPdbtf6iVD8gvCbHM7b1kCE/AHJyjiw+jAP6Szz/z
         D8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GkeOUvir9RrtjilaEF2A+QBm23S09t4qVEt8kMgOjMM=;
        b=KZwIt+afk6CbzQQ4Y9pjYaNLxKMVFJMO008VVOqrlAzAPukhSe/DxbfoKlE2xL0TSZ
         fOzD+Hw/wzMRcQDGq8I0PSwEMsCZa2EV4GgIuvAN0XePMiS24eC7D3A0AlO6CILgG7O2
         HJwkc07dIk39+qq0J9iUsz0vyoM42U8jblcFCJSYzZZV+QsmA8ylfLat2x75q+SB/uS2
         MrGsswFbmES0Kx0zGOZtyRqWj4iCM60ku1YTtXKCDRMW6xxrcsoOBG9iFvAvWdkxDNCK
         wLK+k9+TSem8yTLp5L2SniCtt60c51PoWPigy0kMuRHEek9CxAhsoNM2mkbnOg3hqU36
         9D5A==
X-Gm-Message-State: AGi0PuYPYUfF8C2qZ6XeI0w1FynWFUhHUXyEMTERoXUblFMxTdsHfhe5
        DpFYzQh3HCaROGz5ta6laEio2mhgAqw=
X-Google-Smtp-Source: APiQypLdRY6UccyEBrEWZnvrBgCxGqFK4UDQ1nv/61lH9t/mS+WvEeHYuQZvkAQFFzQVTAdOJXhSrA==
X-Received: by 2002:a17:90a:7302:: with SMTP id m2mr22503864pjk.7.1586799209745;
        Mon, 13 Apr 2020 10:33:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y71sm9234409pfb.179.2020.04.13.10.33.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 10:33:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/2] ionic: fix unused assignment
Date:   Mon, 13 Apr 2020 10:33:11 -0700
Message-Id: <20200413173311.66947-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413173311.66947-1-snelson@pensando.io>
References: <20200413173311.66947-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove an unused initialized value.

Fixes: 7e4d47596b68 ("ionic: replay filters after fw upgrade")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 27b7eca19784..80eeb7696e01 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -26,7 +26,7 @@ void ionic_rx_filter_replay(struct ionic_lif *lif)
 	struct hlist_head *head;
 	struct hlist_node *tmp;
 	unsigned int i;
-	int err = 0;
+	int err;
 
 	ac = &ctx.cmd.rx_filter_add;
 
-- 
2.17.1

