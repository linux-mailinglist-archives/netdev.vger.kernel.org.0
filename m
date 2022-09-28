Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1AC5EE864
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiI1Vh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbiI1Vh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:37:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772F78A7C6;
        Wed, 28 Sep 2022 14:37:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u16-20020a05600c211000b003b5152ebf09so2094701wml.5;
        Wed, 28 Sep 2022 14:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=rUM2aW+DGDXanWCdc+mwoRm7T1Ng16porQzPW5bnT68=;
        b=gCmDQHezOruhG4NU0X2rFe4/f5TI833m5vGO+Ru/0Ypx3qcgf8R83gDNHEp/KoBiyF
         WXsySZTtMxgiQvZjrQmNb7F9p3W/V22bd35ShPx3VT8hJT7tyZoi5RP5VnG3DPdbAz3Y
         eJERqPIx1PI9yEFi1oLlii0qh+ONZib8vwCxKttrc4K/2hogL+eisAaUeV0rZwNOH00G
         ZzIpigJGpkhu4ZVk2GqILmRDPG+SY+VoFW6NwIfXEzfESidjdKgGE1DGeBFr34tibzds
         oLcujW3C2b6oMG7o+q/d4ExABXZ7snEx2XC2lmm46AfZFhZWfCWV5piThVrBMcxlux0l
         /VfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=rUM2aW+DGDXanWCdc+mwoRm7T1Ng16porQzPW5bnT68=;
        b=W8mAxY47BYkIvq+Dq9IAW4msD9GLTN4DD6KY4O19wGD73pqYZ15Cs9oEsy6qOJ9ol+
         x+qU3lL056bUAs/y+x2SL6oybfUvm0OYIzUlnpbVrvKSGYOXwY2w3J845RfFYEUy0mPk
         +6u9LrLEtfWwXAhngJFW8W3/Wrx2e1tYc2ScP5Tw+tD6lG3kHNBZD48FFoyROzGnjFZQ
         1YpKuCwan0OerLTknYcrCPWAHQDjVgsOf6GEOPztU9IOtOOiosHmdhLnV74Wj8HhmNLU
         nJ+qK7ZggzVnKjXqePV8GjLvjXT6mgwlOLkznR98SOzMjItGHJnQ5pAcfUR8V6Dks2A7
         0j/w==
X-Gm-Message-State: ACrzQf28R7gb02JqdziDQhdA5ZP7+UxRbbj1zNFbWgw4eHSRBoGtXqNP
        rVI+X4TSXJRMWQzu/kJl4YU=
X-Google-Smtp-Source: AMsMyM60Wxnr54EUrqhnbxDpHDSl2eN+WPEqNCfd39U/NxNPYyBp2DnNK2zqHZjaUT3IedG0m9aZ8A==
X-Received: by 2002:a05:600c:4f53:b0:3b4:9aad:7845 with SMTP id m19-20020a05600c4f5300b003b49aad7845mr11844wmq.159.1664401075103;
        Wed, 28 Sep 2022 14:37:55 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id h9-20020a1c2109000000b003b4fac020c8sm2583719wmh.16.2022.09.28.14.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 14:37:54 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bnx2: Fix spelling mistake "bufferred" -> "buffered"
Date:   Wed, 28 Sep 2022 22:37:53 +0100
Message-Id: <20220928213753.64396-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are spelling mistakes in two literal strings. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b612781be893..6e22000074b3 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -176,12 +176,12 @@ static const struct flash_spec flash_table[] =
 	{0x19000002, 0x5b808201, 0x000500db, 0x03840253, 0xaf020406,
 	 NONBUFFERED_FLAGS, ST_MICRO_FLASH_PAGE_BITS, ST_MICRO_FLASH_PAGE_SIZE,
 	 ST_MICRO_FLASH_BYTE_ADDR_MASK, ST_MICRO_FLASH_BASE_TOTAL_SIZE*2,
-	 "Entry 0101: ST M45PE10 (128kB non-bufferred)"},
+	 "Entry 0101: ST M45PE10 (128kB non-buffered)"},
 	/* Entry 0110: ST M45PE20 (non-buffered flash)*/
 	{0x15000001, 0x57808201, 0x000500db, 0x03840253, 0xaf020406,
 	 NONBUFFERED_FLAGS, ST_MICRO_FLASH_PAGE_BITS, ST_MICRO_FLASH_PAGE_SIZE,
 	 ST_MICRO_FLASH_BYTE_ADDR_MASK, ST_MICRO_FLASH_BASE_TOTAL_SIZE*4,
-	 "Entry 0110: ST M45PE20 (256kB non-bufferred)"},
+	 "Entry 0110: ST M45PE20 (256kB non-buffered)"},
 	/* Saifun SA25F005 (non-buffered flash) */
 	/* strap, cfg1, & write1 need updates */
 	{0x1d000003, 0x5f808201, 0x00050081, 0x03840253, 0xaf020406,
-- 
2.37.1

