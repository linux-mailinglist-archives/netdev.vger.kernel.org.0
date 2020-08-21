Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3112624CF18
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgHUHVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgHUHRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:38 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09667C061367
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so818970wme.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4IO+GbezkeOVEDLE59WtvmxZ3aZ2wEvR7+wN6e+wac=;
        b=EPloUf9FNSKGfd/JfwqfvnJ2z50BA9p6KyWr54B9Ihh5g/EQeTl2llV5rwUaMEB73U
         Qk3yGlA67JYVyMUYyB0LET/PWO/Fe9fcbNwvt2KX464jE+6PHa5S1O9SDljQeO7n1zf8
         5T1ug6Fl/yXhp2wczUDWMRVC7eEWn3jDmL2IlkMxarghCL0lNgUE3YQeWdKR1vOGMvON
         of9MDmiW84uyJ4rVU8AOC9eQY24CaNkYQqFXdSPqT85ad+Y+wQDjE8ctmPdlQJ6r4ANV
         QOM4P1j3bk65/1OPdHwgUsKprgjfkn+AZZ9F5ZTabufVDsMMPqHIs/uwkG/PG+TqoIrZ
         Hwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4IO+GbezkeOVEDLE59WtvmxZ3aZ2wEvR7+wN6e+wac=;
        b=om3L16BhenWdVTuuzxAuo+IHVEvdh5EQpwQUiV/RanWB1YTRwbPDgKdFNb1AFM4LX9
         SKJI1+tcEfi95SZfMZZRAN9REPzHSTeEytlg049SLmTsAwFXGbwDXLdDbnRfW+UgUq8J
         U0RehzUKmggXzS3nw0rqhKWziXLkNrtpQk1g2w/IVwRkcCCSH0TGhQfPaEpZxHejblPG
         O/hV4romU2PoXBRb+KRG5jI4urahvI1atEmomiuPjb+bxhGmjUfnBFDUfeCzya05cU8u
         HvKyV9yaJjklME0zbgZzwzESgIZZFbqq4ydoDa5D5x8QTiUbpMlr8fj/EHrghgnzIWfE
         /PlQ==
X-Gm-Message-State: AOAM533t7X6BBEyaqUiHli/dglfkNNxJmWpzh3378Uao9asqmDsa9Ocd
        TV0NABmguxrN1n2JD7n/5hb2fg==
X-Google-Smtp-Source: ABdhPJy3GWSY/U7Nz4v0F4Ce/XY9YhbtphlVpbK0f2gV347IHuAWYjzcTmBRbxBr/zgkzBVM83RFbA==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr2426054wmf.26.1597994229657;
        Fri, 21 Aug 2020 00:17:09 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        b43-dev@lists.infradead.org
Subject: [PATCH 17/32] wireless: broadcom: b43: phy_ht: Remove 9 year old TODO
Date:   Fri, 21 Aug 2020 08:16:29 +0100
Message-Id: <20200821071644.109970-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/b43/phy_ht.c: In function ‘b43_phy_ht_op_init’:
 drivers/net/wireless/broadcom/b43/phy_ht.c:904:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/b43/phy_ht.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_ht.c b/drivers/net/wireless/broadcom/b43/phy_ht.c
index c685b4bb5ed6e..d050971d150a5 100644
--- a/drivers/net/wireless/broadcom/b43/phy_ht.c
+++ b/drivers/net/wireless/broadcom/b43/phy_ht.c
@@ -900,9 +900,6 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x70, 0x50);
 	b43_phy_write(dev, 0x1ff, 0x30);
 
-	if (0) /* TODO: condition */
-		; /* TODO: PHY op on reg 0x217 */
-
 	if (b43_current_band(dev->wl) == NL80211_BAND_5GHZ)
 		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_CCK_EN, 0);
 	else
-- 
2.25.1

