Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F294AF6F8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbiBIQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbiBIQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:41:14 -0500
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 08:41:17 PST
Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [85.215.255.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78208C0612BE;
        Wed,  9 Feb 2022 08:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644424699;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Ca69WE1r5ukycskrnHzwe8iK0qTS9wFvAGaWiuZxEf0=;
    b=jPIA0ING0LtZxMSxx7bnlrRin+R4GQQQVUyLh8ujWmBLBFhxhmmf6h7/2Ls3OQuSB3
    WAXWTZ+18N5cZ62lrB7k1xgAs42ePQ9CsgZW1YppGUux1DpZpBEZH9oKHFmh+hjV7p6d
    k+rascKEYMkULuUloBIxLBtupQme3pOWQS0RRuz02dNo2hQl4dBb/B8H50/f6PNe8cl5
    y8MeyNhIP3IG3GWc2ViVI1auAk9Qh3aq29U57WD3JsJqlVIWok57Ofi3N8JaF00dn1wt
    JQcdcx5fzVxnmt+NEzS7e3qUEvt4Ui7UkXMF2fUwC341O6FjTcIGZMv6ztl1eaRG53Tx
    HCQg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82dfdzLc5sE="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.39.0 DYNA|AUTH)
    with ESMTPSA id ufcb0fy19GcI7bx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Feb 2022 17:38:18 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 4/4] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
Date:   Wed,  9 Feb 2022 17:38:06 +0100
Message-Id: <20220209163806.18618-5-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220209163806.18618-1-uli+renesas@fpond.eu>
References: <20220209163806.18618-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for rcar_canfd on R8A779A0 (V3U) SoCs.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
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

