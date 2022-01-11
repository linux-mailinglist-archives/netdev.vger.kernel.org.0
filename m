Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D64448B222
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349970AbiAKQ2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:28:40 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.101]:33667 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343719AbiAKQ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918162;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=vO8GJaNAbF5R3pgLp5BXrfSzQRuLbozBLegd5OaGRrw=;
    b=gIX4DUK2YX9EIDD9GZsv/xykFlX5w4db4Covn7pSPV++18/YQGTzv+UVB+Gj/PTFp3
    BPAB21DPTc5n5nDBbgk0h8iJtXwwFaQkwwp+2/m+aEeUqiRspkGW4YVeTvOz74tpQ0tz
    Nk05GJgTGM/VBmgrax3lA/Q0806SdTlpRj9lSNC2//Li+BsxYD26JrDc+TM6w7DzTAMZ
    DjEuOKc4/HMrjDUPVKNk0fbOPDlwlv3lVNaYny0HkOKJkvQwPRoEgiIY+ebuzGI2gp6d
    VX7wCMppXvA+Wi+bSiQD8eJI/v4+CxSbbLCLD3NbJQGy7EPcIGkh1QkFWuJYV7g+yMYm
    52FQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8nxYa0aI"
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id a48ca5y0BGMfHKu
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:22:41 +0100 (CET)
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
Subject: [PATCH v2 4/5] arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
Date:   Tue, 11 Jan 2022 17:22:30 +0100
Message-Id: <20220111162231.10390-5-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220111162231.10390-1-uli+renesas@fpond.eu>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enables confirmed-working CAN interfaces 0 and 1 on the Falcon board.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
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

