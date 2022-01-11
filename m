Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3433848B22D
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349989AbiAKQ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:28:50 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.104]:37383 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349984AbiAKQ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918163;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=2C2YO5DE3sctmW+OGeLpMch7Pl5r7w3RLfkPRMd6Wpg=;
    b=krFRbwNSb1hgqUQGpjQaUNRCBSNXuNbIOMbxckA/0ne1oBS804Xp2cMhHEbqAfBftI
    gTP74JTsuDkG5CicwtcBHYJYSYWreVd3N9Nrx8taIdicLnoCiNjLZZ1TQd5EX2ZCZ081
    RCe5O7TPh/9t2o25E4jzpmpDmTz3mfFrsNg3CSDvQRV45V56rV1pFn8S274xQzlVOtIB
    upb/R43Nhk7+S6+s65EKH+DcLBPL8RwUk1kRwUq3cBquqUMwEYa4trbhIwVt2CrqTNgc
    hXwLoI5Rjte+zvnPrZw4rP1p2dbimCpHNtp49gIYoBbkNdRga2R9LYImyAoxGjq6LNp3
    jXxQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8nxYa0aI"
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id a48ca5y0BGMgHKv
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:22:42 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v2 5/5] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
Date:   Tue, 11 Jan 2022 17:22:31 +0100
Message-Id: <20220111162231.10390-6-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220111162231.10390-1-uli+renesas@fpond.eu>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for rcar_canfd on R8A779A0 (V3U) SoCs.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml         | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 546c6e6d2fb0..91a3554ca950 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -35,6 +35,8 @@ properties:
               - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
           - const: renesas,rzg2l-canfd     # RZ/G2L family
 
+      - const: renesas,r8a779a0-canfd      # R-Car V3U
+
   reg:
     maxItems: 1
 
-- 
2.20.1

