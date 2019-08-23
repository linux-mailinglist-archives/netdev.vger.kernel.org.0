Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3E9AD3B
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405217AbfHWKcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:32:06 -0400
Received: from vps.xff.cz ([195.181.215.36]:52686 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390851AbfHWKbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566556307; bh=y/VyM0hZNMJuHkjWlJoe2Ll8Mns+SaZDNjGgFDEV18I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=PsR9yChwkB7y4rgbtoOSmoYDza6Ag6WO9cQo+O/jRPIDy9UCjPuVe8rhS69ui8GiY
         TpwekQ9n9eRPnZh42uFqZ13fVEVMOdM0UUbH5Rd2SNEvxa+uYgjMV/t8xaCvJxdaEu
         asrCvCfzNX139HnJBnxAHX+u6vT6YM0SlZVcZiKA=
From:   megous@megous.com
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, Ondrej Jirman <megous@megous.com>
Subject: [RESEND PATCH 4/5] arm64: dts: allwinner: h6: Add pin configs for uart1
Date:   Fri, 23 Aug 2019 12:31:38 +0200
Message-Id: <20190823103139.17687-5-megous@megous.com>
In-Reply-To: <20190823103139.17687-1-megous@megous.com>
References: <20190823103139.17687-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 uses UART1 for bluetooth. Add pinconfigs so that we can use
them.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 67f920e0fc33..7657e816096b 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -298,6 +298,16 @@
 				pins = "PH0", "PH1";
 				function = "uart0";
 			};
+
+			uart1_pins: uart1-pins {
+				pins = "PG6", "PG7";
+				function = "uart1";
+			};
+
+			uart1_rts_cts_pins: uart1-rts-cts-pins {
+				pins = "PG8", "PG9";
+				function = "uart1";
+			};
 		};
 
 		gic: interrupt-controller@3021000 {
-- 
2.23.0

