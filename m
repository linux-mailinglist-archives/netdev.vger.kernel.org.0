Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9541A654CEE
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiLWHlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 02:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLWHlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 02:41:44 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E1EE023;
        Thu, 22 Dec 2022 23:41:42 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c13so2814378pfp.5;
        Thu, 22 Dec 2022 23:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mjHx60lzDi31ut3FVWn/hwqUkJUg+i7XPzxE2mbHkvs=;
        b=AnN2FCwL0eg5ZRLN07A/u5rubdrvs7tuFaIgYBYscw01xU8qALAAWnyNztAH9Y8Egi
         kVu6S/fmJCr7pmZ0adYIj29zCHR3w5/4zbW/K+V2VYFm9VnLK/IQFt57+f3YpDhSKvXU
         Lz1l8y5eLjCnwu2GE5MpnYnvjIP3EPgyJu/+xsT/G/VFyfsD1iR2BjVg9TjzYk9nRmHt
         GlYFufSOzTHEVvfMWnOesyOiE+EqgdU8G2yuFw1+UHWt0jmN04c8mzstDNpdGwZ5Jr68
         xH60m8nPmRnxDU1D3A9ynJkGcIwXoNTi7/mSleJCYv7lldAd8ykIqzShCJFYiM80TIlX
         rTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjHx60lzDi31ut3FVWn/hwqUkJUg+i7XPzxE2mbHkvs=;
        b=N9dN972oAN7yOWqE+YE5BXsvnpLV/2Q5ZglpF8znwVqR0BRQLmuRN//j4jlSPqEmuy
         g6ok3XbxQkZGuQIAxh9zU8u1XmXdvOIXDbs6Jof3VZLpyS0r8R15eckizmDrsomphEEo
         CKl6u7EeGOtWj++Yq4WZij+fhK8HT2uW4CH67w3V0q2rSwPfeKqd3RWVDPfxlU7b1I5I
         w0HJQ4Yx7CKaR/JN+TvyUVjIUl1bjbDxnZ3+LDMrY8RSwGng5BwHs7tS6U2M6kw8unKt
         FFTQ4TxMKq3WUuF7vLYNgsChSkSv9Dt3Ycb+1rUIVmX8aZoxhKr1Zs57XqXQ2T7W8VWn
         +QNw==
X-Gm-Message-State: AFqh2koshragr7XChCrpR+Gi16fVJEHQVn91yYubvIHDVbG8/6+dvDBV
        jZKf5rA6hfZcwXA2xEesQgiDqaFQ0kA=
X-Google-Smtp-Source: AMrXdXudLvGXkodN2YfxiP7XvoSN5Nh8fKGv3XnleLO/t9lN4yHKvPIUDrr4/SRtBju9eWRj/otEIA==
X-Received: by 2002:a62:1855:0:b0:576:e1f0:c812 with SMTP id 82-20020a621855000000b00576e1f0c812mr9313716pfy.30.1671781302080;
        Thu, 22 Dec 2022 23:41:42 -0800 (PST)
Received: from masabert ([202.12.244.3])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79ae3000000b00574c54423d3sm1891762pfp.145.2022.12.22.23.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 23:41:41 -0800 (PST)
Received: by masabert (Postfix, from userid 1000)
        id 8ED882360416; Fri, 23 Dec 2022 16:41:39 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     3chas3@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] atm: iphase: Fix a typo in printk message.
Date:   Fri, 23 Dec 2022 16:41:35 +0900
Message-Id: <20221223074135.150076-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a spelling typo in printk message.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 324148686953..aea5fc4c206e 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -549,7 +549,7 @@ static int ia_cbr_setup (IADEV *dev, struct atm_vcc *vcc) {
           if (testSlot >= (int)dev->CbrTotEntries) { // Wrap if necessary
              testSlot -= dev->CbrTotEntries;
              IF_CBR(printk("TotCbrEntries=%d",dev->CbrTotEntries);)
-             IF_CBR(printk(" Testslot=0x%x ToBeAssgned=%d\n", 
+             IF_CBR(printk(" Testslot=0x%x ToBeAssigned=%d\n", 
                                             testSlot, toBeAssigned);)
           } 
           // set table index and read in value
-- 
2.38.1

