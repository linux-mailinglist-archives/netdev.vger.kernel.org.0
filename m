Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0D244926
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHNLnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgHNLkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:01 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD7C061387
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:00 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 3so7677976wmi.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cxyYXnUUCZhHe8dpcSTNmo6M+HTgfG9I0aeJsix4sR8=;
        b=kOVFd+EKRHcOgiD8HFwFx0XNWvK5zXgOqGzWPcdwz7L45SP9KAQmTDuRgMEtDIWvWC
         KGy9FZZYUL0hSY1ceRAgUrsIPIdDQn+32RHicdNLMUHSBm3xElj7w47D3lnM8c0afIPG
         S7doL6pvSFEsK7TSBsbr64SJrCktcAl7x6l7C65t1dkMvqmvd8gC1eNKQOx5K5xJpb7b
         ysp+60MAN7Ox3BXtQNYCxDLOXGp3dPRn/1KCMDwnJ/xsv7XV1bMdfZ0U7PmHnIlo0aPM
         ONSPBgUPZLPHemsi/5HkM/Ah2dpCXv5IgY7DsVoFp1chYugRMuxkuEo64po9G+3khXp1
         CCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cxyYXnUUCZhHe8dpcSTNmo6M+HTgfG9I0aeJsix4sR8=;
        b=Rv3yIXfLURTfgcXA3B52sxx89InPnUEt4tL9sWz10PKIPZnaHGLUy4+ibCrorx2W9R
         cQc0v6E9e2FWsYJacNVuTZAZOy+lhY8DwhgIRQe0MOKSypmMf0IhHfVIaqm/L0ZNHHBC
         Jp7J5UHp9LWsikWaW3+icbvhNE0R4gwCo1Ghqoaik8GZEcSw753qEQXnpJi6eOPxmNYS
         G28B6373rp0kT4e6cZmUQD2mi3rg3oBBNa/yPvkEx0hHjYP+CiB6rAcUuFzfgFtPqcXp
         536bXYzSLH1svayNVEpJKPPes2zPBwgCrt4Rt0dsmAt1WRn2sVBP7XAjta4Xk21O4po9
         wDSA==
X-Gm-Message-State: AOAM533CupQh5Jp4dzfXje4p+WI948qKo9CDrLXz5XsHSVIq0XqOTdkT
        hzzj6owBmnud4YfRv7xdJNjztw==
X-Google-Smtp-Source: ABdhPJx8WHD9X6aqfdX1cuW9YJJqmiV+LKBUDjkV6yfghTL0ztl5sgx19ZXXSWtlxSgA6tCjQrrh6Q==
X-Received: by 2002:a7b:cd97:: with SMTP id y23mr2284684wmj.21.1597405199406;
        Fri, 14 Aug 2020 04:39:59 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        Fabrice Bellet <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/30] net: wireless: cisco: airo: Place brackets around empty statement
Date:   Fri, 14 Aug 2020 12:39:14 +0100
Message-Id: <20200814113933.1903438-12-lee.jones@linaro.org>
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

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/cisco/airo.c: In function ‘airo_init_module’:
 drivers/net/wireless/cisco/airo.c:5663:21: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Benjamin Reed <breed@users.sourceforge.net>
Cc: Javier Achirica <achirica@users.sourceforge.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Fabrice Bellet <fabrice@bellet.info>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/cisco/airo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 316672486d826..8002a4268e03e 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5659,8 +5659,9 @@ static int __init airo_init_module( void )
 	for (i = 0; i < 4 && io[i] && irq[i]; i++) {
 		airo_print_info("", "Trying to configure ISA adapter at irq=%d "
 			"io=0x%x", irq[i], io[i] );
-		if (init_airo_card( irq[i], io[i], 0, NULL ))
+		if (init_airo_card( irq[i], io[i], 0, NULL )) {
 			/* do nothing */ ;
+		}
 	}
 
 #ifdef CONFIG_PCI
-- 
2.25.1

