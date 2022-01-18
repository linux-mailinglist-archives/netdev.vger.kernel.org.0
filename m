Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C4C49209D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbiARHyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiARHyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:54:46 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6638EC061574;
        Mon, 17 Jan 2022 23:54:46 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id kl12so20601648qvb.5;
        Mon, 17 Jan 2022 23:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RK5Qj5jSKwCESh46uBZezLqWgB/cSidsO+cZqWpG+Fs=;
        b=OfH6W1K6fc3TnFu8CQ7f80BOI1DNYIC9k/8xDSv6TB3eHkF+wnFUyH/EuRcL0DDMcm
         qYC0zcARrO2CPUmNvG9ilO9em1m6sWizZiz4znKsOfWhjBlPCTs7wCj0BtAsMOLMXc/5
         oSU2hSPiYT9ucCvQLaTosbpcgREN4VMibmdd8GYu/7t3Jtae+8yYWXU/x3DQt5F/JIzL
         2+29p9Xfig4vh3RnrsXpaj8QlxDMAh5+EBrDmRoZ0YHSXU1dvMFxaQBAPmkHnD2T4g7u
         4sY3D7nTCCDo6ZKftrgJazHdTwi+Hdgm6SbA7/1NEZP4x++jCt0FwNElDlodISZ9ELla
         UFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RK5Qj5jSKwCESh46uBZezLqWgB/cSidsO+cZqWpG+Fs=;
        b=xhPHTvYHG+YfFjI/lx3POLlI6NlFT+LEUD7QLHjZ7Mzpn6y8Ez3i5o73w4BkdLnBW5
         /+c3tJ7sFdBAEPATIUsr82OpelTJqdfGyT6UfEqJXc4dYRjJ8b4Dhxz2en/myIIEfgvZ
         0eq02cpsLSsn9dMCOKr+dhKcguCwh1KMgM635ldo6qxtfBt4Gqhf5cmfBbT3ykVD80ZD
         yAJ4byUKPU8IESzThriT+ITAB0dDhQ/qBnSHFzC9T87sYSjbzTTkY1NNuckvoqsUVS7q
         x62i+cZ//E58u4R3qnMQaZ9f5VYkJs1aZdQo3YE0lf4YfJkQfM61r8muMW0Wd65jg/Tg
         3d1Q==
X-Gm-Message-State: AOAM531t4cqHJ6wx9rqF6x/BTzUbCg8SCiSkQv5LH30GOvAghYW7uT3h
        rPL3dc8OyT770ALV2iYIv0c=
X-Google-Smtp-Source: ABdhPJyf9lDCW5OLRvSjNy8kuBmSepdOtlodbb1W29zw+dn3KIroTnlyloKYtR+q7/BglvS4812JWw==
X-Received: by 2002:a05:6214:23cc:: with SMTP id hr12mr21102330qvb.66.1642492485639;
        Mon, 17 Jan 2022 23:54:45 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d11sm10495325qkn.96.2022.01.17.23.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 23:54:45 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     richardcochran@gmail.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] drivers/net/phy/dp83640: remove unneeded val variable
Date:   Tue, 18 Jan 2022 07:54:38 +0000
Message-Id: <20220118075438.925768-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from phy_read() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/phy/dp83640.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index c2d1a85ec559..4159e7cdc92c 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -226,15 +226,13 @@ static inline int broadcast_write(struct phy_device *phydev, u32 regnum,
 static int ext_read(struct phy_device *phydev, int page, u32 regnum)
 {
 	struct dp83640_private *dp83640 = phydev->priv;
-	int val;
 
 	if (dp83640->clock->page != page) {
 		broadcast_write(phydev, PAGESEL, page);
 		dp83640->clock->page = page;
 	}
-	val = phy_read(phydev, regnum);
 
-	return val;
+	return phy_read(phydev, regnum);
 }
 
 /* Caller must hold extreg_lock. */
-- 
2.25.1

