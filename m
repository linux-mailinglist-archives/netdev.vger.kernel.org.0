Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB532F59F2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhANEee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbhANEed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4921E238E9;
        Thu, 14 Jan 2021 04:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610598832;
        bh=UP26UkG1vxUrMWTyjmuVEVMOWjjUO3uiOgYmoF6cnh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv2gRVo4hPVsh8Go/4sINXtKsSgmD+TZpyJiwlddI6XDJSME0uE/oKXf6P2+jWO3+
         lw4gDt1LTiLe5w4QBmEKdKMhoDXGF6y00mwY1VsNKCATi7smREKcGDiCyrS9DgMTbN
         T+fLsrVnDik6igWHPKh72wv1pKxUk4ffp7treZDM8YaVpWWd2y2yBD8fC4K5QHXH0s
         Dp9Xx8kFQicnYIlZijVPiifwn4BuLSu0a9ng+D3+I3brVEBwvZUAKx4n2WChhD2+6Z
         FMzvhkqi7BcGf2ZHBZaFZw9ZWO+s6VK464GkyzyqG5fV6sO4h/TMYULG80u6B2ELdR
         HPEbC9dnk+YcA==
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
Subject: [PATCH net-next v16 1/6] dt-bindings: net: Add 5GBASER phy interface
Date:   Thu, 14 Jan 2021 05:33:26 +0100
Message-Id: <20210114043331.4572-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114043331.4572-1-kabel@kernel.org>
References: <20210114043331.4572-1-kabel@kernel.org>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

