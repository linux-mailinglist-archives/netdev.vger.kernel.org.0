Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30673A4276
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhFKM5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:57:05 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23995 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFKM5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623416107; x=1654952107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OXAufTI7xkFdkCQtCtspmQxuaWx9O9Dqg1OQXDiXCMA=;
  b=XSvDQHj14zsg8AGkjkQyAq+EKDGVob+FY/A2areTJ87UxBuBh3OkqpJZ
   IOXBVxsec583pqao/i99ZkLeBVqr7F4c4b2wUOD9eV4nQ8XddSYtW8EiK
   iZUiI1znIBC/rqGxBVUXzsBnW+VzaI8YdXeEnq23EBdSW9dOQIvf2rO27
   C7z0zIVT59k71iNMhxKYzGrugDpOnirjBSEK+4xCvrRsXKCzAV/gybUMM
   bCh/KJQDHrOiUOqmNzWyqCEqhgwKGPGXnE6pqwKUGXyADVng6BUNypM/x
   XxMI5PUEMr2huGTIvjkQJUhiDnPApXL/ckbKJSYhT31U/BNHYk/4W3ttF
   w==;
IronPort-SDR: x8aGwwrR24QaZt48HI8CF9Uh0G7RYJUIZbpXanMB2CcbGNBFuJpuVbvQBJX+v+ZFTEuLaQhRX0
 VmYMlOCL7OyHdVYQ7zs7SprrFuG6LE2m0wrW8UNFwdUxai7NTKO2dFrnP/WseY/vol5iBDZXR+
 lWdfS8WG+9nJspDYYTqwO8O0N4Wiv2EU/A+XtgYiSZYZKR66p2Y+aag4POrbhC7xmvA5xajGyD
 9/YXt1HbP1ZPtIP9MPwwJLM404EjRdfGDUvYbIoQNjtpaDXM1BaMKndnAjj/2iapLsxMyo0SV2
 uA8=
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="124398238"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2021 05:55:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 05:55:06 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 11 Jun 2021 05:55:04 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: [PATCH net-next 1/4] dt-bindings: net: Add 25G BASE-R phy interface
Date:   Fri, 11 Jun 2021 14:54:50 +0200
Message-ID: <20210611125453.313308-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210611125453.313308-1-steen.hegelund@microchip.com>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 25gbase-r PHY interface mode.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index d97b561003ed..b0933a8c295a 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -98,6 +98,7 @@ properties:
       - 10gbase-kr
       - usxgmii
       - 10gbase-r
+      - 25gbase-r
 
   phy-mode:
     $ref: "#/properties/phy-connection-type"
-- 
2.32.0

