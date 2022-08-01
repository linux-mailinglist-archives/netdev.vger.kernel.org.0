Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCECB586293
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 04:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbiHAC3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 22:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiHAC3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 22:29:00 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A14A24E;
        Sun, 31 Jul 2022 19:28:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f65so8502270pgc.12;
        Sun, 31 Jul 2022 19:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=3xYr4cQcWaLGoMb2c8NJajLhuZ/0FrExxqhBIoYbHh0=;
        b=CFyokDQfv1Ohvad7svwO6CbJoTOJLNGD/g4jr3hS1d2M2Jqv5h/RB8yeWpHqnekw+D
         mio2bgR1Mo4vzUgpUlSpeogmqzxaxrcgl/BGp2Rnr7arTjiHX9JvzseRNvLZj786Ve5z
         U0brK45GrYBhJ511NvTEuOHflrPy++a2+ZVvrKmqHkH2hH45OskbL4M0rCcLQvCNed/6
         hzoufoK2QZKfX7x/diqTZommN5UCKizmss/nBi1OSZtOQ4s2Cv9iwdT8/rIhys614hS/
         qKK7WQ+cClByg7U7ue8vkQy/n41y3AP0WfOh72x2nHCLEc9eUg3shqIemNNubHTgJVl6
         KsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=3xYr4cQcWaLGoMb2c8NJajLhuZ/0FrExxqhBIoYbHh0=;
        b=KCbsM/KJUGrg5NxHQH0edKj7Zc00EFy/9GipbrBqvu9nsVrXt3yB3/P1V1g0DXdSWV
         9D7Dxh/Mf7k115xoclTXT/WtpGhttcmnbGCMpKZeIQHao2d+fYqHycQTWZM3STNi2P8O
         tPTjuoCvmwUUhMIFzz4DXKKXpVbvSyAHQOLjl8aANGixb6CYrwMlHncJ1hs2tJ4TS12l
         CA6bYN5CqR5KHEGOEkIWlkc5ZpfRnCVN4Mh9QTn4kyCCtlEAhbUEBQurIy+Dy7whOZPa
         R3kBjx+yHslUCJN15iuIVpNN/UrBsnFdw/bTsVwoFLDDDvFXAwRjY2ZO0VJwTnXTZUwD
         7W/g==
X-Gm-Message-State: AJIora8f6UkfISOQoyyBztX87JnM1qUZBomi2ZgcdKZL4AdsvhXI+VdI
        1v0ekdCRkbW9nZDWtAfSN6oU0WM9wSg=
X-Google-Smtp-Source: AGRyM1t3Rt343Gs/1d9wPCF3fWccMELWlg9vwsU+bcbx0dkcjdsX7Je0DQphuHCuX+A2hJkvA0nZzw==
X-Received: by 2002:a63:d004:0:b0:41a:aea0:95bc with SMTP id z4-20020a63d004000000b0041aaea095bcmr11339246pgf.26.1659320938484;
        Sun, 31 Jul 2022 19:28:58 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w194-20020a6282cb000000b0052ba88f2dd6sm7202925pfd.57.2022.07.31.19.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 19:28:58 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ray_cs: Remove the no effect conditional statements
Date:   Mon,  1 Aug 2022 02:28:54 +0000
Message-Id: <20220801022854.1594714-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Conditional statements have no effect to next process.So remove it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/wireless/ray_cs.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1f57a0055bbd..e7c88ef06bfe 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2112,8 +2112,6 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 #endif
 
 	if (!sniffer) {
-		if (translate) {
-/* TBD length needs fixing for translated header */
 			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
 			    rx_len >
 			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
@@ -2123,18 +2121,6 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 				      rx_len);
 				return;
 			}
-		} else { /* encapsulated ethernet */
-
-			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
-			    rx_len >
-			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
-			     FCS_LEN)) {
-				pr_debug(
-				      "ray_cs invalid packet length %d received\n",
-				      rx_len);
-				return;
-			}
-		}
 	}
 	pr_debug("ray_cs rx_data packet\n");
 	/* If fragmented packet, verify sizes of fragments add up */
-- 
2.25.1
