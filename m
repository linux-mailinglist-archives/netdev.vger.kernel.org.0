Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4C433637
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhJSMpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbhJSMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:45:35 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3E0C061765
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:43:22 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:b4c3:ba80:54db:46f])
        by michel.telenet-ops.be with bizsmtp
        id 7ojF2600T12AN0U06ojFz9; Tue, 19 Oct 2021 14:43:20 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSZ-0069O3-4O; Tue, 19 Oct 2021 14:43:15 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSY-00EESZ-FR; Tue, 19 Oct 2021 14:43:14 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/3] dt-bindings: net: TI wlcore json schema conversion and fix
Date:   Tue, 19 Oct 2021 14:43:10 +0200
Message-Id: <cover.1634646975.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

This patch series converts the Device Tree bindings for the Texas
Instruments Wilink Wireless LAN and Bluetooth Controllers to
json-schema, after fixing an issue in a Device Tree source file.

Thanks for your comments!

Geert Uytterhoeven (3):
  ARM: dts: motorola-mapphone: Drop second ti,wlcore compatible value
  dt-bindings: net: wireless: ti,wlcore: Convert to json-schema
  dt-bindings: net: ti,bluetooth: Convert to json-schema

 .../devicetree/bindings/net/ti,bluetooth.yaml |  91 ++++++++++++
 .../devicetree/bindings/net/ti-bluetooth.txt  |  60 --------
 .../bindings/net/wireless/ti,wlcore,spi.txt   |  57 --------
 .../bindings/net/wireless/ti,wlcore.txt       |  45 ------
 .../bindings/net/wireless/ti,wlcore.yaml      | 134 ++++++++++++++++++
 .../boot/dts/motorola-mapphone-common.dtsi    |   2 +-
 arch/arm/boot/dts/omap3-gta04a5.dts           |   2 +-
 7 files changed, 227 insertions(+), 164 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml

-- 
2.25.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
