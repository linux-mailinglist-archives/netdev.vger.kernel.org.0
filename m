Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9431C6E4
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBPHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBPHgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 02:36:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78679C061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 23:35:31 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id kr16so512416pjb.2
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 23:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PVc49FGSrcyBjDKMhqpxS/wGvi7aqxUUyL9/qdpEOk=;
        b=HCZ9QWz8vWNEnAal12QAAtgNmdAsKkUWhD6QPhvYOFUY25NifHAX1ooDuTb5NLKW0T
         S1Dd81Wiy2HEwIgBY7O0IJinfyBCYyJW0pw3vffTeClR3CWAmRd7Me4U5XK6SywXIOix
         PazRTcu9cBJo/rPFjbI/ubYOWSqGeKiSudA1TSN4oaAUEvhUfcx3BhfsUJrtgRPjmln/
         mMu3VDkc89guwJyHhZxAU3GHalwFyFbBFKoPD+0wBX47h4chWJr97LVJsnJaurYccioc
         Iyt03UzI/FSih4hIR2Xe/YzuXpLiO3MK/a+MaOLRNwU0SD+DprEz1fB4kKKPSkpQFPBT
         hvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PVc49FGSrcyBjDKMhqpxS/wGvi7aqxUUyL9/qdpEOk=;
        b=hIrl+56GMBZ5eFc7alChZonhtJ+pWvwOR7ugP9Ww8ezAmBbcNSZl5YHT54CYDAaPFK
         S3tTfKU8AlfaOwKWoMlcf2dB1NPzJxJBWc6u0Ja6jY5wjODBWbYSkklNivHLM21HbL4K
         C0RKSZQF5wRHkoZUT+htihdT95ug7+Rw4cvvu1vWqvltwawgisDuZ++IHh9QoXjp5mZu
         ny2ub1pfMHjNVHauV6J/E7St+yVvD6mZ1sD40UhPuncb5RvvaCn/ihDo3tZyxrxuWEsB
         I9kEeAiLg1ogmxjgPEyrIf/txTiu1C//10HFhL5//JPKSJ5O2nQR+B4+90ob6YGo6Jv7
         CNBg==
X-Gm-Message-State: AOAM533HvbnZcjKr94CNwKQoKiUyCMfHQMQ87twMKL7TwQW/YdCKqxDs
        2ARFE2gOAxbvRb1solBqT+4=
X-Google-Smtp-Source: ABdhPJy0y5SY+d4KqNVoa1LEvO79zB5Lb3njyijHnLg3HUVd7yjCV3UUBvYtw/MAb5aW5g7/MucgzA==
X-Received: by 2002:a17:902:b189:b029:dc:4102:4edf with SMTP id s9-20020a170902b189b02900dc41024edfmr18607463plr.80.1613460931113;
        Mon, 15 Feb 2021 23:35:31 -0800 (PST)
Received: from ThinkCentre-M83.c.infrastructure-904.internal ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id x20sm19817365pfi.115.2021.02.15.23.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 23:35:30 -0800 (PST)
From:   Du Cheng <ducheng2@gmail.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Du Cheng <ducheng2@gmail.com>
Subject: [PATCH v2] fix coding style in driver/staging/qlge/qlge_main.c
Date:   Tue, 16 Feb 2021 15:35:26 +0800
Message-Id: <20210216073526.175212-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

align * in block comments on each line

Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..2682a0e474bd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
 
 	qlge_tx_ring_clean(qdev);
 
-	/* Call netif_napi_del() from common point.
-	*/
+	/* Call netif_napi_del() from common point. */
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
-- 
2.27.0

