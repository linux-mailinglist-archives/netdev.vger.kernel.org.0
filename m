Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258B23F7C42
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbhHYSel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbhHYSej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:34:39 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1153CC0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:33:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 2so452612pfo.8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ggf+LpJPCzqcDcd2e/5j3m/TAA3DFUus0qxXI93OXMw=;
        b=CsfwSRyoDWtqTpvJN2VE9yqMc//0Dh3+4OBPgIbZC04ZCSC8Zpvrla7s3FECoQzFyR
         er96tpvXPhXPStl9lnMkpniY1tQrHmKcBBU4ECKzgxCNsp4yg32j2wOlyRn1YvOYwPcB
         dLRSn1ySg03S/IoQasZzd2kEnMVVEqfN7is1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ggf+LpJPCzqcDcd2e/5j3m/TAA3DFUus0qxXI93OXMw=;
        b=JOLaUWkknaE5SxMhoA5KLAW6b8naQtmS6b1JOHnSnZSnixtcJW15iAOh4da3fJuNGK
         PGft99nmYl8aNcCLPtvyZqwPux+St8Fj2yzKA6VJ+IZzqHe27jMV/wJhm/pttL23nbKs
         BuP/JQPlnOHEOfLyKKta6L6RdfdlCsQ0CklunkyDRUFGXg/U59HAovVuO9mXdqhhCaJB
         ux9/HXFjBXm+uRRo3QKs8qYlg9lnQaQmOufMVQ7FngXZiBcMc+S2hIOU76OgOls26S2F
         549aiorla0bjVXfbrrrxK1COxUkYhhuKD8/7ouBu+CH/itkozah9PZ0D8J8sV6bv4L6Q
         3sgA==
X-Gm-Message-State: AOAM533f+FZV1PkDGzgPZ//JU5bWF/pT2yPLMfegV38AU1dCXHGqXtsr
        faJ+Dbwpvqgz+gpy6rDx9PKngg==
X-Google-Smtp-Source: ABdhPJzvLkiLyiR8okGaSKcAVrW2SnLai1N911vjm8Gmj6lrRbWXY5pWPjjrAAUnXeI5gXGvK7YUrA==
X-Received: by 2002:a62:e116:0:b0:3e1:57a4:e501 with SMTP id q22-20020a62e116000000b003e157a4e501mr45763002pfh.36.1629916432644;
        Wed, 25 Aug 2021 11:33:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id br3sm4801088pjb.52.2021.08.25.11.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 11:33:52 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Style clean-ups
Date:   Wed, 25 Aug 2021 11:33:50 -0700
Message-Id: <20210825183350.1145441-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2542; h=from:subject; bh=WiI8i3mVA5kMq1xjzJQkl4VAkYEYT2HU/B+WViFz08k=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhJo0NkICAybEIi3bCEwhqPsG25+Mb1MpwZyumlIsh CtJ5dJaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYSaNDQAKCRCJcvTf3G3AJqCXD/ 0SV/fuu4BuMqqjwabMcvyFOrQX+6BYxq4R9SGvGsvGBzn4cDaoGlC/DKqGSE4gHnCQjd3B7UsLHD/c Y6nWJ+7LpvVYO9IRwIDfIPn/ahXGNEy7OOp1VLkP9f8NMtHBwsFynMr4re77KztB5A3idqT3W5t0KA V4PTpJrKFwiBKQJ4Xfm8y2dmn7hoz8+Agq7Y8QHBy63FR5RHs9LO/7y1flQ9as9mIidNxhV3gozvW2 324af4kHsg+ECMUat7mkUzL4wKPVfakuxF2iW+kY++hRK5HESb51ov2ZF9GpWOIu3xpHMws719ZE3Z gQrQ9KhSKTX602mr/mp1UVZhLVB0PQGXoHm/ydi1bustMKpPG7pyOkQEPkAxdbyArmGkfM2Ucm+xJ4 vxy35LlOsrZN6fM9HWV75yy9Ta1fsBcUJN5mCazaJmXlMJdLYYzG8tbHBR4m0++ASGgzEjLfsJm3iO NL56mC4bu+/QMuhoZWhGG+yMRHGexC3bE/CZuReAs9+fl3QUgkP4cOvB5ikc00qO46kJX29oAKTVpX PFGyq3bvBEU7L5/3z4WNoohsjAyWrmNeCMrNrNF/2shq7BxyUBiqpS7qt3EtutjCdA/s0UmR8/CV+G d5Ryhn2BQUZiUhBy9UkBaRFVqfspXa7kngyIKpHoYRdeM1vo6TjjeIJ23L+Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up some style issues:
- Use ARRAY_SIZE() even though it's a u8 array.
- Remove redundant CHANNEL_MAX_NUMBER_2G define.
Additionally fix some dead code WARNs.

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 8 +++-----
 drivers/net/wireless/realtek/rtlwifi/wifi.h          | 1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index b32fa7a75f17..9807c9e91998 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -899,7 +899,7 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel5g); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
 			if (channel5g[place] == chnl) {
 				place++;
 				break;
@@ -2861,16 +2861,14 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
 	case BAND_ON_5G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel <= 14)
+		if (WARN_ONCE(channel <= 14, "rtl8192de: 5G but channel<=14\n"))
 			return 0;
-		WARN_ONCE((channel <= 14), "rtl8192de: 5G but channel<=14\n");
 		break;
 	case BAND_ON_2_4G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel > 14)
+		if (WARN_ONCE(channel > 14, "rtl8192de: 2G but channel>14\n"))
 			return 0;
-		WARN_ONCE((channel > 14), "rtl8192de: 2G but channel>14\n");
 		break;
 	default:
 		WARN_ONCE(true, "rtl8192de: Invalid WirelessMode(%#x)!!\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index aa07856411b1..31f9e9e5c680 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -108,7 +108,6 @@
 #define	CHANNEL_GROUP_IDX_5GM		6
 #define	CHANNEL_GROUP_IDX_5GH		9
 #define	CHANNEL_GROUP_MAX_5G		9
-#define CHANNEL_MAX_NUMBER_2G		14
 #define AVG_THERMAL_NUM			8
 #define AVG_THERMAL_NUM_88E		4
 #define AVG_THERMAL_NUM_8723BE		4
-- 
2.30.2

