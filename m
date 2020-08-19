Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E36B249773
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgHSHai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHSHYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF32DC061344
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p20so20472977wrf.0
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4oTMRepDWAwvEG4gP7KM4XWzXr1eKKBuCn5XU6f/p3c=;
        b=xQMDxP40oi3eBNc7Z3Xh8ZZ0nMN8DIhN4T8xH85Xsm9iNdWmnZXm/ZacjDGeA5/lZp
         8J9KeASsvVw6L9nuo/M08nb8BL6pxwOzjKxpv3VR1E2sgB9PQE5PVpiBgR0WNSMBzLwe
         C2+pRvFC194BLywESVmUchHD+cAbjWSp0xJkjNQE0D/EHQg3dCa6eMy8eSmSMtKxQHH3
         eVYlDOWMnc3D4GluUOh+YHHuNhJ6N/1ECcenz13QCZ3y1E4jZJ/1hhMUuFtxbBS1dw9h
         Nd88JhHg5VbirFMOeN4O8YWOuaD+5rLX5+RVZykRnjnNpD7+/RRyIQ8xuJyJvcAEjI0d
         B6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4oTMRepDWAwvEG4gP7KM4XWzXr1eKKBuCn5XU6f/p3c=;
        b=kyqv3IgnI+NYvuYoPlwZ6F54U16zrOmuU9qYSrKowj83w5/wpeKDvImRBbw3yBITzY
         yYeMEZMtIXSdu+pWRhsj5mCVZ7wa4X0wIQmtC/3SNzQLp5PLt1kuSOTy+S98l/3L+iKA
         VAOuvjmsimUI94tq7cRbPiSFe8jyBhQvvQFibLF2Eex/2n/NJ/aVQYYnOZ7DAiX+2G/T
         ifhFiDxj9zlwX/TwDx3whhwmAtGgcAAK5DIeSFIgn6N+HUWzKz8rGUfIoIZSfXVdY+ui
         pH/Z1EsPqFwXYU60pxphUCHXsZxonR3NzpGF9p4H21+5ZWqyCgl2TaCEf47w9VNJ9npE
         3HMA==
X-Gm-Message-State: AOAM5310PIu0pr3dvGDaoNTjYTPxzjChXMmyqsFYOsTVZ2mhMe0QEbW0
        4opyr3Wpx4Z80Y7GWcS741My64I6IzDU3g==
X-Google-Smtp-Source: ABdhPJz4i/nOOv5dyCQ2pLbOgF5zC3v94kASka1DzykL10DVWGIgCT/Y9WW0yTSg2OuK7xwmQmfTJQ==
X-Received: by 2002:a5d:6992:: with SMTP id g18mr23221572wru.15.1597821846494;
        Wed, 19 Aug 2020 00:24:06 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jouni Malinen <j@w1.fi>
Subject: [PATCH 01/28] wireless: intersil: hostap: Mark 'freq_list' as __maybe_unused
Date:   Wed, 19 Aug 2020 08:23:35 +0100
Message-Id: <20200819072402.3085022-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'freq_list' is used in some source files which include hostap.h, but
not all.  The compiler complains about the times it's not used.  Mark
it as __maybe_used to tell the compiler that this is not only okay,
it's expected.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/intersil/hostap/hostap_80211_tx.c:9:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
 In file included from drivers/net/wireless/intersil/hostap/hostap_main.c:31:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
 In file included from drivers/net/wireless/intersil/hostap/hostap_proc.c:10:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
 In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
 from drivers/net/wireless/intersil/hostap/hostap_cs.c:196:
 At top level:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
 In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
 from drivers/net/wireless/intersil/hostap/hostap_pci.c:221:
 At top level:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
 In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
 from drivers/net/wireless/intersil/hostap/hostap_plx.c:264:
 At top level:
 drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]

Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intersil/hostap/hostap.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap.h b/drivers/net/wireless/intersil/hostap/hostap.h
index 8130d29c7989c..c4b81ff7d7e47 100644
--- a/drivers/net/wireless/intersil/hostap/hostap.h
+++ b/drivers/net/wireless/intersil/hostap/hostap.h
@@ -8,8 +8,10 @@
 #include "hostap_wlan.h"
 #include "hostap_ap.h"
 
-static const long freq_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
-				  2447, 2452, 2457, 2462, 2467, 2472, 2484 };
+static const long __maybe_unused freq_list[] = {
+	2412, 2417, 2422, 2427, 2432, 2437, 2442,
+	2447, 2452, 2457, 2462, 2467, 2472, 2484
+};
 #define FREQ_COUNT ARRAY_SIZE(freq_list)
 
 /* hostap.c */
-- 
2.25.1

