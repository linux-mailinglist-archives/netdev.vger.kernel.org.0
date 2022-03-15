Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CB4DA556
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352222AbiCOW1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiCOW1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:27:30 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E405C66A;
        Tue, 15 Mar 2022 15:26:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so480830wrh.11;
        Tue, 15 Mar 2022 15:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+7gsptSCcEneI6TJ6IZ79PWOc2Xel+uahXLSZntUag=;
        b=VcvBmfSZbZGqcGB3qO8Czr6VUT5EVLRrSAeNopn67koxcESvdWZ0yXBUItmbeSfvJN
         +nb1xRbrkN4/iXywG7iwJq1aS+2L+N0xa7Rf7EaZephFmfOFR8zi8p/BmofUu//Hu8A4
         zzH39iCzT1dFQuUG77bO2FbdbXr6BVaOO+sCKM24tjc7iIHp7Esw+BB1ryNYawpR7Kel
         y+2JqGgDlkM+kVgLLs9v74uMWkGujkh+I0Ws0IBI2fv/H4BORTft5lZ1l/V2AWjnZw6K
         SaeMtpHwZaUzQxPruC2Tpt9AF9sgTX0iazad2DNivMYqAp38zeATnR2RIrn9wFtEnCgo
         GV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+7gsptSCcEneI6TJ6IZ79PWOc2Xel+uahXLSZntUag=;
        b=Sn6z7MGwYUc5G03v0+VKMI9GLTuwdfIVVdHeSVBOEMDS9NLwWYkcWNvmg0SBHF0GE4
         NrS5DZfUv1fDvHtVYQgRbjDePgXJc0wCmlstN2ygY7naW5i5g7TAmE7zl0qaUbvBiTHK
         /AOfnjUXP0TWzAwb5+fQvapcEl19dSANXgPJ8L9qiTMsiyPPshQH/NpF4W7yjpm4q+uJ
         VLKDzEtRU3gH6hiBHpr3g6mVIOqlV6c+dmTUMOrdHABua4V/+XMht0e06HPiYj7mMprC
         8vMNZj4qLGqrjVjA5UYRw8/TJL4bta+c+PjNpJU49vOfl4kKuBZCWBdQKDfMlZx8KJi6
         yWVQ==
X-Gm-Message-State: AOAM531+OyTmqcgyYsm+V6YtcfQ4ZF42gi9seht3ifipcuPQ42dnv6ud
        SRGt0iWZxMg5W2HKHtJCzlkkN1yI2WWxrg==
X-Google-Smtp-Source: ABdhPJzrvoqRxNXnTa1VtmcVGYIfbK7Xnsy3iA2OLrU5s6f7sViv5YbKf701tetRQ9Iyc0IlyaQRgA==
X-Received: by 2002:a5d:6751:0:b0:1f0:4a7a:ba31 with SMTP id l17-20020a5d6751000000b001f04a7aba31mr21882773wrw.181.1647383176605;
        Tue, 15 Mar 2022 15:26:16 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l13-20020a05600002ad00b00203d64c5289sm155955wry.112.2022.03.15.15.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:26:16 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] gve: Fix spelling mistake "droping" -> "dropping"
Date:   Tue, 15 Mar 2022 22:26:15 +0000
Message-Id: <20220315222615.2960504-1-colin.i.king@gmail.com>
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

There is a spelling mistake in a netdev_warn warning. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index e4e98aa7745f..021bbf308d68 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -439,7 +439,7 @@ static bool gve_rx_ctx_init(struct gve_rx_ctx *ctx, struct gve_rx_ring *rx)
 		if (frag_size > rx->packet_buffer_size) {
 			packet_size_error = true;
 			netdev_warn(priv->dev,
-				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, droping packet.",
+				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, dropping packet.",
 				    rx->packet_buffer_size, be16_to_cpu(desc->len));
 		}
 		page_info = &rx->data.page_info[idx];
-- 
2.35.1

