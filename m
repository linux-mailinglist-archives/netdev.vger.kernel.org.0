Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236BC38B0C0
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhETOBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243564AbhETOAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:00:14 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E88DC061761
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:58:50 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by baptiste.telenet-ops.be with bizsmtp
        id 71yi2500H31btb9011yiMQ; Thu, 20 May 2021 15:58:46 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCE-007Wn1-5o; Thu, 20 May 2021 15:58:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-008zrO-GY; Thu, 20 May 2021 15:58:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/5] sms911x: DTS fixes and DT binding to json-schema conversion
Date:   Thu, 20 May 2021 15:58:34 +0200
Message-Id: <cover.1621518686.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

This patch series converts the Smart Mixed-Signal Connectivity (SMSC)
LAN911x/912x Controller Device Tree binding documentation to
json-schema, after fixing a few issues in DTS files.

Thanks for your comments!

Geert Uytterhoeven (5):
  ARM: dts: i.MX51: digi-connectcore-som: Correct Ethernet node name
  ARM: dts: imx53-ard: Correct Ethernet node name
  ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq
    property
  MIPS: SEAD3: Correct Ethernet node name
  dt-bindings: net: sms911x: Convert to json-schema

 .../devicetree/bindings/net/gpmc-eth.txt      |   2 +-
 .../devicetree/bindings/net/smsc,lan9115.yaml | 107 ++++++++++++++++++
 .../devicetree/bindings/net/smsc911x.txt      |  43 -------
 .../boot/dts/imx51-digi-connectcore-som.dtsi  |   2 +-
 arch/arm/boot/dts/imx53-ard.dts               |   2 +-
 .../arm/boot/dts/qcom-apq8060-dragonboard.dts |   4 +-
 arch/mips/boot/dts/mti/sead3.dts              |   2 +-
 7 files changed, 112 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/smsc,lan9115.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/smsc911x.txt

-- 
2.25.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
