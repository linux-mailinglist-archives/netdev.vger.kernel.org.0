Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383291082E9
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKXKgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:36:05 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:20346 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKXKgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 05:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574591762;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FOKRqZKiYN4ZS+sSz57FNY4af5eAANqrgGGZiRiCefI=;
        b=rNbz4trIZvrPGzaCWxRRRYt2Pe3c8iWQsf/4IuJ7RXtAMa5H0FOQFPTb9bjAQ5KT3s
        DgKCf17JtLlxtjn3LuTXnGBQggDQ7KGPlEcCcElBaq8T/OGU/elTL363gWqFZf3V+RIj
        HNobdQl/c81g044EMwID+5A/QVBBFzSusEVxexQgeRTyKnTKKKiS61xpHdtvakZZ/k7T
        hwvS6/n6y5d6Kg2tMGjX47oLuVDre+HG0gEfxkAB8HFiQ4qJ0gZn6qCQNey5LZNFO/Sa
        IEGdpVs22m08nOzaEG3a/vPWg7p1/aJWSLRxuyuM6UHgGoPXskx+ZskMR0F7CsvmT9Nt
        EDkg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH4HEaKeuIV"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vAOAZmw8v
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sun, 24 Nov 2019 11:35:48 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: [PATCH 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
Date:   Sun, 24 Nov 2019 11:35:45 +0100
Message-Id: <c95e814deed075352a05c392147e9458b0d1a447.1574591746.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1574591746.git.hns@goldelico.com>
References: <cover.1574591746.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is now only useful for SPI interface.
Power control of SDIO mode is done through mmc core.

Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
index f38950560982..88fd28d15eac 100644
--- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
@@ -9,11 +9,12 @@ Required properties:
 - spi-max-frequency : Maximum SPI clocking speed of device in Hz
 - interrupts :        Should contain interrupt line
 - vio-supply :        phandle to regulator providing VIO
-- ti,power-gpio :     GPIO connected to chip's PMEN pin
 
 Optional properties:
 - ti,wl1251-has-eeprom : boolean, the wl1251 has an eeprom connected, which
                          provides configuration data (calibration, MAC, ...)
+- ti,power-gpio :	 GPIO connected to chip's PMEN pin if operated in
+			 SPI mode
 - Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
   for optional SPI connection related properties,
 
-- 
2.23.0

