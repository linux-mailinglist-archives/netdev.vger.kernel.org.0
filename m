Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107261B3787
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDVGZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgDVGZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 02:25:28 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD32C03C1A6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 23:25:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j7so573616pgj.13
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 23:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HoCB0Wony/g+lSamDxm+17inMcgIEQTxHvFewGgnhJw=;
        b=hBUqvstTe/mlIuXX9ns+e8zJ14tBGeAiT9dBb8kkmT4J+y8IJ4Tgvd/RO9Yq7srsEd
         nKqS5PvkMIzRrLr5lVwvTk3cIDkKzWujpGi+7w+BBUO++8ggcrwlM4Z/wxu8VGErUmar
         rBBpXTjgypSQOcYts3ys/JiLpl7V0RkFghnUHqPi3WSD94XO7DW6AVKelxaqcCKlXfxz
         L5xNZmvpY1Y7W76Lr6dEIEQNc4XeUfylSMVDAp3hICOMnAOWJROk/CagHsIG/ygZDMzX
         Vla5a0iSqGwh63+sxJEiTD83o1zowyN5m21TMtqHzExKMAl63xvqvSY4h74FJCmpnR3c
         z4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=HoCB0Wony/g+lSamDxm+17inMcgIEQTxHvFewGgnhJw=;
        b=MLKXofErQcNgG/Y6I6u2X/W2xt1NcOOO+mBn1Io1r7utBSIwcfa2mxCGZ8tQzwybqU
         P5fS2TX8tCiP4kXdUJBMTufHm0HRCE64XuckvcBP5Lc+rcc3yzwd80OLr9CHywrPlaVg
         hvTVxYYaTp+/i/7L80c6KJtc9ILbIY/16yYLthq7PNlq9hJ7nkwJ5z99sZ1c3GhCqBSC
         wbWCIwYqwzdddis9IVnqAU/WwTbYouJn/y6QbCcYXNXWUJPMl3BHDhEJFUYZOTEEWDU1
         BmRNr95MTBscuQ5J7DGalFLtRubaKOcIgWOtKYDlMgV9mL8I07DP6CcfsHEs6nDQuUaJ
         nm0w==
X-Gm-Message-State: AGi0PubEGYeYOM4j99m/pz3wURB193PSL+tAGEIqBj7BTAdLcoqD3NAu
        TwvM9yTG0fbwff3+51gEaifxPG5V
X-Google-Smtp-Source: APiQypLWdjqxhV1iwN2PKXQch6rGruff2bfJg/RDWH9JGb0txBtgAgEMHYtmE/OBGmTyVsbyngQhHw==
X-Received: by 2002:a63:ca41:: with SMTP id o1mr25683986pgi.419.1587536728039;
        Tue, 21 Apr 2020 23:25:28 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id m3sm4175777pgt.27.2020.04.21.23.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 23:25:27 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH] wireguard: remove errant newline from wg_packet_encrypt_worker()
Date:   Tue, 21 Apr 2020 23:25:13 -0700
Message-Id: <20200422062513.13953-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

This commit removes a useless newline.

Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/net/wireguard/send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index c13260563446..78f240940cbf 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -298,7 +298,6 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
-
 	}
 }
 
-- 
2.26.2

