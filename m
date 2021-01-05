Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7EE2EA8FC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbhAEKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbhAEKkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:40:36 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08362C061574;
        Tue,  5 Jan 2021 02:39:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id w18so27814734iot.0;
        Tue, 05 Jan 2021 02:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGv5BXQoXt1YV+ky7O4M22sQP/FE/RZ8fZVCbYo6uFY=;
        b=FnImoHMeL4WdrJXqnC2WmnlwR3hqOxuAHMhq0rHim9uSCx4nRnfw+i3aises70p9Ma
         qSJGHnSofGJ2YLdIaIvlL3F2Mldlbr1Na4AQ+6i92ZfOZArHrRi7654csUtVl+kQz6pz
         AZfjvP+gguxk9sODmqBoEmIEJ2BebKo9vdDtQQtqGo+Jg+9pm/Fql8gtYrZftrxRrlX5
         Z+kH9GQbMhKj3BzLtQI0TzCPe09cUpr8eWxoZfPAsr07ofB2Bz83Qm10QA+m//J/1t1W
         b3IQLN29R0pdJZiYv8Faj1D1/nXhEh/YzC3PEVbsx0CoHBWgi8O/W20Vmg3GoNj6qWFK
         x58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGv5BXQoXt1YV+ky7O4M22sQP/FE/RZ8fZVCbYo6uFY=;
        b=rfdmG+DK0dH+ggcCdDd22X/HEhlGDLgDb91J31MFqX9g4keEQQMNApoaz+E+BxshyT
         /taSixbG+0718tkB0uyvmDEfb6EAYimIhxUUCctxgyh/KTvM4f9Ad4YqaSr3fk72z8vX
         15jrowemv44LGLJ0h3se7xZIt0E2y/yRE60Ux0N0i7XdLuuYq5K1vLSkzCzshXKe1yTf
         U2rPlGt3nIdrdpTbktplkoA39sIcm/08eDveBZkbraTu+45+jY0AGyRkhNCOmZzdfqhG
         h7Pi1wyjmblkXUM/ugtsJF+e435HM0XoobgJnE93j7P2ziSgIq/ki2Dif50lbWIeAg6z
         ReUw==
X-Gm-Message-State: AOAM532T6AoRtBURYdtvqAl23WY/ilJk1YU6APEDe7DgSPoJqhWXzSgr
        YaqZVUwHCMntyhElMj97mDw=
X-Google-Smtp-Source: ABdhPJyJP0w6GHhTuHa0yJW5AJXeGpF1GkZNrKfyt4BBOsRbLkkfFQNGZoZE/po9d8wVyPCS0QPBfQ==
X-Received: by 2002:a05:6602:2c48:: with SMTP id x8mr63079686iov.24.1609843195428;
        Tue, 05 Jan 2021 02:39:55 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id h70sm43347217iof.31.2021.01.05.02.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:39:54 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: realtek: rtl8723be:  Correct word presentation as defautly to de-faulty
Date:   Tue,  5 Jan 2021 16:10:00 +0530
Message-Id: <20210105104000.14545-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/defautly/de-faulty/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 5a7cd270575a..47886a19ed8c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -724,7 +724,7 @@ bool rtl8723be_is_tx_desc_closed(struct ieee80211_hw *hw,
 	u8 own = (u8)rtl8723be_get_desc(hw, entry, true, HW_DESC_OWN);

 	/*beacon packet will only use the first
-	 *descriptor defautly,and the own may not
+	 *descriptor de-faulty,and the own may not
 	 *be cleared by the hardware
 	 */
 	if (own)
--
2.26.2

