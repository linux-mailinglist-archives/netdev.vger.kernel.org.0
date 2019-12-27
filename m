Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B229212B921
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfL0SDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbfL0SDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C2E020CC7;
        Fri, 27 Dec 2019 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469788;
        bh=vfwvDSWPrY0aHH2qtgXQ09be4+ozgnBDYPys9QmJ9Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0huMZO7B6uLMbsPHrZthpPn668BKTSuku7tf4Xqu3JaJUfOwx9rDZAJuYWFvv2m8a
         YSbgNmx9K21exDLiSGoYfSSmLz0kH6AxXep77A8aRkE5ZkpbwN0OxAlKvHdwiJOo6W
         I11yfONdEGtbSk5zrq9FuQ5ghkI1QcQPd/OKuMO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Birsan <cristian.birsan@microchip.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 37/57] net: usb: lan78xx: Fix error message format specifier
Date:   Fri, 27 Dec 2019 13:02:02 -0500
Message-Id: <20191227180222.7076-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
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
index 7d1d5b30ecc3..0aa6f3a5612d 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -497,7 +497,7 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 		}
 	} else {
 		netdev_warn(dev->net,
-			    "Failed to read stat ret = 0x%x", ret);
+			    "Failed to read stat ret = %d", ret);
 	}
 
 	kfree(stats);
-- 
2.20.1

