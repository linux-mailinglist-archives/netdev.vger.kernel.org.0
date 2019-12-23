Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282D412940F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLWKOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:14:32 -0500
Received: from inva020.nxp.com ([92.121.34.13]:52182 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfLWKOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:14:30 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5820F1A124E;
        Mon, 23 Dec 2019 11:14:29 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4BE0B1A124A;
        Mon, 23 Dec 2019 11:14:29 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CA0A92033F;
        Mon, 23 Dec 2019 11:14:28 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v2 6/7] dt-bindings: net: add xfi, sfi to phy-connection-type
Date:   Mon, 23 Dec 2019 12:14:12 +0200
Message-Id: <1577096053-20507-7-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently the phy-connection-type for 10G intefaces moved from
just specifying the MII (XGMII) to describing the actual type of
connection used between the SoC and external PHY device. This
does not occur at the clear MII logical MAC-PHY separation point
as some parts of the PHY are now hosted together with the MAC in
the SoC (PCS, PMA) so we need to describe the actual interface
as found on the HW.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index ac471b60ed6a..fb3cff77a7dc 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -96,6 +96,8 @@ properties:
       # 10GBASE-KR, XFI, SFI
       - 10gbase-kr
       - usxgmii
+      - xfi
+      - sfi
 
   phy-mode:
     $ref: "#/properties/phy-connection-type"
-- 
2.1.0

