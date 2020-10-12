Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB328C118
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391533AbgJLTJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbgJLTC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4352721548;
        Mon, 12 Oct 2020 19:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529379;
        bh=ao7D3KZT2FP+JgZVkcBysZt2M0MjyQFrbUe+GkCrHNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBHK0tLHw1k7lJOUMYcU3CjbEesHECXMJH6av959xZ2AOkbO9bjjjfS4fGcIa9YnF
         BF4CtLrtXPyBvzKSAwiNdKRlxlnrqEQ9zBfDaeRVbsXjqJciHpHclFzEFcUGZ7+gqO
         td/T6mnCM1bMS2c14URUNa9o5P4ooKB2UEjs/V9Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 15/24] via-rhine: VTunknown1 device is really VT8251 South Bridge
Date:   Mon, 12 Oct 2020 15:02:30 -0400
Message-Id: <20201012190239.3279198-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
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
index a20492da34079..d3a2be2e75d09 100644
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

