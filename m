Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02201EA217
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFAKpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:45:31 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE1C061A0E;
        Mon,  1 Jun 2020 03:45:30 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k19so6879960edv.9;
        Mon, 01 Jun 2020 03:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQCWkDRq2fhfxdoPdO9VTDnwBK6o27h3tUHRPkDXm2M=;
        b=e6PjRJPOmtFkfuUv9375vTAtLHEE81iHXsUcTZeDIaicRpjzz3zh6/4s+CP+KJbHq0
         9yFdmTj0dMewxswB6bd/1UIAB1hJGNKyD9Uo+JRQraQ16zN4w9+2BuFzqJdVn+MLF/Gr
         skjGuUgM7/opznglu3d0lFNxD/HwQGREr7xJvuc+5V6WOFPWdcBwmopOeNjkcRMWKmeg
         rbw0PAFrTI7nGUHONO8OtPtCXWXAR9y4kJsYEQsC8LQYeWWL1l8t4q4I1m7YcUxmLG5t
         ovbqwkk6JU6biOoLcxX8MMIYEWtpei463MPawitarFfVcxyDNzNbYH0O8aVV7GRyosMi
         vWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQCWkDRq2fhfxdoPdO9VTDnwBK6o27h3tUHRPkDXm2M=;
        b=EB8iRRP+UNRIFSKiK55QBGbP0OvG+AUtCCl9OsqyBW/Gd+DBEVp4Ev95JOa2/me3Qo
         LGrZ+AE6x5ZF8ablDRdv/V1O4qaaHGznt/uBDe+LXPDrvO9FE2/lRRaI06ypXjR06n+Y
         +qMmKXyGRQfWvZmEwCZqZTub9NttAY1zB74JD+dql1LxWnB1OR10cxHeAmb7Zpb81L39
         EQOopu9cukx6g6WGOJzFxXKA2SiX6rg+Xu8DHI6+NHmn3H914Hvtw342ISmxDKV8yGjQ
         OUzRBTPwHJ2rfz85Mu7NmNPoD120KfDAunoAm6i/81W3ntD8uW4ZOEUB/EFdYKDmlPSe
         VmYQ==
X-Gm-Message-State: AOAM5308eu1EyPeCqq3yr9MzJaVzoCS75dJyko33cyPOwS3T6hjsnxxN
        JYjQ2fVw3ySFKgCHi8qA4Bo=
X-Google-Smtp-Source: ABdhPJwCI8kOy/Wj8syQKlllWZd6n9UrlrKdjr1Mn56O/Q0uCz9gJxrvUKgqALFfIXue4utIqXp3xQ==
X-Received: by 2002:a50:f9cc:: with SMTP id a12mr4160580edq.227.1591008329663;
        Mon, 01 Jun 2020 03:45:29 -0700 (PDT)
Received: from ubuntu.localdomain (host-85-26-109-233.dynamic.voo.be. [85.26.109.233])
        by smtp.gmail.com with ESMTPSA id sa19sm8360923ejb.15.2020.06.01.03.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:45:28 -0700 (PDT)
From:   Jil Rouceau <jilrouceau@gmail.com>
To:     manishc@marvell.com
Cc:     GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jil Rouceau <jilrouceau@gmail.com>
Subject: [PATCH v2] staging: qlge: qlge_main.c: fixed spaces coding style issues
Date:   Mon,  1 Jun 2020 12:44:16 +0200
Message-Id: <20200601104416.102566-1-jilrouceau@gmail.com>
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
Changes in v2:
	- Based tree changed from Linus' to linux-next.

 drivers/staging/qlge/qlge_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 402edaeffe12..1650de13842f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -687,7 +687,7 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 
 	size = sizeof(struct flash_params_8000) / sizeof(u32);
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -750,7 +750,7 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 		return -ETIMEDOUT;
 
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -1528,7 +1528,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 			struct iphdr *iph =
 				(struct iphdr *)((u8 *)addr + hlen);
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1635,7 +1635,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1924,7 +1924,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 					     "TCP checksum done!\n");
@@ -4547,7 +4547,7 @@ static void ql_timer(struct timer_list *t)
 		return;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
 static int qlge_probe(struct pci_dev *pdev,
@@ -4619,7 +4619,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	 * the bus goes dead
 	 */
 	timer_setup(&qdev->timer, ql_timer, TIMER_DEFERRABLE);
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	ql_link_off(qdev);
 	ql_display_dev_info(ndev);
 	atomic_set(&qdev->lb_count, 0);
@@ -4753,7 +4753,7 @@ static void qlge_io_resume(struct pci_dev *pdev)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Device was not running prior to EEH.\n");
 	}
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 }
 
@@ -4815,7 +4815,7 @@ static int qlge_resume(struct pci_dev *pdev)
 			return err;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 
 	return 0;
-- 
2.25.1

