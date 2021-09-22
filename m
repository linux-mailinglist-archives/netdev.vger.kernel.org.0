Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7050541467F
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhIVKfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbhIVKfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:35:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C226CC061756
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:34:12 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c21so8238758edj.0
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20210112.gappssmtp.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gy0hrvdrKMgs3UEYzYRMohXK94Pj4pVimU+FE4pAVRU=;
        b=brR113COaSfE01TrK28JHxCamHzOVUudCwPRt2YqGGJq016mkqAMoj+de6gAQh1gu4
         gtWzh59w7vE4jr5kuVH+YyGify/JKSyWbCmzU7CvGPU36V09PG/LUroYtuM0ShpOVnKy
         iOoN83/hs3B6l9zQwW/Q2lfqBk1RV58/t6E00bgfg8B1mMJH5XCwjmtCxFuxC7lAs8e9
         CGsu89RU/0owOVKqcXznbGNYp3iKaaCdPwDxkIeVKYS/gcymbsFAnr/ElWeypImOu1uL
         KzC2SgMM5YRAGULwwcZAr4wZJ6jCb9+sq7uw7XiOCCMw3yYdT4Hsmea4tNVcmmXxR68k
         Dz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=gy0hrvdrKMgs3UEYzYRMohXK94Pj4pVimU+FE4pAVRU=;
        b=2oHA+oyZimyX5RvIKHLu1iwFfcOsyg284n59CLTyN7ox4M85OVCXYAVsGELWib0V/f
         36mAXNa+O7ar7OQV5omM6e/SmCqZ6G0NgoGBEknURR1Btf/3VRIG2mHeccMOFfTNa6yM
         7B8askwlE7D3GLG1TOkyi5sAtwDKugVElP7Or2hKYRs1kBmr4hd7/pWu1br+OzEWybTC
         y6Zup4rSnolB6iaCnFQcMNb3VPWK8CyW1mCyz9ulgNen+ZYqD5YdsCuuwmv86Tuur6Eh
         ZLvQ8bayVMW9J1ZQ5n48r1djzd3BCO6di+s5OFwOkhryhkWOcdJ7qndvN78sGMMgG30M
         tbEQ==
X-Gm-Message-State: AOAM530I23pekjldlE9WwsWPaek8wDSqwYjxy0Oi9pe4HTYYWbWQdXmp
        BkahhXk6EPp1XtWA9erHngkE9g==
X-Google-Smtp-Source: ABdhPJwGxeEISLOmFzWsmhonVLuiAisH5eQkUrBNFztck0LTg9TV6uzNdfR/LpfLLSa/RWOujkPnVg==
X-Received: by 2002:aa7:d99a:: with SMTP id u26mr41028468eds.320.1632306851422;
        Wed, 22 Sep 2021 03:34:11 -0700 (PDT)
Received: from localhost ([2a02:768:2307:40d6::45a])
        by smtp.gmail.com with ESMTPSA id c21sm844628ejz.69.2021.09.22.03.34.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Sep 2021 03:34:11 -0700 (PDT)
Sender: Michal Simek <monstr@monstr.eu>
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: xilinx_can: Remove repeated work the from kernel-doc
Date:   Wed, 22 Sep 2021 12:34:04 +0200
Message-Id: <267c11097c90debbb5b1efebbeabc98161177def.1632306843.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial patch. Issue is reported by checkpatch.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/net/can/xilinx_can.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3b883e607d8b..85c2ed5df4c7 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -516,8 +516,7 @@ static int xcan_chip_start(struct net_device *ndev)
  * @ndev:	Pointer to net_device structure
  * @mode:	Tells the mode of the driver
  *
- * This check the drivers state and calls the
- * the corresponding modes to set.
+ * This check the drivers state and calls the corresponding modes to set.
  *
  * Return: 0 on success and failure value on error
  */
@@ -982,7 +981,7 @@ static void xcan_update_error_state_after_rxtx(struct net_device *ndev)
  * @isr:	interrupt status register value
  *
  * This is the CAN error interrupt and it will
- * check the the type of error and forward the error
+ * check the type of error and forward the error
  * frame to upper layers.
  */
 static void xcan_err_interrupt(struct net_device *ndev, u32 isr)
-- 
2.33.0

