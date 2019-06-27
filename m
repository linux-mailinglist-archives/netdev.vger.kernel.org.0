Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B44575CB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfF0Aca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbfF0Ac2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:28 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380A121738;
        Thu, 27 Jun 2019 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595547;
        bh=ydOv2WDZFlwGjNlsS62+9dwQ4kXG/VqdWxVpFUs3naA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzWqlQ4hFYZGUINBPv4rkdtFBkJKxXr+F57fTZhvobiZkcpieK0rXY98LoVN0GWA7
         S99yTBHZLcR4YtFdasmFI+xgapvbAPkwyay4in6g7dhG7P4dLtAg7SUXw6pJnM3rAT
         xzbo2EPVqGE6LgTkMZ+2e8oO2uLZRH0mvAp7MBZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 37/95] dt-bindings: can: mcp251x: add mcp25625 support
Date:   Wed, 26 Jun 2019 20:29:22 -0400
Message-Id: <20190627003021.19867-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 0df82dcd55832a99363ab7f9fab954fcacdac3ae ]

Fully compatible with mcp2515, the mcp25625 have integrated transceiver.

This patch add the mcp25625 to the device tree bindings documentation.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
index 188c8bd4eb67..5a0111d4de58 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
@@ -4,6 +4,7 @@ Required properties:
  - compatible: Should be one of the following:
    - "microchip,mcp2510" for MCP2510.
    - "microchip,mcp2515" for MCP2515.
+   - "microchip,mcp25625" for MCP25625.
  - reg: SPI chip select.
  - clocks: The clock feeding the CAN controller.
  - interrupts: Should contain IRQ line for the CAN controller.
-- 
2.20.1

