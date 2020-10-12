Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1D28C09B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391535AbgJLTFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391347AbgJLTEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:04:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC35221FF;
        Mon, 12 Oct 2020 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529464;
        bh=e9yGa2tP0UE3nErhXo1t63AQ+zvXV4/FX4qb6ouIiLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUY1B4hJkQrBeUI+duCsS/uh/cU9mJQaUchAeA+iZmts8XijZsM6I7DYXN/BA5Qv0
         vl97nufJrp9ACqpZKGwtzITU0JsaU49P43CquNJka/EYd9efc+Jgp1X/z3xD6VXUG9
         Azyfp5h7DV8xabbMT7pujm1OWt+AhzhLa56LYBXY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/6] via-rhine: VTunknown1 device is really VT8251 South Bridge
Date:   Mon, 12 Oct 2020 15:04:16 -0400
Message-Id: <20201012190418.3279866-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190418.3279866-1-sashal@kernel.org>
References: <20201012190418.3279866-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

[ Upstream commit aa15190cf2cf25ec7e6c6d7373ae3ca563d48601 ]

The VIA Technologies VT8251 South Bridge's integrated Rhine-II
Ethernet MAC comes has a PCI revision value of 0x7c.  This was
verified on ASUS P5V800-VM mainboard.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/via/via-rhine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 8a8b2364bf82d..370676d2ae6ae 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -243,7 +243,7 @@ enum rhine_revs {
 	VT8233		= 0x60,	/* Integrated MAC */
 	VT8235		= 0x74,	/* Integrated MAC */
 	VT8237		= 0x78,	/* Integrated MAC */
-	VTunknown1	= 0x7C,
+	VT8251		= 0x7C,	/* Integrated MAC */
 	VT6105		= 0x80,
 	VT6105_B0	= 0x83,
 	VT6105L		= 0x8A,
-- 
2.25.1

