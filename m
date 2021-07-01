Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F673B9173
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhGAME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhGAME4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:04:56 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6C1C0617AE
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 05:02:25 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:445e:1c3:be41:9e10])
        by michel.telenet-ops.be with bizsmtp
        id Po2P2500a474TTe06o2PAE; Thu, 01 Jul 2021 14:02:24 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lyvOh-005MHS-6G; Thu, 01 Jul 2021 14:02:23 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lyvOg-00EXS9-KF; Thu, 01 Jul 2021 14:02:22 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 0/2] sms911x: DTS fixes and DT binding to json-schema conversion
Date:   Thu,  1 Jul 2021 14:02:19 +0200
Message-Id: <cover.1625140615.git.geert+renesas@glider.be>
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

Changed compared to v1[1]:
  - Dropped applied patches,
  - Add Reviewed-by,
  - Drop bogus double quotes in compatible values,
  - Add comment explaining why "additionalProperties: true" is needed.

Thanks!

[1] [PATCH 0/5] sms911x: DTS fixes and DT binding to json-schema conversion
    https://lore.kernel.org/r/cover.1621518686.git.geert+renesas@glider.be

Geert Uytterhoeven (2):
  ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq
    property
  dt-bindings: net: sms911x: Convert to json-schema

 .../devicetree/bindings/net/gpmc-eth.txt      |   2 +-
 .../devicetree/bindings/net/smsc,lan9115.yaml | 110 ++++++++++++++++++
 .../devicetree/bindings/net/smsc911x.txt      |  43 -------
 .../arm/boot/dts/qcom-apq8060-dragonboard.dts |   4 +-
 4 files changed, 112 insertions(+), 47 deletions(-)
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
