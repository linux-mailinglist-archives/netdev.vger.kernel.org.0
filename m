Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465D95175E8
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386707AbiEBRhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241242AbiEBRhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:37:33 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A7963C2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:34:02 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:cd2b:85eb:bdf:a9c3])
        by laurent.telenet-ops.be with bizsmtp
        id RtZv2700N3SeZYW01tZvkK; Mon, 02 May 2022 19:34:00 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvn-002nnJ-0Z; Mon, 02 May 2022 19:33:55 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvm-0038dD-De; Mon, 02 May 2022 19:33:54 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/2] dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required
Date:   Mon,  2 May 2022 19:33:51 +0200
Message-Id: <cover.1651512451.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

The Renesas R-Car CAN FD Controller always uses two or more interrupts.
Hence it makes sense to make the interrupt-names property a required
property, to make it easier to identify the individual interrupts, and
validate the mapping.

  - The first patch updates the various R-Car Gen3 and RZ/G2 DTS files
    to add interrupt-names properties, and is intended for the
    renesas-devel tree,
  - The second patch updates the CAN-FD DT bindings to mark the
    interrupt-names property required, and is intended for the DT or net
    tree.

Thanks!

Geert Uytterhoeven (2):
  arm64: dts: renesas: Add interrupt-names to CANFD nodes
  dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required

 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml        | 3 ++-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77951.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77970.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                      | 1 +
 arch/arm64/boot/dts/renesas/r8a77995.dtsi                      | 1 +
 13 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.25.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
