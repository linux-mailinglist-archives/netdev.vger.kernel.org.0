Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF94FB250
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 05:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiDKD2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 23:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244536AbiDKD2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 23:28:05 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8877F23BDF;
        Sun, 10 Apr 2022 20:25:53 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g11so8580199qke.1;
        Sun, 10 Apr 2022 20:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHA7sEU1znXDzG6Y0DVlhz5HYD+6Wl0L69G1MetCum0=;
        b=VN6A1io7Hk++rYy5jwB7gkCG1Mnh+Do2aFHQp5B2AD+G3f85Ob0JXTNgPI2LVqqFDv
         ncbFoN+s/vjDoLtScnY9/HeKkte1rkxIMfIrqI+Udbs91FD+6uVLtg72/VRjt621Etov
         R8DeT9S7mFKRqXESs/cnEZ9nt9lz6aX7rj13WQEFP3KJWh9hSRRoiSKO8voXazlRxltY
         WG2r3tYXJLclk0Xl9418ZafWY3v6hmNpwiz9HcKRVZIwiT6KsJDMjgRVoAIW/HXfO2qm
         Wj3T8CwbnTOkQhtIbCpmEZPRa2KrXE8I3x8l6f2IXklWcimQLnBXXqIIFdsq7DAgggBQ
         I7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHA7sEU1znXDzG6Y0DVlhz5HYD+6Wl0L69G1MetCum0=;
        b=s9KISQwdu3nmYvkUS1v043KFga9kdhLOyxoS3id0ByiaYiOjjbzxsJZrY2QutoqoJ9
         U4bGq10XPp+uBi4SDldo0RN18h2WYI/3XAwiVY0G9DMZeR4a2LEqntzzLwkDxsX7wk0+
         6M6PhOZgkIRr2Yart2m3w2kHVYC24UXVsrvM1RxByp8Ycl1+iA0Qw0Uq61DvTzpdMJf4
         ayy8kZKBDoSsY2YhnfkC3SN5unZ/kpt4XbufFKs0y8oUWan6jkWDDd+ueMPd301s8cIb
         QlSCsKKh+lRWDrcT+WVsWR4/LuuEJvp7i8iUxLyqg7StO8Iafgv+ARCqZhaGPuFZj7WH
         mcrQ==
X-Gm-Message-State: AOAM532BCEE24+eM3eXDvUt0vVyOA1guJ7sSvaSf5OHSn3/gBtXghNwB
        IyJMqAy2R3lunSir/3wud4I=
X-Google-Smtp-Source: ABdhPJwPjAfhji9iYYh6hkDmUgHxrkZNdwSljSxIaawRl2ONUgRW2cwQEuJdCOYsNuWvpTpT5sYK5g==
X-Received: by 2002:a05:620a:f13:b0:67e:14f4:123 with SMTP id v19-20020a05620a0f1300b0067e14f40123mr20317919qkl.355.1649647552766;
        Sun, 10 Apr 2022 20:25:52 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s12-20020a05622a018c00b002e1cd88645dsm24494515qtw.74.2022.04.10.20.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 20:25:52 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] sfc: Fix spelling mistake "writting" -> "writing"
Date:   Mon, 11 Apr 2022 03:25:46 +0000
Message-Id: <20220411032546.2517628-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

There are some spelling mistakes in the comment. Fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/sfc/mcdi_pcol.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index d3fcbf930dba..ff617b1b38d3 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -73,8 +73,8 @@
  *               \------------------------------ Resync (always set)
  *
  * The client writes it's request into MC shared memory, and rings the
- * doorbell. Each request is completed by either by the MC writting
- * back into shared memory, or by writting out an event.
+ * doorbell. Each request is completed by either by the MC writing
+ * back into shared memory, or by writing out an event.
  *
  * All MCDI commands support completion by shared memory response. Each
  * request may also contain additional data (accounted for by HEADER.LEN),
-- 
2.25.1

