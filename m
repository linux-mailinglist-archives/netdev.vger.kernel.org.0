Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C744250DDA7
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiDYKOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiDYKOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:14:22 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6448CDE
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:11:18 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 4so3621185ljw.11
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NknWGo+35JEwhYOnMtzefDe7HwL5J95MApEJDangBw=;
        b=K/l/2GXpQ2StTGjc9+/yRtaawiRjmldlhTsm6pxdlTKEDfXt9k3rSidQ8JgDxuWFPT
         V6m8XfAkFPjE9TzhqRZaIPUF7ts6eBc8rvdaCX3GpHE2ZgcKTyvZ/eMIIK6K3tJx1nMD
         Uk1vmhu9f9Y96WrKkd1bR1qPYGVqOrVxNmj86/EyQ67vybNSUeVk0uf8UqxmMeUG7ihN
         6MAK3Ppfbi0/jELzoGDBDEnToV/TezItmpH4fZ3ZJQIto8Dxv5XEfXqag8iz5Du6ea/8
         gFc2y+9gq4IdkZw9TYt9MA4BP50nQiAjKHbBhJGdHnmQMD/sGx+FSlpTa/h91pFIaQkB
         Znaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NknWGo+35JEwhYOnMtzefDe7HwL5J95MApEJDangBw=;
        b=j7QdRT9EFt4QogS0UWh4+hzcisM+5L7eYD4DMcLh/trCoGBiy5R5Y0yy3CHBPlEhFV
         ZSKtI31wDwKiwsJBW3JUz+TCLIIocS1oZywAPExwlS8fvIv3Qi56JIwGfo3AA9A8XMAt
         PALMGj7RKtHAInA3vHfJSpMbwKyF05MePEmU0BXMFZqmm5yV/72F5Gwgf5QxWoPEkv/P
         A1u4mnja/sqTzLJZqVZYysvnPoo4EZ4EY2Cfx1giQR64hO0yEcdRJJuIhtViGmcolwA2
         nnHf2WiOmxuX+I20rJJiFBORdfGGwvLKuYY97ACbT/Axh1WqGZPgzfHenJ0fDiGO7FK4
         Ycyw==
X-Gm-Message-State: AOAM533vb3r127SoM8pgEg4ipr+0ljkxoImSylFA4DlKCHxbz6GrufUz
        eIk0z86RGHVSvW638VVuG1LZXw==
X-Google-Smtp-Source: ABdhPJywPIhVLwkEkoCnHeuxN308eHWJhhXhvWF4W+0d4SyArqh6h53CS4QfT0Aci23/62XkSh2ZIA==
X-Received: by 2002:a2e:934f:0:b0:24f:ea1:6232 with SMTP id m15-20020a2e934f000000b0024f0ea16232mr3960527ljh.135.1650881477056;
        Mon, 25 Apr 2022 03:11:17 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id t25-20020a19dc19000000b0044a16b068c7sm1366583lfg.117.2022.04.25.03.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:11:16 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        upstream@semihalf.com, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH] net: dsa: remove unused headers
Date:   Mon, 25 Apr 2022 12:11:02 +0200
Message-Id: <20220425101102.2811727-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce a number of included headers to a necessary minimum.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 net/dsa/dsa.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 89c6c86e746f..0c6ae32742ec 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -7,19 +7,10 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
-#include <linux/of.h>
-#include <linux/of_mdio.h>
-#include <linux/of_platform.h>
-#include <linux/of_net.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
-#include <linux/phy_fixed.h>
 #include <linux/ptp_classify.h>
-#include <linux/etherdevice.h>
 
 #include "dsa_priv.h"
 
-- 
2.29.0

