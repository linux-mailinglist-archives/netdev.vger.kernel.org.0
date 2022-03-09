Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E604D368D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiCIQgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiCIQcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:32:45 -0500
Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [85.215.255.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45291AAA7E;
        Wed,  9 Mar 2022 08:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646843177;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=pvSpRBSP9R8ASIPk1EYQHs3S5k4cUxLIqR90QUqlYC0=;
    b=NpgVH+KQoV7LFTcY2GvjMeZJ2QsfcI1FVqOW4vmEXdfwyePNWO7f5XaigYYhEWIM/O
    HQ6D0XtWys97DMBJYUpkgC/v/dx4+XVTdWKDEzlphCMKt+RUKIq2iUVa9LRovj8/bSdY
    b9FEXy30z1nikKX6HPWSGG6gRHok1E1MxVhWX+Rkc93KM6M48nMagVwFaTE1wJo5xuvP
    uD+mE0u2imqZiVcnDoPYRfckfzScUAmS6LFQq0iFP6Y+vI67gkkbbLEToaMJaMDxZ3J2
    bprBCHcO3P6FSv03GX0uFfabSmC2rcDPuBxuQUHavVUymYdEfUQfGlfkXElboUFmEzge
    Dm1w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82Fcd2Ywjw=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.40.1 DYNA|AUTH)
    with ESMTPSA id 646b0ey29GQGJWF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Mar 2022 17:26:16 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com, horms@verge.net.au,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 4/4] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
Date:   Wed,  9 Mar 2022 17:26:09 +0100
Message-Id: <20220309162609.3726306-5-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309162609.3726306-1-uli+renesas@fpond.eu>
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
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
2.30.2

