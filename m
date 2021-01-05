Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7CB2EAE07
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbhAEPQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbhAEPQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 10:16:02 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B036BC061793
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 07:15:21 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id D3FJ2401y4C55Sk063FJUD; Tue, 05 Jan 2021 16:15:19 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kwo3K-001NHB-8U; Tue, 05 Jan 2021 16:15:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kwo3J-006So0-K2; Tue, 05 Jan 2021 16:15:17 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps
Date:   Tue,  5 Jan 2021 16:15:16 +0100
Message-Id: <20210105151516.1540653-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The merge resolution of the interaction of commits 307eea32b202864c
("dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC") and
d7adf6331189cbe9 ("dt-bindings: net: renesas,etheravb: Convert to
json-schema") missed that "tx-internal-delay-ps" should be a required
property on RZ/G2H.

Fixes: 8b0308fe319b8002 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 244befb6402aa8b4..de9dd574a2f954a3 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -163,6 +163,7 @@ allOf:
             enum:
               - renesas,etheravb-r8a774a1
               - renesas,etheravb-r8a774b1
+              - renesas,etheravb-r8a774e1
               - renesas,etheravb-r8a7795
               - renesas,etheravb-r8a7796
               - renesas,etheravb-r8a77961
-- 
2.25.1

