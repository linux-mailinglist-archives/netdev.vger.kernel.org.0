Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C82F3B3F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393178AbhALTy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393028AbhALTy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:54:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EAB2311B;
        Tue, 12 Jan 2021 19:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610481257;
        bh=TbMfJle3PafxIrfEXtZo02MLDAIq6S6k+3b6lACbNbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0I6pqkzF/bH7XiuX214dFDWwrO1rayZbC1UOXQRT5GnY+cwU9aVjqwADFT9gA64N
         moADpINwvfEvMnUCtoDalQX9gtaHr+67ZFkqp9cvk9fCNHG61L9g3hTS+VDPGINC7h
         SGinR3NrRtrmEIeGXWC5+GWukxAkob/qVyKQ+sI9kxV8oZXyskqtd2EKHyCRTXIeGK
         Q5fxa1TKd7d/ufXKnsWoEdCN5CNCQ2zPorlqPx+kKBqY1zRzEmY5MEkoOtJKtbGpVf
         L74f40Kdjl2vJ9EN+sI3PUH3+mDfjFJadPB1QfEsktjsPPxAu+iWNdxxUd++o7d9JJ
         v+LGszF3D+jBg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v15 1/6] dt-bindings: net: Add 5GBASER phy interface
Date:   Tue, 12 Jan 2021 20:54:00 +0100
Message-Id: <20210112195405.12890-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112195405.12890-1-kabel@kernel.org>
References: <20210112195405.12890-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavana Sharma <pavana.sharma@digi.com>

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 0965f6515f9e..5507ae3c478d 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,7 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.26.2

