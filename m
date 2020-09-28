Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D528227B7B4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgI1XOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76AFC05BD1B
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:59 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so2929670ion.3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LnfICc5M/Xe5Ap7kkbr86ZPlX06r5/7j/GM9O+SpMeA=;
        b=VFmK0cyh8nWjDtjn4+0k5DFmabsAYLaKCKtVlZ1GNh9bUHeC3lj+vrqk8hN42zQO/p
         OCWK4VPSeOnev1YnCfLyhDmXq2px0oWxXHt8SJtXyJWBxEk981npCLT1LBOFkBPdM40z
         mV6GwrYRc+dEKDibGOzhpFQ58uWx7qVWfaAmen76ho+L7S15q10GRuEOF6Ueqc050n20
         03sGV3tl98zJjKXvBbMgLQfqNIT9lveYgoUnTNQ62VeU6duwSyJKbbg4Q1Ir/2x/XZJM
         6U/vOx59o9UUsxHcFBnAvyAC5FQZtBsyPZHGr7Vff4wLyRXQ43/9r76H284/srA9s0/L
         BTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LnfICc5M/Xe5Ap7kkbr86ZPlX06r5/7j/GM9O+SpMeA=;
        b=KeaxDldE++fzH57gsfkVZODwhVT0/JV5XaouII2yaxM7Pxugfl19OeENQ1IIfaFS5m
         YCeEzqSUtESFBLU5CgAt5l3O6s75E6m0ucgDcoyRqbd7utvZCtUxukP+r0758qwNSulQ
         Ko9ffvbYaCPuIVKFxM9SuvJMgOb0bI4M/lJU+qGnWPD7N5crM/dhT242dFXfFM5kJCa8
         U4RC9gDV408vvUPrSpKYSvD2U2Mj6Kt3weErYJlvFATQ8OMNBkNZz/e8ICcNNSQUNcWM
         b+W1GlFCzqKJcYJydvxhPTsB+drkcaOGoU3kulpBJTITdhGNDOoOMX+YALFcoWVuHmuN
         7rlw==
X-Gm-Message-State: AOAM530Mxm/XkEz4QyXWdkAI/Pb9auc9M8TwiAC0lUx6Zip8MWt8Hrwg
        0FY85nR0hKYFy6jtng2mQB7lQQ==
X-Google-Smtp-Source: ABdhPJy72s7vFebZ+/vcYxm2Hyf8iX43KdaADIFyN7QVnDc7mG4VVfiFAusfNwiShCHkrNcu7YUYZw==
X-Received: by 2002:a5d:9693:: with SMTP id m19mr395805ion.161.1601334299145;
        Mon, 28 Sep 2020 16:04:59 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:58 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/10] net: ipa: rename a phandle variable
Date:   Mon, 28 Sep 2020 18:04:45 -0500
Message-Id: <20200928230446.20561-10-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "W=2" is supplied to the build command, we get a warning about
shadowing a global declaration (of a typedef) for a variable defined
in ipa_probe().  Rename the variable to get rid of the warning.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 1044758b501d2..cd4d993b0bbb2 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -723,8 +723,8 @@ static int ipa_probe(struct platform_device *pdev)
 	bool modem_alloc;
 	bool modem_init;
 	struct ipa *ipa;
-	phandle phandle;
 	bool prefetch;
+	phandle ph;
 	int ret;
 
 	ipa_validate_build();
@@ -736,13 +736,13 @@ static int ipa_probe(struct platform_device *pdev)
 			return -EPROBE_DEFER;
 
 	/* We rely on remoteproc to tell us about modem state changes */
-	phandle = of_property_read_phandle(dev->of_node, "modem-remoteproc");
-	if (!phandle) {
+	ph = of_property_read_phandle(dev->of_node, "modem-remoteproc");
+	if (!ph) {
 		dev_err(dev, "DT missing \"modem-remoteproc\" property\n");
 		return -EINVAL;
 	}
 
-	rproc = rproc_get_by_phandle(phandle);
+	rproc = rproc_get_by_phandle(ph);
 	if (!rproc)
 		return -EPROBE_DEFER;
 
-- 
2.20.1

