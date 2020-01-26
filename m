Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7149149CAF
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgAZUGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:06:22 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:9570 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZUGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 15:06:21 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2020 15:06:20 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580069180;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FOKRqZKiYN4ZS+sSz57FNY4af5eAANqrgGGZiRiCefI=;
        b=V2jmTReDWG/WEPXfmXfGzrhorXm38C9891WkNBKR0D27ZyJ2+YVIp8lJ9E/WT3sxSu
        dCFVwKNs5MFuIyFQ7hSGQS4aTvHN8xlkqmy4ZZt2dkfdTPhSsf4n/DvTYmCVka94R+Ck
        DdxVmTWkwifQrSAn4Bsx6b24B0zm+wDUoU3pttvtiu22tUC4HjSBgy3ghyeMeW3VzbqE
        ePuYVmbInVMluIkqciVF+920OrevmDcWXqhEgHZ85bFy+YZkt1iZp0GSlW1LCgeuQLjB
        LqMpSGqJq2L93PEXKGcedIzeaAslfACP3SgeKvzsRT9Qpv5ZkGQP9DhwvxjElz9eA7dv
        pEEw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2AyPQjcv7w="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.7 DYNA|AUTH)
        with ESMTPSA id k0645aw0QK0EF2F
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 26 Jan 2020 21:00:14 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: [PATCH v3 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
Date:   Sun, 26 Jan 2020 21:00:13 +0100
Message-Id: <d34183026b1a46a082f73ab3d0888c92cf6286ec.1580068813.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1580068813.git.hns@goldelico.com>
References: <cover.1580068813.git.hns@goldelico.com>
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

