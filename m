Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E04DBB4E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345185AbiCPXrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiCPXri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:47:38 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6CAE89;
        Wed, 16 Mar 2022 16:46:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m42-20020a05600c3b2a00b00382ab337e14so4064592wms.3;
        Wed, 16 Mar 2022 16:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSX5Rth7wwj83rxTYc+rwdv+c14uPhz18sTsRPEgR/E=;
        b=cDeXbYS8Zb7+0/CDX+L3jB2qUzVT/9dkvRHVIlv9xeSwjYyGVNRSEK2EnP9tx34m4Q
         owsQe6WKA7D6BDCGu0GbZ8Eb9rP1LkGzPad+/fntJsAGWKwSMKlt1dcp/8zf7n9rsRah
         q3ajz9xH0DJeaMc2c1L8z6n/QRswEGS9G5hvphVgOlgsqno6YB2VJggTYRcZjrBRhXFq
         Z9rdEKWCwDmdX1dJPsCxg+0tI8aaDbGhDBJhdmswM0ZERBvUS1hc9kLBl5d5EH8f3vqF
         y5/CGf/93cEzW2rnuQK7zDWJkXd4JlVphWgjIKDhxa0ZRWc+uLkImmpQRL2TBE+vSLOv
         annQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSX5Rth7wwj83rxTYc+rwdv+c14uPhz18sTsRPEgR/E=;
        b=FFX+pG8XW/gceIQjzslWMvNErvZoYm1fBejJjwckeJo7DSli8T0ckBFvsrNG5lnNka
         L0E5ZMZnSCv5qL6qa0bWdgxg4O81qpMToBcSbXFhBQZhVJhuYzE68ei1k5x3MNTtOuv+
         utxe4AqTUutr1tVF7ZDPCuhic2WBWISKRUKaqbo7jhw43kZz4H7cP9jAp0Xr+hj3kEt0
         ek7bi76Nut6CAphAVAQ2jwRHBkOqn7RvMxBGaxNqkoUTKIflCjDMvO1UqGhry8o4GCXU
         dYnFlKPrDC9vxRXpSvOP2i/ziUtkClLJ/bTfq3/KmQq7PVDNlUIpLqLYlbStZ6CzGXUu
         kV9g==
X-Gm-Message-State: AOAM532LYGhVdF48gVJsrXrO5BpUv1dOzcn5CuYpVYWWxHyQT4GBwYN9
        nI+ckVWk56UqmRrhDn3hdrs=
X-Google-Smtp-Source: ABdhPJyxcNhyV4ys0YsNVf6IfPElpeiApCn9unzK7l2es+CC4mQwMkYYrz86YyuiUTom73kbiVIMEA==
X-Received: by 2002:a05:600c:264e:b0:389:802e:c7fa with SMTP id 14-20020a05600c264e00b00389802ec7famr1622306wmy.93.1647474381806;
        Wed, 16 Mar 2022 16:46:21 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id u15-20020a5d6daf000000b00203db33b2e4sm2825884wrs.26.2022.03.16.16.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:46:21 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: sun: Fix spelling mistake "mis-matched" -> "mismatched"
Date:   Wed, 16 Mar 2022 23:46:20 +0000
Message-Id: <20220316234620.55885-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/sun/niu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index ba8ad76313a9..42460c0885fc 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -7909,7 +7909,7 @@ static int niu_ldg_assign_ldn(struct niu *np, struct niu_parent *parent,
 		 * won't get any interrupts and that's painful to debug.
 		 */
 		if (nr64(LDG_NUM(ldn)) != ldg) {
-			dev_err(np->device, "Port %u, mis-matched LDG assignment for ldn %d, should be %d is %llu\n",
+			dev_err(np->device, "Port %u, mismatched LDG assignment for ldn %d, should be %d is %llu\n",
 				np->port, ldn, ldg,
 				(unsigned long long) nr64(LDG_NUM(ldn)));
 			return -EINVAL;
-- 
2.35.1

