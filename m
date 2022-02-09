Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2679B4AF700
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiBIQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbiBIQlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:41:18 -0500
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687BDC0612BE;
        Wed,  9 Feb 2022 08:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644424698;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=0/+rtaWqC3Y6vY0W2DoeTr2CRmudTPx4JzEQgGhnj5M=;
    b=QAi0rioTAhqTxjIgKqiN+IJ1SGNGH1IJhk6FuAwFF6Ak6AV7qUwnKeNmUCf3gLNFsm
    d4jRhRmWScyXzi9zlaYaO3583hmuBrLhxVFxgglk3z6tIaNic4OsnYfp2rboyLXkS2BH
    PixbSobRteYapMvjwWlRdQad0kdKr79uePTFYqk1QKtG07IugKp8A7MixZid+CsTOf/A
    xYur86iMuuSXwT6YAegY53khxi4AfJhFOeUWP7eYdZRm/h4ABOobDyzj9jLdAOzCSjue
    X5pz3qoxQWzebyLfcyh9TYwOS6JAup+oblawiHSPvRRZgLekGDILA7l5+lHclK5fdoWI
    Rwiw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82dfdzLc5sE="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.39.0 DYNA|AUTH)
    with ESMTPSA id ufcb0fy19GcI7bw
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
Subject: [PATCH v3 3/4] arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
Date:   Wed,  9 Feb 2022 17:38:05 +0100
Message-Id: <20220209163806.18618-4-uli+renesas@fpond.eu>
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

Enables confirmed-working CAN interfaces 0 and 1 on the Falcon board.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../boot/dts/renesas/r8a779a0-falcon.dts      | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts b/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
index e46dc9aa0a43..75e27f950ac0 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
@@ -65,4 +65,28 @@
 		};
 
 	};
+
+	canfd0_pins: canfd0 {
+		groups = "canfd0_data";
+		function = "canfd0";
+	};
+
+	canfd1_pins: canfd1 {
+		groups = "canfd1_data";
+		function = "canfd1";
+	};
+};
+
+&canfd {
+	pinctrl-0 = <&canfd0_pins>, <&canfd1_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	channel0 {
+		status = "okay";
+	};
+
+	channel1 {
+		status = "okay";
+	};
 };
-- 
2.20.1

