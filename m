Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B71E8192
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgE2PUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgE2PUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:20:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4619C08C5C8;
        Fri, 29 May 2020 08:20:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h21so2451630ejq.5;
        Fri, 29 May 2020 08:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVYCKAGvF2zTsy4pa1r1HjtMmqMe+cn8yc2WH9XSmb4=;
        b=Igxua0a+a1Kb4qw78JDhNic5PSP8sSE0lX7Y5trdTv+3Bmr46DjYTvce+tRri7vi+L
         H4uoIwiHTrKdH6DoKsx9HoG47++9Rkom3x1UxKJbwgp5tIKgw5kEvshz96TrBEooj3i0
         OOzcr3xhaHXtJo5/Nn0APJrR5HAUScvsuSNJQZESSm6xyYRcPrF7iobmvv5xuaGCmkI7
         BvaRbuj1X/xLl460GMkwaZ9Wl4OafsoVCpo4eh9hA45DlRk/uBU5U2C45jgxZYxvN2A9
         qpm4Zag/y3Q/S8pdtXV/x77XMFoZYhIhcdMDznymhy/85Bu+3Ea+50SEkftRCDugK7+M
         LWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVYCKAGvF2zTsy4pa1r1HjtMmqMe+cn8yc2WH9XSmb4=;
        b=aPb19hJRvbkf0nllABZ4RfvmiI2ONhtB0qZMnU3y7qXckWj4Gfj4VT7YcS1kb/DQwf
         p2aElhBiHOYKau+Rcj8xf2BEGmPl/wOVU5mX8hdj1FJ0B9sTMUqSEgk5OBic1xG44WVC
         21G0TBIy0rTZ7Bpe3lpmrosIfwsVo6AKIqVBr+/OtdN0XH+9Pnc+1DYJagz1L0uJbg8P
         WjWs7rvFXB2Diq7IAUtJV29Rwa+b+NVppMUjP5ItzpNogvCHMwMrdDUJb5mqKun7XM8m
         Ng5DRrRK2u6PQxrfHLvNg83909ZgYQBa8IsWUN85d2fh1XTcEvs0+bGrLRxBbIK1/8ER
         jvfw==
X-Gm-Message-State: AOAM532rZpERpuXz/paQYr5rjeEmYNM5HmYXLNooUfpGvLRfxPk2Jvs1
        pY2cyhv5izZfsmVg2URKWSo=
X-Google-Smtp-Source: ABdhPJyfekTkra9AGKoaZGVf6zPmnHzv28/iLRe4WAVlzAIlhtQjm/9kzf3A3bMjSzZpanyTz3WOEA==
X-Received: by 2002:a17:906:22cc:: with SMTP id q12mr8433182eja.485.1590765599584;
        Fri, 29 May 2020 08:19:59 -0700 (PDT)
Received: from ubuntu.localdomain (host-85-26-109-233.dynamic.voo.be. [85.26.109.233])
        by smtp.gmail.com with ESMTPSA id o18sm7419005eji.97.2020.05.29.08.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:58 -0700 (PDT)
From:   Jil Rouceau <jilrouceau@gmail.com>
To:     manishc@marvell.com
Cc:     GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jil Rouceau <jilrouceau@gmail.com>
Subject: [PATCH] staging: qlge: qlge_main.c: fixed spaces coding style issues
Date:   Fri, 29 May 2020 17:17:49 +0200
Message-Id: <20200529151749.34018-1-jilrouceau@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the missing spaces before and after binary operators.

Signed-off-by: Jil Rouceau <jilrouceau@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c92820f07968..36f8d2890f9a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -702,7 +702,7 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 
 	size = sizeof(struct flash_params_8000) / sizeof(u32);
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -765,7 +765,7 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 		return -ETIMEDOUT;
 
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -1543,7 +1543,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 			struct iphdr *iph =
 				(struct iphdr *)((u8 *)addr + hlen);
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1650,7 +1650,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 			struct iphdr *iph = (struct iphdr *) skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1939,7 +1939,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 			struct iphdr *iph = (struct iphdr *) skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 					     "TCP checksum done!\n");
@@ -4563,7 +4563,7 @@ static void ql_timer(struct timer_list *t)
 		return;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
 static int qlge_probe(struct pci_dev *pdev,
@@ -4635,7 +4635,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	 * the bus goes dead
 	 */
 	timer_setup(&qdev->timer, ql_timer, TIMER_DEFERRABLE);
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	ql_link_off(qdev);
 	ql_display_dev_info(ndev);
 	atomic_set(&qdev->lb_count, 0);
@@ -4769,7 +4769,7 @@ static void qlge_io_resume(struct pci_dev *pdev)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Device was not running prior to EEH.\n");
 	}
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 }
 
@@ -4831,7 +4831,7 @@ static int qlge_resume(struct pci_dev *pdev)
 			return err;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 
 	return 0;
-- 
2.25.1

