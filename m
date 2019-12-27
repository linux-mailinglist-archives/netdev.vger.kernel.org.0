Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651A712B9E6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfL0SPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbfL0SPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:15:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D21120CC7;
        Fri, 27 Dec 2019 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470506;
        bh=iQGXxCHV1+CJ7ks380hPcc4n61ekmCUk3qyBkkXbrt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlJ35lZHpd2LhZFTaDzne/C/KsErJxbebleQPDzUaZ5DqqTFJwch3o4Q7kTSsK/hv
         HoxtEYvRp80qVTkpXjNV1EhGHEwGNxC1nJC5VJF8QG9VwbeWsyKlMHdW1HPqbIqsRP
         CbbCgyEaRz4Zjudu6fnnzogNNNQHnXSVD7kF9QH0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Birsan <cristian.birsan@microchip.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 24/38] net: usb: lan78xx: Fix error message format specifier
Date:   Fri, 27 Dec 2019 13:14:21 -0500
Message-Id: <20191227181435.7644-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 858ce8ca62ea1530f2779d0e3f934b0176e663c3 ]

Display the return code as decimal integer.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 96258e6a1920..207660fd4b74 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -442,7 +442,7 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 		}
 	} else {
 		netdev_warn(dev->net,
-			    "Failed to read stat ret = 0x%x", ret);
+			    "Failed to read stat ret = %d", ret);
 	}
 
 	kfree(stats);
-- 
2.20.1

