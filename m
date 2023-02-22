Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558C769FD65
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjBVVET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjBVVEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:16 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C543466;
        Wed, 22 Feb 2023 13:04:09 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ks17so9672860qvb.6;
        Wed, 22 Feb 2023 13:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4naJ6q2mpV14L328WP+fo6L/bH+sQxAWTU11AMC6vXI=;
        b=WhwDZiE7wEfnzLCFDmjSUe1vNPX0r2yRHZCB6I2Skwu2bS+fRxh9fbtObrWYCj4Pe8
         T1ZHkFLaa+vWIkCtQkKDs9rZDlZ+4ASQf82EG2w87hDefkA+3Ut0Y0c74V/8LqlEHIlA
         XF03Npnf2DKzmZDgRaipTjJSuN+4pEXvZTSoYMMsx2o+LionSQU8GPBz39AF9YvS5BJg
         gjcdwvYmwWOZkzOlCGIEswAjzhJUHNFLTfrMQREzVMUV6XlnTaPegS1poFba9Gwc4iVl
         2940lMK2KG9YOlAHSCURAmRhhtsW+HwiQBYB8j999T8xgWbf1WY4MgLGAfTRTOF/OU2D
         gcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4naJ6q2mpV14L328WP+fo6L/bH+sQxAWTU11AMC6vXI=;
        b=EUySyRq8ZrSx4/Q/ENvZ0uG3T+GeVp17dLlRZkOlFcvhrfXN8cIGwrJlq82kf88olT
         QqxQZZawg1rZz6DLMGgBM80Y3+mBAaFAxJGVBl6EcGdysUMub3PJVgvAstES2IC1B0Ui
         f3JpOe0yOvmLaa/4W7gpNxUUm5s2XFlt0IWJ2ccVMuZ0ZgFDP4TodIrzs6j5HL0ETRZU
         /AbvxxHWmawdkCIDRHIe8zErVtw3kK3WS9HLhVcFMML3KjQDu3+OtFkDxjbX/Hx34dgj
         VftVErTOuKTYUdQQV6/cAFy3Ydlg3PxHj2WCRcNmz5vCrZ46d4lbUpQ/HGDLciCtStxi
         k+KQ==
X-Gm-Message-State: AO0yUKUitb1w4+8iO1Bn8wr5ADtd2XoInuY/33PFdQ5MiDwfDqEW1iWr
        VGRKu2Q1bmUpTv4BWRXwu1AdLK9cttRV0g==
X-Google-Smtp-Source: AK7set/i7giz/p1c7hM+bfagpeW02zvj4KwAUPL9gk7Nu4fQvEjofxx9lXx7ZjIljutZoLeHOm/DFw==
X-Received: by 2002:ad4:594e:0:b0:56e:bf1f:6a9b with SMTP id eo14-20020ad4594e000000b0056ebf1f6a9bmr20668983qvb.26.1677099848320;
        Wed, 22 Feb 2023 13:04:08 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id 128-20020a370b86000000b0073b59128298sm5138333qkl.48.2023.02.22.13.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:04:07 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [RFC PATCH net-next 4/7] net: sunhme: Alphabetize includes
Date:   Wed, 22 Feb 2023 16:03:52 -0500
Message-Id: <20230222210355.2741485-5-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222210355.2741485-1-seanga2@gmail.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
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

Alphabetize includes to make it clearer where to add new ones.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 45 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 127253c67c59..ab39b555d9f7 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -14,41 +14,40 @@
  *     argument : macaddr=0x00,0x10,0x20,0x30,0x40,0x50
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/dma.h>
+#include <linux/bitops.h>
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/fcntl.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
 #include <linux/in.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/ethtool.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
 #include <linux/mii.h>
-#include <linux/crc32.h>
-#include <linux/random.h>
-#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/etherdevice.h>
+#include <linux/random.h>
 #include <linux/skbuff.h>
-#include <linux/mm.h>
-#include <linux/bitops.h>
-#include <linux/dma-mapping.h>
-
-#include <asm/io.h>
-#include <asm/dma.h>
-#include <asm/byteorder.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_SPARC
-#include <linux/of.h>
-#include <linux/of_device.h>
+#include <asm/auxio.h>
 #include <asm/idprom.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
-#include <asm/auxio.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
 #endif
 #include <linux/uaccess.h>
 
-- 
2.37.1

