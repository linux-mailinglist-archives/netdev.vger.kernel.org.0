Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D0E123468
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfLQSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:07:15 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.121]:21044 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfLQSHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 13:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576606032;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FOKRqZKiYN4ZS+sSz57FNY4af5eAANqrgGGZiRiCefI=;
        b=H3XAcSRjWVb5vcnJwTI4gPP3g2d6klTAeL4GRUZWKoop/m+Z91ZRu+9vYxlJ2IJZ/b
        is3Rp3wYNf+0wxDeOrS3BSUYc1qwTAFZt6wPRGVxqvd8P9HVPRv6narrfCH1e6SeM/yz
        VfHydbSkx61AJ2pwZV3218oMMH9w3mfugnEjk8Reci49cP0WmoPYTif4wBClgTiLOcbV
        kKeYijn/xfl9X4vdobixpY+m+cwKWa7tRD8z+AAi5QSLkVKthd4QaRtVDgKB6Ob2+jVF
        ASAew8XGpqH3/loNilIDvl5V2hdoWxodsUj01f9g3uk1CJiLYJj02wKu0X7Zkq2khbnP
        u+3A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH5Hd8HaSCa"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id q020e2vBHI722eT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 17 Dec 2019 19:07:02 +0100 (CET)
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
Subject: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
Date:   Tue, 17 Dec 2019 19:06:59 +0100
Message-Id: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1576606020.git.hns@goldelico.com>
References: <cover.1576606020.git.hns@goldelico.com>
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

