Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B7F41ED30
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhJAMPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhJAMPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 08:15:43 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7954CC06177C
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 05:13:59 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id 0cDx260084C55Sk01cDxWt; Fri, 01 Oct 2021 14:13:57 +0200
Received: from rox.of.borg ([192.168.97.57] helo=rox)
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mWHQK-0010wm-UZ; Fri, 01 Oct 2021 14:13:56 +0200
Received: from geert by rox with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mWHQK-00BImh-EW; Fri, 01 Oct 2021 14:13:56 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: renesas,etheravb: Update example to match reality
Date:   Fri,  1 Oct 2021 14:13:55 +0200
Message-Id: <7590361db25e8c8b22021d3a4e87f9d304773533.1633090409.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Add missing clock-names property,
  - Add example compatible values for PHY subnode.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 4c927d2c17d35d1b..bda821065a2b631f 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -287,6 +287,7 @@ examples:
                               "ch13", "ch14", "ch15", "ch16", "ch17", "ch18",
                               "ch19", "ch20", "ch21", "ch22", "ch23", "ch24";
             clocks = <&cpg CPG_MOD 812>;
+            clock-names = "fck";
             iommus = <&ipmmu_ds0 16>;
             power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
             resets = <&cpg 812>;
@@ -298,6 +299,8 @@ examples:
             #size-cells = <0>;
 
             phy0: ethernet-phy@0 {
+                    compatible = "ethernet-phy-id0022.1622",
+                                 "ethernet-phy-ieee802.3-c22";
                     rxc-skew-ps = <1500>;
                     reg = <0>;
                     interrupt-parent = <&gpio2>;
-- 
2.25.1

