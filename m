Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154DAE78E1
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfJ1TCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:02:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40734 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfJ1TCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:02:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id r4so1848810pfl.7;
        Mon, 28 Oct 2019 12:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=PmpdsSGsRTPJg2gNTTOfS95j5BoFg8jBx/R2QLL6v8o=;
        b=QW7T+7VH6bTSUJYpsD9DofS5t+hGVEVgukx4XTG2cdwHVABcuTyxDvXDzm2s6jXVkl
         FKlzE+PLCsasuboJsXYTruoMlgNyiLCMDrKDbf734HlHC5jNJdRYmi7eXhHGmgJU/01d
         HQxR3y9390Q18ZG5BEq2w8Ydb6sQ7IMTV311i4NalN9JErK2yRYnUSQwz1YZw3LApoyC
         S8l+ZQuAqqsdHXE0FSvPa4U2UtnkpDvyPOiQIdtFpHG+9of7o4AMm6pRD65fq3Uf/wlp
         nJXViN8T5db66wedrvWSTypMJJGqd2YNacV9gGsR+4IkSo011Cvjpyn0T+GJOr3lVFvZ
         Kbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=PmpdsSGsRTPJg2gNTTOfS95j5BoFg8jBx/R2QLL6v8o=;
        b=cEY77S21h5Ef6AV1DaShOiB++uvFh7VMioK0pH/j3F0nfB1Rdl+WS3uhJqMIlQYnk3
         NMepotGx1iOHCreTQ4jQRGTd4VwzxVScky4Nab7VGv27zD9dM1iOzteoWLsQvJYfu53J
         qyCD/5t016ITNHw5KRyVfqQFeM3QOAkzIhv43cEnrc/Rlezc36O1jKi50nmJv8+r6EnX
         P49Pw4csch8vDdflX2J1ucouEigfDvouo1poFm3B9ZidcJz9EC2Sv6cSlkjJRwkILApa
         1CIR95nkwLaRmDgBu4xUelBSU5D31uhaj7Vdd8NoDoWc2tqwaq8Ia3mucHG2Fq59a3EJ
         g4FQ==
X-Gm-Message-State: APjAAAVOTA9A7bLUrIKRr1rD/PsV5JziyXr4CwImxaRS+bCQt9n1I+Ac
        QSzVd1VXr3wNK7Cn3WMFNTU=
X-Google-Smtp-Source: APXvYqxO42ZaEHFpqCWyXwQl9XRe8E2yopQYCUGESm+/HHd6jbR7fJ0AkMPbiQOxHHLSgYtXGxP5zQ==
X-Received: by 2002:a17:90a:eb02:: with SMTP id j2mr1061881pjz.80.1572289334957;
        Mon, 28 Oct 2019 12:02:14 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id q184sm12627210pfc.111.2019.10.28.12.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:02:14 -0700 (PDT)
Date:   Tue, 29 Oct 2019 00:32:04 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, swinslow@gmail.com,
        will@kernel.org, opensource@jilayne.com,
        saurav.girepunje@gmail.com, baijiaju1990@gmail.com,
        tglx@linutronix.de, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] b43: Fix use true/false for bool type
Message-ID: <20191028190204.GA27248@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use true/false on bool type variable assignment.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index b85603e91c7a..39da1a4c30ac 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -3600,7 +3600,7 @@ static void b43_tx_work(struct work_struct *work)
 			else
 				err = b43_dma_tx(dev, skb);
 			if (err == -ENOSPC) {
-				wl->tx_queue_stopped[queue_num] = 1;
+				wl->tx_queue_stopped[queue_num] = true;
 				ieee80211_stop_queue(wl->hw, queue_num);
 				skb_queue_head(&wl->tx_queue[queue_num], skb);
 				break;
@@ -3611,7 +3611,7 @@ static void b43_tx_work(struct work_struct *work)
 		}
 
 		if (!err)
-			wl->tx_queue_stopped[queue_num] = 0;
+			wl->tx_queue_stopped[queue_num] = false;
 	}
 
 #if B43_DEBUG
@@ -5603,7 +5603,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 	/* Initialize queues and flags. */
 	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
 		skb_queue_head_init(&wl->tx_queue[queue_num]);
-		wl->tx_queue_stopped[queue_num] = 0;
+		wl->tx_queue_stopped[queue_num] = false;
 	}
 
 	snprintf(chip_name, ARRAY_SIZE(chip_name),
-- 
2.20.1

