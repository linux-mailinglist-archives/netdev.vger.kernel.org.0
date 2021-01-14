Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A982F61A2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbhANNOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbhANNOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:14:23 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C49C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:13:42 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id GdDc240094C55Sk06dDcRQ; Thu, 14 Jan 2021 14:13:40 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l02RT-003YlL-HL; Thu, 14 Jan 2021 14:13:35 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l02RT-009NQ3-3Z; Thu, 14 Jan 2021 14:13:35 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 trivial/resend] dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/
Date:   Thu, 14 Jan 2021 14:13:33 +0100
Message-Id: <20210114131333.2234932-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The standard DT property name is "interrupt-names".

Fixes: fd913ef7ce619467 ("Bluetooth: btusb: Add out-of-band wakeup support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Rajat Jain <rajatja@google.com>
---
Who takes this patch, before it celebrates its 4th birthday?

v5:
  - Add Reviewed-by, Acked-by,

v4:
  - Add Acked-by,

v3:
  - New.
---
 Documentation/devicetree/bindings/net/btusb.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/btusb.txt b/Documentation/devicetree/bindings/net/btusb.txt
index b1ad6ee68e909318..c51dd99dc0d3cb73 100644
--- a/Documentation/devicetree/bindings/net/btusb.txt
+++ b/Documentation/devicetree/bindings/net/btusb.txt
@@ -38,7 +38,7 @@ Following example uses irq pin number 3 of gpio0 for out of band wake-on-bt:
 	compatible = "usb1286,204e";
 	reg = <1>;
 	interrupt-parent = <&gpio0>;
-	interrupt-name = "wakeup";
+	interrupt-names = "wakeup";
 	interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
     };
 };
-- 
2.25.1

