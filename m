Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28D34D36BE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiCIQgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiCIQcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:32:47 -0500
Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [85.215.255.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B03DF5403;
        Wed,  9 Mar 2022 08:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646843176;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=+VSCMatbyH76KC33hEonHOTYQE2t7bjYbaDc7Ro+kQY=;
    b=Quz1wpa7Nm2lKtSzxsxlI31HbReJxOEeR3CWkgEgLa5w2J1RV9RvrmjA3Lsp9M6VU/
    BhvzpbHfJ22t0lFfLnTpUIKXEqRmY/fKS4Qahk8qLwJiIkFxx/uO7nGtV4lyruopaFS7
    KUNzD4MHGzASC2S8g11qmwdQgVt6wt0jKx7bVuDdXXxSLlifHKIFZzm2B/j1LRCeEeo0
    vP9zAJqhhhzrvXIdJidEZOe+9u+plUYPa96nbhWX2NaATWlsiiFZqjc+B8wk5GgiQt+M
    VuyotUfmW3qjKev8ChsJ05OtVSdtCJo2YM34A1uT4EeHvan757AW4UPArr6CaDpQ1NQp
    GYzg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82Fcd2Ywjw=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.40.1 DYNA|AUTH)
    with ESMTPSA id 646b0ey29GQFJWE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Mar 2022 17:26:15 +0100 (CET)
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
Subject: [PATCH v4 3/4] arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
Date:   Wed,  9 Mar 2022 17:26:08 +0100
Message-Id: <20220309162609.3726306-4-uli+renesas@fpond.eu>
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
@@ -65,4 +65,28 @@ pins_mii {
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
2.30.2

