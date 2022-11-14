Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD8628673
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiKNRDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiKNRDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:03:21 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAAE216;
        Mon, 14 Nov 2022 09:03:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p16so7915737wmc.3;
        Mon, 14 Nov 2022 09:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pD8Jn9+GurJEYfPsp17CSsQyybI00eab/WVHKrv8CWo=;
        b=MbBwljAg07T3h7qjUGqcGJp9iCgCOdI4/eXelF/C8ZVwneKKInAPiHFVNlj5Nd+xub
         Si8/71mjU8wqlMmbgHzeD+Vya1R2XkH2j9SLIz+tHRyoIrZmpayAxumf3BfrRT5mQOoM
         BcD3YycGtW58E3SZ81zImd1neXPA12BQCTv0J647EJkNFMaKcRL6pb+8tjWV5RYfVIO8
         G6hYThU880TzTTA5RH5i6XkoKTNx9HHEexOqbhsG21SAe1ILNjdV+/TeHCLSidYQENnO
         NkWSrnTvyf3Lw2c1DGZn3V5W2/fpTMME9jGcHFYZ3XdBFbLMP/POH3uTIAjTNfMxrM4j
         ov3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pD8Jn9+GurJEYfPsp17CSsQyybI00eab/WVHKrv8CWo=;
        b=XhAcQ45FV8pBi539oCqkRrXjfkbTDFITnF55/MnD/5qM99Q1itBiybbYUHUkCjTF+h
         PZ2Zvp9KLZdFi6lb1Lg2tjCQ3dXZ6hADGF62JWMy/t+gC7cbOUbFh3x+WqMfMA7YBp+9
         6QogagMI6cgP0MOfKrsjFSYrPCJI4qVGKl0FkCX2R3djUjp2tyFJ8UMFIMVpsdo8y6w/
         JryzgbjiuuPoLIaX4yM8NJis3ROAEHlx6235i557VTVv1fMWenWf/BFD+RxT74THR/6Z
         CPyzDzeqFS7Nmr/jilLExUiAhFbe/E2vk45hvbYspKx3HG72Im3rfFr2zurvdR8mJDvj
         pqag==
X-Gm-Message-State: ANoB5pkdhVH6E3vqeqjaIUqRQhV8hbCSa60j56fThbPJcNtDapG91k0+
        hq/5CAzGWuRyLz7pAWaTRO8=
X-Google-Smtp-Source: AA0mqf7ZsFKetwS5r8cke42/bWGUErC4VllUnL6HFvPitINnwTHOYz/kaLGWi3HH4SvMscqCwk1SKQ==
X-Received: by 2002:a05:600c:1d11:b0:3cf:a6eb:3290 with SMTP id l17-20020a05600c1d1100b003cfa6eb3290mr8819977wms.116.1668445398637;
        Mon, 14 Nov 2022 09:03:18 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id e12-20020adffd0c000000b00236576c8eddsm10217840wrr.12.2022.11.14.09.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:03:18 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sundance: remove unused variable cnt
Date:   Mon, 14 Nov 2022 17:03:17 +0000
Message-Id: <20221114170317.92817-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Variable cnt is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/dlink/sundance.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index 43def191f26f..aaf0eda96292 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1414,7 +1414,6 @@ static void refill_rx (struct net_device *dev)
 {
 	struct netdev_private *np = netdev_priv(dev);
 	int entry;
-	int cnt = 0;
 
 	/* Refill the Rx ring buffers. */
 	for (;(np->cur_rx - np->dirty_rx + RX_RING_SIZE) % RX_RING_SIZE > 0;
@@ -1441,7 +1440,6 @@ static void refill_rx (struct net_device *dev)
 		np->rx_ring[entry].frag.length =
 			cpu_to_le32(np->rx_buf_sz | LastFrag);
 		np->rx_ring[entry].status = 0;
-		cnt++;
 	}
 }
 static void netdev_error(struct net_device *dev, int intr_status)
-- 
2.38.1

