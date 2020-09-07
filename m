Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32521260087
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbgIGQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgIGQe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B5221D80;
        Mon,  7 Sep 2020 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496494;
        bh=pWPCQxYkwcrRSwkB1/hw9MYm8NdGPFIuQ7QBFDTRK/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COJvUydhjBSkaTAy/BeEiNOGiC5XdWFjkECczjddh51FeQf4wMTksQTRxeUMoW2ga
         UPzqTq4/AbtAzH3Z1D2kBcStGPCEZ62hjLIrIkm1uZqfrJGRZIyQ524qzpRgp4puhn
         8T3RI+6NJca75Ku/+hEBWthifXfPmOfc73Pl5fzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamil Lorenc <kamil@re-ws.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/26] net: usb: dm9601: Add USB ID of Keenetic Plus DSL
Date:   Mon,  7 Sep 2020 12:34:22 -0400
Message-Id: <20200907163426.1281284-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163426.1281284-1-sashal@kernel.org>
References: <20200907163426.1281284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kamil Lorenc <kamil@re-ws.pl>

[ Upstream commit a609d0259183a841621f252e067f40f8cc25d6f6 ]

Keenetic Plus DSL is a xDSL modem that uses dm9620 as its USB interface.

Signed-off-by: Kamil Lorenc <kamil@re-ws.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/dm9601.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index b91f92e4e5f22..915ac75b55fc7 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -625,6 +625,10 @@ static const struct usb_device_id products[] = {
 	 USB_DEVICE(0x0a46, 0x1269),	/* DM9621A USB to Fast Ethernet Adapter */
 	 .driver_info = (unsigned long)&dm9601_info,
 	},
+	{
+	 USB_DEVICE(0x0586, 0x3427),	/* ZyXEL Keenetic Plus DSL xDSL modem */
+	 .driver_info = (unsigned long)&dm9601_info,
+	},
 	{},			// END
 };
 
-- 
2.25.1

