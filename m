Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1A2448F1
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgHNLkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgHNLkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3777C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f12so8044962wru.13
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnguWj4FHs1wYikfJFD7vPPZkiV7VFRSyv4gDXDI9Cc=;
        b=LbwbzR99qF4HU6fI2SPoxXR8GJqzSwmGkTxEIz81e27IwOWhCZ3RzRHRl4xJVFUNQr
         btIKzVXwXSGX76vYD1mTzdCVFk8kHXH+jG8Anf1IfGeEOFUIvuTeVvSfI2GpP/69rth9
         9wOw8+FUuE3/1qj4RKFWa6GbNzFnjfZEE7moD1Na0ROEfz92cpV6Ddz9/qJaeA/OKa5C
         2YJO/cfUkYlKSC82bdOD8jZHQE8ROKKaUnUkG9QQIlBP1AvZtypcVTiCStJNj7JGtAvi
         iBrnj3ehsK2/gVbc1t9rf4e2FTv/SQF0I5mOf3fde7lj9tvzhTXP9+p95A4uMxwTYA5y
         Vm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnguWj4FHs1wYikfJFD7vPPZkiV7VFRSyv4gDXDI9Cc=;
        b=VzPjSMvMctz9hmvCPoA3ZmDsgIu+YoAb386DDWniGA7cIF++xe/kyl9E/E61u9/lBZ
         rQeBo2qA4FqvCwQV+9Deaq20UITX+pTJk7/Ifb65LwKNr+CfnptYs8/yEAjWBuu/dkzU
         xDqoM/NZdywnjeiHunV6FXTLScSWpaF2PLf/Q1VUMQHCIf47v2f50Jj6kOICSMgtMPAx
         vzJ5iuoCVmCpqZ2Y+POzAyVmWbLggSFXbDwr1OjiGljWHYPWnsgxnK9V18fKsW1T2H3D
         hJnXHyUQrQj/ZNBGRtIR3Y9OvaGIUTQFUk6Do/kYwa6yL2TtDk6G6AFTic+pT5Uit1e2
         sSpQ==
X-Gm-Message-State: AOAM532Ral5k/1AXsUx7nyrpj/c18RiLeod3hRdqkedlZo9Za82I5fTW
        Hkd5knduluEyzGUjTL4phKiOhw==
X-Google-Smtp-Source: ABdhPJyrFm2IJE+dW3RmSSuvxilQRcnMe1Nv2aAQ0ti216Z6KJ523ZMQHOLSTEVhi8tpXM9IHVtFjQ==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr2369257wrp.412.1597405223679;
        Fri, 14 Aug 2020 04:40:23 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH 28/30] net: fddi: skfp: cfm: Remove set but unused variable 'oldstate'
Date:   Fri, 14 Aug 2020 12:39:31 +0100
Message-Id: <20200814113933.1903438-29-lee.jones@linaro.org>
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

While we're at it, remove some code which has never been invoked.

Keep the comment though, as it seems potentially half useful.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/cfm.c: In function ‘cfm’:
 drivers/net/fddi/skfp/cfm.c:211:6: warning: variable ‘oldstate’ set but not used [-Wunused-but-set-variable]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/cfm.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/fddi/skfp/cfm.c b/drivers/net/fddi/skfp/cfm.c
index e9bf42996de83..668b1d7be6e23 100644
--- a/drivers/net/fddi/skfp/cfm.c
+++ b/drivers/net/fddi/skfp/cfm.c
@@ -208,7 +208,6 @@ void cfm(struct s_smc *smc, int event)
 {
 	int	state ;		/* remember last state */
 	int	cond ;
-	int	oldstate ;
 
 	/* We will do the following: */
 	/*  - compute the variable WC_Flag for every port (This is where */
@@ -222,7 +221,6 @@ void cfm(struct s_smc *smc, int event)
 	/*  - change the portstates */
 	cem_priv_state (smc, event);
 
-	oldstate = smc->mib.fddiSMTCF_State ;
 	do {
 		DB_CFM("CFM : state %s%s event %s",
 		       smc->mib.fddiSMTCF_State & AFLAG ? "ACTIONS " : "",
@@ -250,18 +248,11 @@ void cfm(struct s_smc *smc, int event)
 	if (cond != smc->mib.fddiSMTPeerWrapFlag)
 		smt_srf_event(smc,SMT_COND_SMT_PEER_WRAP,0,cond) ;
 
-#if	0
 	/*
-	 * Don't send ever MAC_PATH_CHANGE events. Our MAC is hard-wired
+	 * Don't ever send MAC_PATH_CHANGE events. Our MAC is hard-wired
 	 * to the primary path.
 	 */
-	/*
-	 * path change
-	 */
-	if (smc->mib.fddiSMTCF_State != oldstate) {
-		smt_srf_event(smc,SMT_EVENT_MAC_PATH_CHANGE,INDEX_MAC,0) ;
-	}
-#endif
+
 #endif	/* no SLIM_SMT */
 
 	/*
-- 
2.25.1

