Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D847024B450
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgHTKDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:03:38 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34478 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbgHTKCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:17 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B5101A054D;
        Thu, 20 Aug 2020 12:02:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7ED111A05D5;
        Thu, 20 Aug 2020 12:02:15 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3936B202A0;
        Thu, 20 Aug 2020 12:02:15 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH] dt-bindings: net: correct description of phy-connection-type
Date:   Thu, 20 Aug 2020 13:02:04 +0300
Message-Id: <1597917724-11127-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-connection-type parameter is described in ePAPR 1.1:

Specifies interface type between the Ethernet device and a physical
layer (PHY) device. The value of this property is specific to the
implementation.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 1c4474036d46..fa2baca8c726 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -54,7 +54,8 @@ properties:
 
   phy-connection-type:
     description:
-      Operation mode of the PHY interface
+      Specifies interface type between the Ethernet device and a physical
+      layer (PHY) device.
     enum:
       # There is not a standard bus between the MAC and the PHY,
       # something proprietary is being used to embed the PHY in the
-- 
2.1.0

