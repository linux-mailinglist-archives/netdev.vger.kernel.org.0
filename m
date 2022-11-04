Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD17D619F0D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiKDRm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiKDRmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:42:46 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A3E4730E;
        Fri,  4 Nov 2022 10:42:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bk15so8000572wrb.13;
        Fri, 04 Nov 2022 10:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKlyHrBk6uetU/GVQyEI1FfJUyJLjj13qeWJVqCWCUM=;
        b=kedX8sosCJ5qsYkfX3RaW9LaKcF//hxYQInYXGNpWqO+5gsqpmT64lPNUv0xUdJIY3
         Q2RbyK/Rbo04l1uKRr4b+OkpAOTZ5kovkoUqbKuX5DSASMlCmUNAuR7+pwLOvJNza/SH
         hcqMjHo556IB+A7NiMKAok+UuBQoL1huUHEYassvFbCkfP8Mj6JrZ6LBtQINnWFM7vEw
         hEJmN11WswX4vj4Mqgdr5SmSPIXmN8WaqMYsNFq1SeYf8mQ2i9BHBOa0v1acn9NrnvpF
         CaD1NoUwa2bhNWy7AVrUDMoMeeLOS2we01NFiwuLoz53bvWiqValEp5IohI5jP5TJGT9
         qTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKlyHrBk6uetU/GVQyEI1FfJUyJLjj13qeWJVqCWCUM=;
        b=fkmtis8D2its74OyyCpjs+payPkTFAovx2Alzsk5+0XDCIMbETMUq+Qj04x4V5Zk/R
         VLb2TtloFT1OExt4RunqEznnsbsKird27trIgLJtdOhUpIhDIEmPu4FBQfRakz7vfBRr
         Wm59w64ccGpxZs7SETB387caW9elQQ1gDvypQFrc3IanKzJOLfsjGLdjxJP8PP8FjU+F
         QsXHVvyFlI/364xfqSwxY8yDoJtBDmlxa8SszYRt0tLgbgRG/1sAGsvdsVJ7v3f9uSp1
         gJAGeFpLYnSbZ7ZCcmPqOWMPVZdjst3xwJJYl7Kn1rfLC1F9HFKjKW8ytRGVCLJtkL+J
         1gcQ==
X-Gm-Message-State: ACrzQf14tQ5H5Ihe9CUJIzQJUD/Okvhk3dXFs8WFIuv5v+ya/Q5rvJ3o
        QzBTl2DKNZFSCwfAc1IoB2U=
X-Google-Smtp-Source: AMsMyM7jgtxsu+d5K0f8IK2VIuL73JmgFxHBkTy+pp6UiMCYdBAw9LwXNcPCOMZowPc9kYkoBSElSA==
X-Received: by 2002:adf:e804:0:b0:236:657e:756e with SMTP id o4-20020adfe804000000b00236657e756emr23723114wrm.452.1667583736992;
        Fri, 04 Nov 2022 10:42:16 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600c150300b003c6c1686b10sm3232113wmg.7.2022.11.04.10.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:42:16 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: alteon: remove unused variable len
Date:   Fri,  4 Nov 2022 17:42:15 +0000
Message-Id: <20221104174215.242539-1-colin.i.king@gmail.com>
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

Variable len is being used to accumulate the skb_frag_size but it
is never used afterwards. The variable is redundant and can be
removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/alteon/acenic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index d7762da8b2c0..eafef84fe3be 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2435,7 +2435,7 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 	} else {
 		dma_addr_t mapping;
 		u32 vlan_tag = 0;
-		int i, len = 0;
+		int i;
 
 		mapping = ace_map_tx_skb(ap, skb, NULL, idx);
 		flagsize = (skb_headlen(skb) << 16);
@@ -2454,7 +2454,6 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 			struct tx_ring_info *info;
 
-			len += skb_frag_size(frag);
 			info = ap->skb->tx_skbuff + idx;
 			desc = ap->tx_ring + idx;
 
-- 
2.38.1

