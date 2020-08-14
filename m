Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299D244910
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgHNLl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgHNLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38B6C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c15so8038349wrs.11
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Db0/XegKOvDRgZ77poJrd7OK4ys0Vj7FE0VspABfIc=;
        b=c3oazDInGW7hjrBIsl+zkAlUf5XdaIpPfFz3xERqVymAskbwi16DPAktyD53jA3b66
         /VOUQgRQ6z4vBQOCkHrfsvmGX69PCEy7jMg5cYGTAN/BKeMSg1aFyX6u1JgYhY/wofRP
         AjLQ2/OgQciCs1lQvFlym5gCyLc5UElaSt+nCxIIt0GrxXFIHEO19882b+DHL24RcpNs
         PlLlaG8OWAcbN1yTgVP4CABv2rSyGGMMwqzTawWPQTJwLSIGKGm+asMO19fjIT2BXKjP
         eaWwSPDyMvcL9trE/s3Hp9dQl/io/SIae6+GP2aGpowdN/RiSUqjTfZ4re4x9uCX+ZVq
         wnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Db0/XegKOvDRgZ77poJrd7OK4ys0Vj7FE0VspABfIc=;
        b=aLm1CJOU1FX3nzfRJuF0TUTsHu8QzMR6f7ZXFQV920BLNyz67gmoqidB8VAjpZ1ni1
         ZW0F/JEyHUMjVuxMhb+871UKAt5500BC20i7FmST16eUU/YGz4efWNiIx5WgfrqKM2XQ
         OHJfIX3S6Abcc20P/wzBK5gHr8GbXoACZSyWf5FXe3ia55leSwk/WQHcquvRn3vPvq2d
         AyvkI10aWTtnLEOsK1Sz++cDvXCYgiyiYs0RwC0ewU6OcYxK8P6dmbXxjqlrIwhRb9Nz
         WamK+MSa1LhXJ32djaEXAKYizqcF4sGPfZ9EN1bMu0TXG7iAcSf3skJJ3kFCVaak0Xyx
         lglg==
X-Gm-Message-State: AOAM533yxFRTBWlaj2avo0Z4x3hDurosYoaZjOyU129osjDHZGFqEvWO
        PEdC07nfEUQAonJeuHXfE6zB1Q==
X-Google-Smtp-Source: ABdhPJy2TwazZiHw6gMHYPOVlPScYRlKeMGm2BnOOf+FwnWaIAiGUOP2+xsysshx48ue6Viw0BB5gA==
X-Received: by 2002:adf:ea0c:: with SMTP id q12mr2302330wrm.382.1597405210454;
        Fri, 14 Aug 2020 04:40:10 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 19/30] net: fddi: skfp: fplustm: Remove seemingly unused variable 'ID_sccs'
Date:   Fri, 14 Aug 2020 12:39:22 +0100
Message-Id: <20200814113933.1903438-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is present in many source files and has not been used
anywhere (at least internally) since it was introduced.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/fplustm.c:25:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/fplustm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/fplustm.c b/drivers/net/fddi/skfp/fplustm.c
index 02966d141948f..4cbb145c74abb 100644
--- a/drivers/net/fddi/skfp/fplustm.c
+++ b/drivers/net/fddi/skfp/fplustm.c
@@ -21,10 +21,6 @@
 #include <linux/bitrev.h>
 #include <linux/etherdevice.h>
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)fplustm.c	1.32 99/02/23 (C) SK " ;
-#endif
-
 #ifndef UNUSED
 #ifdef  lint
 #define UNUSED(x)	(x) = (x)
-- 
2.25.1

