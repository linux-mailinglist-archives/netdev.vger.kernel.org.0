Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483F3159B7B
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgBKVna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:43:30 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.223]:30035 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgBKVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 16:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581457309;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=o2aaGn+CrBGGFUCI/aU8qBP4BNQ+G25EUxt570OpKBY=;
        b=t1kKf1CMl2v02AQpB3xHcmj4Dwxsrce6Ucp3Rcn2L1lWyYSByeffFSbhC+r41q3yHX
        lLn9+LSSK0DoXI92s8wQTScT/9lPlD/FN78j2F6yRvjzdbk3vH61iWQcS9oMM5gE4xHo
        cfAo8P8fjbAbfFvjFgTC8DashBNNSv3MWZnqXz8f3swQW/cwTZjpEj8cYfQwpY1dh6f3
        EY/kk65s88jgzkkzoZlm4swb/r8yQStVRScd9ztP30xqhhVE8hKVhddNhMS9XujJR/Eb
        t/t3XPa/lGpGlztn0IH/WYmkopg9ceV7NYFJPB2t+jgIpYMs5k7dL54AxkvgCiDdI/ZD
        3gLQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M0P2mp10IM"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1BLfc0EO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 11 Feb 2020 22:41:38 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH 08/14] MIPS: CI20: defconfig: configure CONFIG_REGULATOR_ACT8865 for PMU
Date:   Tue, 11 Feb 2020 22:41:25 +0100
Message-Id: <123a132d735a02c1fcbf989c25551a616b1cb991.1581457290.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1581457290.git.hns@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PMU on the CI20 board is an ACT8600 using the ACT8865 driver.
Since it is not compiled, the PMU and the CI20 board is running in
power-on reset state of the PMU.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/mips/configs/ci20_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
index 30a47a7a2994..74e5775b8a05 100644
--- a/arch/mips/configs/ci20_defconfig
+++ b/arch/mips/configs/ci20_defconfig
@@ -95,6 +95,7 @@ CONFIG_JZ4740_WDT=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_DEBUG=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
+CONFIG_REGULATOR_ACT8865=y
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
-- 
2.23.0

