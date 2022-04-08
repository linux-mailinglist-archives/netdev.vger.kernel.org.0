Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AF4F923F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiDHJvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiDHJvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:51:12 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2BB7B12E;
        Fri,  8 Apr 2022 02:49:09 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id a5so7088636qvx.1;
        Fri, 08 Apr 2022 02:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyivuL+H/KVvw4ETMJbVptbzdvfFa7VP+WwXUbdL0Nc=;
        b=hkHZGbWCPb1meWOq6C5/Qy3oM4W71e9qlgNE/OBDQ2OHY+ZgeMGqw/Uz5Jz10s1QkG
         LU5ojG0d9pLp/TmWKkn7yw41146cY7w10d2iBqXTuDSeFKRDfNZ/2gG1hL2mHn4gF3Y1
         9UsJUCenWHAL8VN6dKEqC1XPh0nHoHnnGlU7MBdrcT+JjafChkiHZzelEvCTG38qILil
         osVzfOC2pUHMcszyT/Qu/BjmXYAn4+CAIawsr21mvmLY45qa2nwuj2d6lLzBc7vJX3tQ
         u36WTpO+j2hemwEZqcJyo3cUbpCOgr87i3uUbDLNqxo2YfNjB7HvA+qBkGCfIu62hC/Y
         aCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyivuL+H/KVvw4ETMJbVptbzdvfFa7VP+WwXUbdL0Nc=;
        b=qVWtXG/KGfmbvOkV7ThtHjcaeP/V8Hl5s/cAGnAFhVugRblyCBVFEDuqNuaUjcysDK
         eYLuABAOr8V+Xh3cUWEYQQdscKcOdcLOsQqVAafciXmwwTurhFz9aVN371qR76PdzfYJ
         TZMKiz38OWX5pEKcNtN+lkGZdKO7qvZqkuONgRsUP6ptAg6xIJXC4JTNms4i/VfnIRXI
         VZmwAdynA++mkkJ1svzk32K7DLTYIE55mnqIXo8dFk1O57L5KPq5W1Stos+vVDlPEj3P
         BfAq8JDk9eHR0NESd86tmHTjvk8uLNvOfQZuPBI51YRt1Y7Dx1Pyh4cD+6TKjXmZlWXq
         uYRA==
X-Gm-Message-State: AOAM533RjEv/FJqcHm1lWr8CqNR2i7yYP+yI+XBaYKbJiYr9NmxLjZtQ
        AGB6gqbt95+doZl4udoIfMk=
X-Google-Smtp-Source: ABdhPJw+AzhYq5o+3tcf50RJR18Jc0XaqAgBIBK6xPZ3+u8mZQmD3cTCE32nOnX1RitjfH8f0HRAWg==
X-Received: by 2002:a05:6214:2388:b0:443:865c:5623 with SMTP id fw8-20020a056214238800b00443865c5623mr15088510qvb.72.1649411348459;
        Fri, 08 Apr 2022 02:49:08 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b13-20020ac85bcd000000b002e06856b04fsm18352455qtb.51.2022.04.08.02.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 02:49:08 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     aelior@marvell.com, skalluru@marvell.com
Cc:     manishc@marvell.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] bnx2x: Fix spelling mistake "regiser" -> "register"
Date:   Fri,  8 Apr 2022 09:49:01 +0000
Message-Id: <20220408094901.2494831-1-lv.ruyi@zte.com.cn>
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

There are some spelling mistakes in the comments for macro. Fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
index 881ac33fe914..4e9215bce4ad 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
@@ -2212,7 +2212,7 @@
  * MAC DA 2. The reset default is set to mask out all parameters.
  */
 #define NIG_REG_P0_LLH_PTP_PARAM_MASK				 0x187a0
-/* [RW 14] Mask regiser for the rules used in detecting PTP packets. Set
+/* [RW 14] Mask register for the rules used in detecting PTP packets. Set
  * each bit to 1 to mask out that particular rule. 0-{IPv4 DA 0; UDP DP 0} .
  * 1-{IPv4 DA 0; UDP DP 1} . 2-{IPv4 DA 1; UDP DP 0} . 3-{IPv4 DA 1; UDP DP
  * 1} . 4-{IPv6 DA 0; UDP DP 0} . 5-{IPv6 DA 0; UDP DP 1} . 6-{IPv6 DA 1;
@@ -2381,7 +2381,7 @@
  * MAC DA 2. The reset default is set to mask out all parameters.
  */
 #define NIG_REG_P1_LLH_PTP_PARAM_MASK				 0x187c8
-/* [RW 14] Mask regiser for the rules used in detecting PTP packets. Set
+/* [RW 14] Mask register for the rules used in detecting PTP packets. Set
  * each bit to 1 to mask out that particular rule. 0-{IPv4 DA 0; UDP DP 0} .
  * 1-{IPv4 DA 0; UDP DP 1} . 2-{IPv4 DA 1; UDP DP 0} . 3-{IPv4 DA 1; UDP DP
  * 1} . 4-{IPv6 DA 0; UDP DP 0} . 5-{IPv6 DA 0; UDP DP 1} . 6-{IPv6 DA 1;
@@ -2493,7 +2493,7 @@
  * MAC DA 2. The reset default is set to mask out all parameters.
  */
 #define NIG_REG_P0_TLLH_PTP_PARAM_MASK				 0x187f0
-/* [RW 14] Mask regiser for the rules used in detecting PTP packets. Set
+/* [RW 14] Mask register for the rules used in detecting PTP packets. Set
  * each bit to 1 to mask out that particular rule. 0-{IPv4 DA 0; UDP DP 0} .
  * 1-{IPv4 DA 0; UDP DP 1} . 2-{IPv4 DA 1; UDP DP 0} . 3-{IPv4 DA 1; UDP DP
  * 1} . 4-{IPv6 DA 0; UDP DP 0} . 5-{IPv6 DA 0; UDP DP 1} . 6-{IPv6 DA 1;
@@ -2529,7 +2529,7 @@
  * MAC DA 2. The reset default is set to mask out all parameters.
  */
 #define NIG_REG_P1_TLLH_PTP_PARAM_MASK				 0x187f8
-/* [RW 14] Mask regiser for the rules used in detecting PTP packets. Set
+/* [RW 14] Mask register for the rules used in detecting PTP packets. Set
  * each bit to 1 to mask out that particular rule. 0-{IPv4 DA 0; UDP DP 0} .
  * 1-{IPv4 DA 0; UDP DP 1} . 2-{IPv4 DA 1; UDP DP 0} . 3-{IPv4 DA 1; UDP DP
  * 1} . 4-{IPv6 DA 0; UDP DP 0} . 5-{IPv6 DA 0; UDP DP 1} . 6-{IPv6 DA 1;
-- 
2.25.1


