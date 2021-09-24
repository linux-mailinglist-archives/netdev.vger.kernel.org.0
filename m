Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0EF4177EA
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347147AbhIXPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 11:38:51 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:25134 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhIXPiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 11:38:50 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2021 11:38:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632497480;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=1aE1a54Ju0/CD+ZvsJgxsa6GKY0ceeHqracZI3YgUYA=;
    b=C5GNmjkpLB8UC1E5Ruy7hxvdiYVzWWM768ufmo/NOVgcsNwPVPpKaV2Kmul4sF8S80
    EbRAzDaaWeZebdsQ6w1u+jaYlftfftJ315xsAn5lLPp8iCRoW/Ym5fKMoDMetkcGn4OP
    CvC7d3oylwwrBnaG7U/cWOFbMRjJxXGGxgZ6quVzgVdLSBsGlpV1g69KKJrSV/bNkwgb
    CLvdt6TLScVjGldv5mz/ydAm5Ad8CVWz3F2/IpJqxDnzlOxJ4/iG35YRzXMp5E8qb57Y
    dW9WlWVTHnrYyC5TUzNgY5tbdgRv3RnhYBiUqISGmufYrn/B/Mdpxh4313p0d5Q80lYN
    WGyw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR92BEa52Otg=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.33.8 DYNA|AUTH)
    with ESMTPSA id c00f85x8OFVJN4R
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 24 Sep 2021 17:31:19 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH 2/3] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
Date:   Fri, 24 Sep 2021 17:31:12 +0200
Message-Id: <20210924153113.10046-3-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210924153113.10046-1-uli+renesas@fpond.eu>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for rcar_canfd on R8A779A0 (V3U) SoCs.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 546c6e6d2fb0..8f1aad9ae401 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -28,6 +28,7 @@ properties:
               - renesas,r8a77980-canfd     # R-Car V3H
               - renesas,r8a77990-canfd     # R-Car E3
               - renesas,r8a77995-canfd     # R-Car D3
+              - renesas,r8a779a0-canfd     # R-Car V3U
           - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
 
       - items:
-- 
2.20.1

