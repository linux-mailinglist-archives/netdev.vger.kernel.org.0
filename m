Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5686D5CA
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403897AbfGRUbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 16:31:00 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43282 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbfGRUbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 16:31:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id y17so4063675ljk.10;
        Thu, 18 Jul 2019 13:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5uFK7MqKRb+oFVKD89Io/malOAroV84oVCRoYwQTVLs=;
        b=ByuNj8jVyAGVVYdET8ktdlDqRCowxA9phMWJ7m0Sg/hw15WKOcetKCoYWFrQQJQRKo
         LtEcfREetsclcT4WkgGXcEBP0H8PXdH/UinOi0mrnbXCaG1uU7JZ/TSnEnww/R4X/mTz
         oY9MWuFdVzOuJB5eaML5omcF2fQwGzk4Q2mCo4iQ+VdUEQ8P4ArKNmYpxQn4VQnZcBIm
         tZibUPoWhfIJRuQA9XBnVICH4JPqmb7LBSilxOxr8Kol1LQFKxRHzVLNBPcYd0GBe9qK
         UJK5HYVWYrK9uQ2rjRIQICntWRhJ/+09hxemcPaQHi7E/J8jQ2HvL+W709oR5yYvVCaO
         1FkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5uFK7MqKRb+oFVKD89Io/malOAroV84oVCRoYwQTVLs=;
        b=Wd/ttAEyMjnAWJmG6cpWJ5G0iiigr1Dp59imj/LLlHB/+T6lDyJeDmoe+mvsApnNZf
         up5B7z0ITJFd5ElYDH9CCbsIdooeDg4AFGu3Eiixcxv3GAXOlYOBS6Mb7kd2oFGsgecB
         QlQvOkzM6tPNyba0jVreclm4TwnCF6dmxjDiYGivoxTopmj0ET7vOfnDyxAFprREMO9V
         lXnKKyQqt8tSgRZdR5BVmUzfbUPIrSmO1nS8W2Ggt5qmdMWGCjXj0Cr65ohBYh4YL0NL
         11K0/2Bx68R/lywTNoH/90+lgVYJSomS2arS02Zx/ngPzlz+R3yfKJNOjcqUflI0by4C
         HFTA==
X-Gm-Message-State: APjAAAX23c6cw6DfX54srxA1ajs+a+btBb05ze+0QbCSkw7nupvqFXJH
        lcdOyCHuBNop1jOcyd2NAys=
X-Google-Smtp-Source: APXvYqzYOuKKYg4wEuoB/Wrmt94ndQPSqKVzWpoKOkFOelXaVESsDwy8xn8HcjyigaNiphMBNBSVag==
X-Received: by 2002:a2e:9a13:: with SMTP id o19mr26037315lji.102.1563481858169;
        Thu, 18 Jul 2019 13:30:58 -0700 (PDT)
Received: from ul001888.eu.tieto.com ([91.90.160.140])
        by smtp.gmail.com with ESMTPSA id d16sm5229387ljc.96.2019.07.18.13.30.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:30:57 -0700 (PDT)
From:   Vasyl Gomonovych <gomonovych@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: Use ARRAY_SIZE
Date:   Thu, 18 Jul 2019 22:30:32 +0200
Message-Id: <20190718203032.15528-1-gomonovych@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix coccinelle warning, use ARRAY_SIZE

Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index b491361e6ed4..49fc04412e9b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -976,8 +976,7 @@ static int ath10k_snoc_wlan_enable(struct ath10k *ar,
 				  sizeof(struct ath10k_svc_pipe_cfg);
 	cfg.ce_svc_cfg = (struct ath10k_svc_pipe_cfg *)
 		&target_service_to_ce_map_wlan;
-	cfg.num_shadow_reg_cfg = sizeof(target_shadow_reg_cfg_map) /
-					sizeof(struct ath10k_shadow_reg_cfg);
+	cfg.num_shadow_reg_cfg = ARRAY_SIZE(target_shadow_reg_cfg_map);
 	cfg.shadow_reg_cfg = (struct ath10k_shadow_reg_cfg *)
 		&target_shadow_reg_cfg_map;
 
-- 
2.17.1

