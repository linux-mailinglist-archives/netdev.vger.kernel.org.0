Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE12448E8
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgHNLkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgHNLj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:58 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F072FC061387
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so7676804wmb.0
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TS8uliyMAsDEXuQvFM/Ipwo7jc3ArpR50UIhIcJDQzc=;
        b=TKuoVl/YEqf251IASipO0+ITEQjL3zs+hHnd9Z8j9jsUVq+6Kcd8Kzv+IBlQoepyac
         h4nS2KmeffjqVF31OMx/wP6iQfwKuvv5ol6vu/Hr8x24zNYjIQEV+Ns9aP65O5dWjZj4
         QhliiMcvGLyPreer3tdSg4vantZsJfaMpVGlZ3KWyfje6Y1dheg6zEIj+50KZ/1UvWrZ
         8uwcZsliRKfw8ixliMc2sx5Y0tDqersXdPXBsDNm2WZAtXZLVsPaWOQM3lBdAVImAfov
         7/JsTsQoFsfzt5fRkl3kf+RxGU4ywdZwMoFz0MSF6IT+4f5Ev+bzcKEWFmCBBhOKGtkM
         HKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TS8uliyMAsDEXuQvFM/Ipwo7jc3ArpR50UIhIcJDQzc=;
        b=R3VIj5sj6/maI9lNT0DkH16X0H2eaMA4HCcKGqmgAiF14gZRnsonOJ0ddw2Ztrf8wi
         OkE5N4HrPGgCDVcFDj4TsngD3LvUKTw7JhNmjazjkoGTX7NaMqj6ICKY9MMd05JKKtTx
         3+nxI/z5yw8zWPtSq9J4by779IvHC2GmI4+2YLFhZI8uCxNoCzL6cToTKJZShoT9g0bZ
         ewbQdNxQ7KJilQevf2K7Q8wpD+k4blBt5YFRSuXx/W08EQcG88RNercxhENlKtfxPL7l
         pQI7vB8ye1Vp5k4KCn0rIVnMraeZRZtUOKseMYkm52UhMHB7XI8dWsFGFhJMBTAii4V1
         kGWw==
X-Gm-Message-State: AOAM531bgjXs2U2UTyZrFjfCuOhcL4q53NUrASM0TQ03b3WHBuVvNuwY
        jPvpe89fBh23JwSB57vgcoR5lg==
X-Google-Smtp-Source: ABdhPJyhJk61l2TcooqYTMWD3db+D3dPPhU7haUSUyMg9SIyo5MX4M9A3eCixDDFp878zNcNn+ldmg==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr2154973wma.176.1597405196730;
        Fri, 14 Aug 2020 04:39:56 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Reyk Floeter <reyk@openbsd.org>,
        "W. S. Bell" <mentor@madwifi.org>,
        Luis Rodriguez <mcgrof@winlab.rutgers.edu>,
        Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 09/30] net: wireless: ath: ath5k: pcu: Add a description for 'band' remove one for 'mode'
Date:   Fri, 14 Aug 2020 12:39:12 +0100
Message-Id: <20200814113933.1903438-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath5k/pcu.c:115: warning: Function parameter or member 'band' not described in 'ath5k_hw_get_frame_duration'
 drivers/net/wireless/ath/ath5k/pcu.c:955: warning: Excess function parameter 'mode' description in 'ath5k_hw_pcu_init'

Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Reyk Floeter <reyk@openbsd.org>
Cc: "W. S. Bell" <mentor@madwifi.org>
Cc: Luis Rodriguez <mcgrof@winlab.rutgers.edu>
Cc: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath5k/pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 05140d8baa360..627bfd9f484a8 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -101,6 +101,7 @@ static const unsigned int ack_rates_high[] =
 /**
  * ath5k_hw_get_frame_duration() - Get tx time of a frame
  * @ah: The &struct ath5k_hw
+ * @band: One of enum nl80211_band
  * @len: Frame's length in bytes
  * @rate: The @struct ieee80211_rate
  * @shortpre: Indicate short preample
@@ -945,7 +946,6 @@ ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
  * ath5k_hw_pcu_init() - Initialize PCU
  * @ah: The &struct ath5k_hw
  * @op_mode: One of enum nl80211_iftype
- * @mode: One of enum ath5k_driver_mode
  *
  * This function is used to initialize PCU by setting current
  * operation mode and various other settings.
-- 
2.25.1

