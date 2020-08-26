Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7ED252A54
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgHZJhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgHZJfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80C8C0617A0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id p17so1090043wrj.8
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5xYAPYXZqKI3g1GFZmnrzEgVa6jjBFa/aMcqWmXa5Dc=;
        b=NtAv25hji32BSctbHNSG6hvgojalWPH/q2SbQ6HmZPxPxofhzszwXZbiKeVhObOPRu
         9FGE5aT64rD+pIVxs5baems82rqFmheemeohT5g0YqsAUxq4VzJ0QDqpHV8+7kaKCHfM
         7g09v5S3ArlX5RSV2C7h+c9p5TXpyTkOVveKkl1BdsSYSftFphmajGgdnfWZUd6TWOn3
         V95i0Yav3ECduA2ieGEHHnkRoEckdthoggrF0Hc7vGnmtdWsoz+pbgAWGuTbW+bfOdVJ
         k03tb/D35hhKdjGQUZLufVJhsvkPrSb9ks8YB8kPodnKxjU/Z0KyjAhF59cMnf/yDq1w
         bW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5xYAPYXZqKI3g1GFZmnrzEgVa6jjBFa/aMcqWmXa5Dc=;
        b=q9nh24pdrzd4PYxmbe9WnGOtpW4nADTNd3oUfAtRrIXrtCBOGKPOPhIzwoShEV0/QH
         rHOmFk03J5wJ0OIBnvPDszCPTC/5PdxnJF9HkkPurkYf83ggvvWQ9DKxDx5zRc3EIUCK
         eM9eXTNLt+3nPAZD90u/96YEsk4GZ2+/mNS6aLxd1KsyRT2EYeeq0qG4rprQKaA6rv75
         wGbbIlXHCoPemZr2i8j5mCMfrJ1vtBisxM/yednzO0do1OcMEEXJPNpMOAUKK/Rcan6x
         df5lkoE9evjFZK2SGh6SpbizXL4k/55/zGWKAnfAG2unPPuA7NLx6nI7oHa5aoOkHaJu
         LGnw==
X-Gm-Message-State: AOAM5303MfA+R9xLb/8fvGy+Cb0syPQwjDc0CRyxkMLI+RsmLPEMODXX
        XjjqvoL97QDbiVX/WotpglSYXA==
X-Google-Smtp-Source: ABdhPJwlHgHvN4aaFIAjEP8d/rVGWNg4vJOAzlVz1zWIu7YkcH9UYqB9S9fIOyuB6XE6PgXJ4tP9XA==
X-Received: by 2002:adf:f388:: with SMTP id m8mr15137432wro.338.1598434468397;
        Wed, 26 Aug 2020 02:34:28 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jouni Malinen <j@w1.fi>, Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 19/30] wireless: intersil: hostap: hostap_hw: Remove unused variable 'fc'
Date:   Wed, 26 Aug 2020 10:33:50 +0100
Message-Id: <20200826093401.1458456-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/intersil/hostap/hostap_cs.c:196:
 drivers/net/wireless/intersil/hostap/hostap_hw.c: In function ‘prism2_tx_80211’:
 drivers/net/wireless/intersil/hostap/hostap_hw.c:1806:18: warning: variable ‘fc’ set but not used [-Wunused-but-set-variable]
 1806 | u16 tx_control, fc;
 | ^~
 In file included from drivers/net/wireless/intersil/hostap/hostap_plx.c:264:
 drivers/net/wireless/intersil/hostap/hostap_hw.c: In function ‘prism2_tx_80211’:
 drivers/net/wireless/intersil/hostap/hostap_hw.c:1806:18: warning: variable ‘fc’ set but not used [-Wunused-but-set-variable]
 1806 | u16 tx_control, fc;
 | ^~
 In file included from drivers/net/wireless/intersil/hostap/hostap_pci.c:221:
 drivers/net/wireless/intersil/hostap/hostap_hw.c: In function ‘prism2_tx_80211’:
 drivers/net/wireless/intersil/hostap/hostap_hw.c:1806:18: warning: variable ‘fc’ set but not used [-Wunused-but-set-variable]
 1806 | u16 tx_control, fc;
 | ^~

Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intersil/hostap/hostap_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index b6c497ce12e12..a8aa8f64abe0c 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -1803,7 +1803,7 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	struct hfa384x_tx_frame txdesc;
 	struct hostap_skb_tx_data *meta;
 	int hdr_len, data_len, idx, res, ret = -1;
-	u16 tx_control, fc;
+	u16 tx_control;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -1826,7 +1826,6 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	/* skb->data starts with txdesc->frame_control */
 	hdr_len = 24;
 	skb_copy_from_linear_data(skb, &txdesc.frame_control, hdr_len);
- 	fc = le16_to_cpu(txdesc.frame_control);
 	if (ieee80211_is_data(txdesc.frame_control) &&
 	    ieee80211_has_a4(txdesc.frame_control) &&
 	    skb->len >= 30) {
-- 
2.25.1

