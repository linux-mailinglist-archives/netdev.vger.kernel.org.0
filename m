Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE69E4B32A7
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiBLC0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:26:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLC0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:26:41 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B48E9B
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:26:38 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id u13so11607455oie.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqISH4uk8J9YDKfuBM69e8NIPmkIFeVxfAObmLkZpRI=;
        b=JvBQcjiOceu5Cn0RVdFGUhmNO4VlNtuWJzvbn6DKUQD6gCbL89hpC8eU3RydMadib3
         T+0/yofatCktava/TguH3nK9J5o7dvWK9kvlTRTrr/yWmTbzjNF7lV1bOyioIw90HBI1
         aelp0b/zYm9dLGESwgw9uMcuOadpRcZRlN9WEviiBcY9Imr4gfOr6tIOlxVgyZVEHWxK
         VhblRDC94QT5uiXa24fIdH+wyjbE4O9jnudCptZqueCTRUGO09n6qpau5ay4wK0bAycL
         Ni00mMDIiYDVD80GKKCLnJqCDKSt2qOs2qU9OvppnX/9IXrwee07iPM7kYbIn6ay1NL+
         fBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqISH4uk8J9YDKfuBM69e8NIPmkIFeVxfAObmLkZpRI=;
        b=0QkVlw1mURJ1rODk/T0g8IGSjhQXEQYB2pHLF2PxcIkXcv337GLF3Jz1Xdh+iSLc/l
         u1VM4IJgiLhjvSlOPTMJnFByLUfvV3pUFet81sXMuSNvWK5qcUe/NOXmzzN+r/mbQ4Z3
         K2pEj7C9d4X7VCEwGjweJzp+y6psP7Rv+Dwr1+XooPbl630uUkMJkg2Ioh7+gq/i0kKm
         1kUQEty8VkPu6KYssSXLNZAKtvJEHpsFxSrGPjsfuaCzKUiXL95x/84P96J/4/4Twpxq
         F4wKdmG9xq0BZqJ8gJ8cMOri2QJFTonnBsJiHMF2rB8cLOo7CNt60E/YT7yc1uKCXUjH
         UbbA==
X-Gm-Message-State: AOAM531aeM+ybQVCBJgKy/XJdv8h0GH9CGnOzh+eBbfp0tRF9vEYmTUf
        ZieO1zdl8Z99/jfERKQkicLsl4glBThMUA==
X-Google-Smtp-Source: ABdhPJyyyk+0toqO15oR22HHKj0/04GoO2CsvGCDtmQZVi1WolZcVcRXQvPNIF2msHYTqhyzx0z31w==
X-Received: by 2002:aca:220a:: with SMTP id b10mr1507170oic.273.1644632797801;
        Fri, 11 Feb 2022 18:26:37 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id s3sm10768495ois.19.2022.02.11.18.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 18:26:36 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: realtek: rename macro to match filename
Date:   Fri, 11 Feb 2022 23:25:34 -0300
Message-Id: <20220212022533.2416-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The macro was missed while renaming realtek-smi.h to realtek.h.

Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index ed5abf6cb3d6..3512b832b148 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -5,8 +5,8 @@
  * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt.org>
  */
 
-#ifndef _REALTEK_SMI_H
-#define _REALTEK_SMI_H
+#ifndef _REALTEK_H
+#define _REALTEK_H
 
 #include <linux/phy.h>
 #include <linux/platform_device.h>
@@ -142,4 +142,4 @@ void rtl8366_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 extern const struct realtek_variant rtl8366rb_variant;
 extern const struct realtek_variant rtl8365mb_variant;
 
-#endif /*  _REALTEK_SMI_H */
+#endif /*  _REALTEK_H */
-- 
2.35.1

