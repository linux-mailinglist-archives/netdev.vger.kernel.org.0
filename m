Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D184263E2A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgIJHLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgIJG7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:59:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74989C061362
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x23so4473951wmi.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qElmRnHsar7tn4JV1a4MOU4ECliWfWuqmHMN13MnixU=;
        b=ynl5uR9/TghAML8h3nkWxFysaN59Ld5+yQaEG9uUHi0tVn58MpWSSTN1nZwEJbNnDt
         zWqNp0B8x8emHhs6TS0WXNWn1E5ax8L3pGLwjHANK9SbqQxYUv3e0h7lAi3fIcFcyuRh
         2eMaUmYBb7K568PkAqSAY68HyUmV5QoutOvE0qqm8zkOpeC4+dqqryExT2Qa7Fu2sLjE
         gExMNSoYwJUCvSnA2GEyFGcZqshoOWH1Mj+diqfyBGMDZgsYOt8btBL3Nbqv7mRVZXIb
         7tsxg5OcMl2i5Ap+bzm4/vhiHL9Hf7gz7rH1pmjkJ+fCfpLw8Qj9M4Wn/b6QUPYdswDk
         stRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qElmRnHsar7tn4JV1a4MOU4ECliWfWuqmHMN13MnixU=;
        b=Q5Qn3H8oYOPT5GWzDG1V1EZkhM9k28qLWruZ/+4UEPCki98J0BnYdjE7Dm1/M2uF6c
         5EpArPyoTLO6yRsuUY0LEbndik3WT1pQkEzIARHQ15NBgptw5bK8lnK35ilmIuL0QZcx
         xWjg84qf0jsM3jm02PM2BzB7RNTLQJVq7mdDaOmwoS0aIYZqd4LWtBS7/kfeGatzb7OF
         7zJj5OKOmpVzdDfx5V5Xy4vx4LpX1SNlOBMAQKMyKBkFEPss5P59EhjoAZdATAiOIDhK
         BP5nVGBnlkKaUjLZX76e5y40PSeoMXcLaBv1e7X1eRfJD/liK6I9F5Mg/3nN9u9O8NrL
         gULQ==
X-Gm-Message-State: AOAM533gsT+JNMGjCFuiVbF00fwJBoAKVx7hd0dZuAXabsY2NI1cwK1d
        SJqH1T3ZIjz4filFSR2r9KK32w==
X-Google-Smtp-Source: ABdhPJzzSjiC/dmYcdt5jYyoj8A3w2gBjKbM33ESnbSAZXmwUabdYFxa1+Xs9+fyYlAZxTlXZhV/Nw==
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr7393106wme.49.1599720920090;
        Wed, 09 Sep 2020 23:55:20 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/29] ath6kl: wmi: Remove unused variable 'rate'
Date:   Thu, 10 Sep 2020 07:54:25 +0100
Message-Id: <20200910065431.657636-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath6kl/wmi.c: In function ‘ath6kl_wmi_bitrate_reply_rx’:
 drivers/net/wireless/ath/ath6kl/wmi.c:1204:6: warning: variable ‘rate’ set but not used [-Wunused-but-set-variable]

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6885d2ded53a8..a4339cca661f0 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1201,8 +1201,7 @@ static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
 static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_bit_rate_reply *reply;
-	s32 rate;
-	u32 sgi, index;
+	u32 index;
 
 	if (len < sizeof(struct wmi_bit_rate_reply))
 		return -EINVAL;
@@ -1211,15 +1210,10 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rateindex %d\n", reply->rate_index);
 
-	if (reply->rate_index == (s8) RATE_AUTO) {
-		rate = RATE_AUTO;
-	} else {
+	if (reply->rate_index != (s8) RATE_AUTO) {
 		index = reply->rate_index & 0x7f;
 		if (WARN_ON_ONCE(index > (RATE_MCS_7_40 + 1)))
 			return -EINVAL;
-
-		sgi = (reply->rate_index & 0x80) ? 1 : 0;
-		rate = wmi_rate_tbl[index][sgi];
 	}
 
 	ath6kl_wakeup_event(wmi->parent_dev);
-- 
2.25.1

