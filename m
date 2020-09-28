Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251CE27B7A4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgI1XOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgI1XNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8C7C05BD1D
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:05:00 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z13so2900296iom.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NuGxB8yCQyfl8m9V0CkWYOyAigdUp2kf6vGRj1Y/jrw=;
        b=AHKwTPsgH48I27z39EKzCiQpSUcgI9O2yF9awvt4BWhO00wPb6NYSgkbbvGL2O9sZv
         gBhHIpyqjDGrIKYz7l8n/zsIcG/J61NOcxTk9XW7m+40XieeDwFhv82Xn7/CvaLZgq94
         /AGSXOrBQTlA3bOQJuUDx1Zg08Q/ElpKUPQgw6SQwu3YQY+9G4IZpBUpCrXnIuO1acqB
         gEvGa4mw5TyQvZoDUNxaeNADFlYJgnD0bwDhLQeMXbz7ZY4Ne7t6nbk9h4kGcLWCp0Vh
         6D5ZJCiy1IU1TfdNzCvrETqjSLTBFhpU79op8LxidNph01MvCDSNvNcfPiihwo+tWDgS
         Rwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuGxB8yCQyfl8m9V0CkWYOyAigdUp2kf6vGRj1Y/jrw=;
        b=FzrSl3Vy83Nnx+fn/I8axghH0+Mpqhf/svYD7ltUnBT8D67BtSc+jU07ucfcUDMb8g
         1Koqo6fe0piOodAFNGxA4665caM3O3ptahuImwN8QMAbrhxUYZfxAjsQDrOXPNhgURpF
         RDng4EEJ+lNrylckFE6vRXHtHzFPthkOwO47coWEFzQGuQgHGAvQnuEqRU18/wWi0btv
         wto6wIWT81zLvbJrn7sGfLVNlZ2ifclpnJTzy3jS1uce0LIbuf+P5PNXmIbSvAsgYzxJ
         5Xis9RScIk97WjoSzuCgD6IiMvBga3NQuXB9jjsWT5jkYY50+Co+YXpXBdIK/YjlwiwN
         pSnw==
X-Gm-Message-State: AOAM531uFgQ1XYQszSFFHjqVu/QILonYJcJYaiY8Tja4VZtebetJL1gW
        3okykMl1Dv8iUySCTFVnsB+3BQ==
X-Google-Smtp-Source: ABdhPJzZq0Spz0R/vFIJw6h8QtWBPNbOEUYA1B7CjR9GHGj4rLJ/VPVyP8DvOI+F042JknYBH3Kwwg==
X-Received: by 2002:a05:6638:220c:: with SMTP id l12mr708832jas.139.1601334300066;
        Mon, 28 Sep 2020 16:05:00 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:59 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/10] net: ipa: fix two comments
Date:   Mon, 28 Sep 2020 18:04:46 -0500
Message-Id: <20200928230446.20561-11-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_uc_response_hdlr() a comment uses the wrong function name
when it describes where a clock reference is taken.  Fix this.

Also fix the comment in ipa_uc_response_hdlr() to correctly refer to
ipa_uc_setup(), which is where the clock reference described here is
taken.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 2 +-
 drivers/net/ipa/ipa_uc.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index eb4e39fa7d4bd..e542598fd7759 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -426,7 +426,7 @@ enum ipa_cs_offload_en {
 	IPA_CS_RSVD
 };
 
-/** enum ipa_aggr_en - aggregation type field in ENDP_INIT_AGGR_N */
+/** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
 enum ipa_aggr_en {
 	IPA_BYPASS_AGGR		= 0,
 	IPA_ENABLE_AGGR		= 1,
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 1a0b04e0ab749..b382d47bc70d9 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -144,7 +144,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * should only receive responses from the microcontroller when it has
 	 * sent it a request message.
 	 *
-	 * We can drop the clock reference taken in ipa_uc_init() once we
+	 * We can drop the clock reference taken in ipa_uc_setup() once we
 	 * know the microcontroller has finished its initialization.
 	 */
 	switch (shared->response) {
-- 
2.20.1

