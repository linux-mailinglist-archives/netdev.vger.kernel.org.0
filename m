Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A25046FE0E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhLJJqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhLJJqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:46:53 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA544C061746;
        Fri, 10 Dec 2021 01:43:18 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so7564721pgc.12;
        Fri, 10 Dec 2021 01:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJHQS1TqoraBa2z6TQURFb9DY2t95GlT4haKiZfPPeY=;
        b=ch0H4egbYgiAUhf4tE3p+bnEWPZckrmnopkwgPK/R1Ppht09xz+pjYNB68b+majQsV
         LczzRRKB0MIB+u1trZ5eTzYRARzvHRiBYfhVEkpHxAsCFtA+dbZfjEjzQ5jX2xDW+cL6
         x6YZnZhxaQ/ct4B5pq9ZVLMiGgBAeMgaoLv9CbCXm9eUr/3EGznqwlMWD30EfmjDMEDz
         DP5T0PUYG+d3l40c38rhaI3ftPGjSOH0EGT9m/sniciRTtOzYsdxLxEaqwIsvXHxTHTZ
         qqWA8FrSE5E+SshOkIaUDR8I+zjcJmvdlb5EXYedvVJ2Yb5Zlmj2//H/4DGF8uNWRsKr
         MgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJHQS1TqoraBa2z6TQURFb9DY2t95GlT4haKiZfPPeY=;
        b=c0Ebclc+JR1y6nc4i04EXbwS0MWMPfpAJ9xvWI2rlO3100wDZugUKwF5g5kAPNQwPQ
         xydS8g1aIjVXOH83oaoTsWNALon/IJwbN05uIz9iFpFONpXMbHTtsFpjKx3mXBIbqH9x
         nzGFvgV6JQZScYPw+9W0clFZdvmDysKf+SABevMjryLtfelUeoxMIzdMJOXuSKZlm08o
         XwAkCdJGVy85xUAi9UiiIfQPO0U3sR+sE9uPdwJsPcFFPcFEOZlds2Cu4934aJCakSUQ
         BXEhrS30Ce5dleq1KilUwi37IDfe62ERyGU6oa83SEjIcq8n7UfNZGMZZHnQpuHGMtwO
         QVXA==
X-Gm-Message-State: AOAM531cddFJK0d/7onfmq4U8t/ds1pSuEGFM211eSmv/+hUxW+nrs2/
        Zsfnwrp8Ibm4pjqUeiaaBmA=
X-Google-Smtp-Source: ABdhPJzrmcGyhdYsXEmPxvU+k6FeIrzvowGq8KGqA/CRsPd/8BiDmLGE0v1UNgmbjCNF6hU8F/EmKQ==
X-Received: by 2002:a05:6a00:1392:b0:4ad:5688:3e7d with SMTP id t18-20020a056a00139200b004ad56883e7dmr17154037pfg.59.1639129398410;
        Fri, 10 Dec 2021 01:43:18 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s28sm2881638pfg.147.2021.12.10.01.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:43:18 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sven@narfation.org
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCHv2] net/batman-adv:remove unneeded variable
Date:   Fri, 10 Dec 2021 09:42:06 +0000
Message-Id: <20211210094206.426283-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2844186.8fJna1iEf4@ripper>
References: <2844186.8fJna1iEf4@ripper>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return status directly from function called.
change since v1: zealci@zte.com.cm
             v2: zealci@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 net/batman-adv/network-coding.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 0a7f1d36a6a8..0c300476d335 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -58,13 +58,9 @@ static int batadv_nc_recv_coded_packet(struct sk_buff *skb,
  */
 int __init batadv_nc_init(void)
 {
-	int ret;
-
 	/* Register our packet type */
-	ret = batadv_recv_handler_register(BATADV_CODED,
+	return batadv_recv_handler_register(BATADV_CODED,
 					   batadv_nc_recv_coded_packet);
-
-	return ret;
 }
 
 /**
-- 
2.25.1

