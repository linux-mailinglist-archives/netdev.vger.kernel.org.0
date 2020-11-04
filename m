Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937BB2A6036
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgKDJID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKDJGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:33 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A27FC061A4D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:33 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k10so19857307wrw.13
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D8A2ZwumcFkzT7gBopGPWFQhxOdjyth3zeXHUUMb4LU=;
        b=n+ihKnyTjnEwQT2qqQcogdXtMTIe5atB10Jq6pn1twwR0/kYkC2Kr6+xyss8eCXcz9
         2HbpeX+vhczhVLIu+hKhJn0TyfMwtIP8L8DdtH+PcdFgj/Kug/u+q3VC0O4YIf5PC78/
         xs7LRni4ory5Un9NLgygd0y/y8RaoA8Mzkqc/VfDEjIHMyDuLH/Tq/h2//H7DYxavy3A
         51IvYGt8mchAFiVNSubG2g0HJ1nnlc7kaqU/00TNNRpTd6u4B5LRIFGTRPvugtogSvg3
         e93uRN+MLdHYsDvmoa7xlBIrgIbkI/MkDxrHb3rzBzyppvQMCXL3yhEGT/KU4SYrJv6E
         ua2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8A2ZwumcFkzT7gBopGPWFQhxOdjyth3zeXHUUMb4LU=;
        b=can67XsUWVssc76uDrVN7DFytzZPaUAiFHxl89YYqSVBT48kiuRrlIVORmmgl3hFh1
         ZTdFYmR1JNP2wprV6pOEMaa6Z8SmIz0Tv+GYKVZop+FG0cLaTdSvHBh2/ZapBYsAzNfC
         Rp9EwlWGQ186PmxRmgDaJYwR5KO25mW/x4Ya2EUwtz1tPlnkAJ6Ls5ZhF11iwapL4bnw
         Az9ci8Rx6akvm4UcX6ECgRt8pbbbucSScAerR0jOvQDFsZi4qPrAKt0FDepMeP5Qr0G+
         xcLSU81UWT6ZprtP6GpriEweizuwEayKArXVBcRUTzfOWqDteB3RIzK0BUuG+qk6vRfo
         mzIQ==
X-Gm-Message-State: AOAM530UoDgemXt5sZbAp4Lq/mQZQk/iigaVHyyJtJKN5Jd9wWFUhmlk
        YhXBn0yx77su5qU2WM4Ga/R8LA==
X-Google-Smtp-Source: ABdhPJxtrIz8nX0D31ibhE0UZs9oinr7sODGkhZPjlhMnN3sK39bw2U99heofu4Rp69Oab82cUkc+A==
X-Received: by 2002:adf:f80a:: with SMTP id s10mr31220660wrp.275.1604480792277;
        Wed, 04 Nov 2020 01:06:32 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org
Subject: [PATCH 07/12] net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
Date:   Wed,  4 Nov 2020 09:06:05 +0000
Message-Id: <20201104090610.1446616-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/ti/am65-cpts.c:736: warning: Function parameter or member 'en' not described in 'am65_cpts_rx_enable'
 drivers/net/ethernet/ti/am65-cpts.c:736: warning: Excess function parameter 'skb' description in 'am65_cpts_rx_enable'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 75056c14b161b..bb2b8e4919feb 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -727,7 +727,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp)
 /**
  * am65_cpts_rx_enable - enable rx timestamping
  * @cpts: cpts handle
- * @skb: packet
+ * @en: enable
  *
  * This functions enables rx packets timestamping. The CPTS can timestamp all
  * rx packets.
-- 
2.25.1

