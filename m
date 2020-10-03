Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6699D282321
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJCJa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:30:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD213C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:30:56 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601717454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0UmUWbzqKqAm61ATEp90pjpjG5yUC1rRvmCJHQnTi3g=;
        b=mazO1/YhqbGzZPG9mJTZyYCeAyPUeldbCY5CJelblEb3rsg6yrVnJ3R+RX/+CQ0/EhHDFv
        ccyS3wmGVPcu21FIisUkNniV0lKkIb3wb6Uwn2onnIOE6yna3ACNf63xjdvXiXvXDYIjVc
        Yj1Yjb9klEMcW09cyb5Cg5W/mlsJ6X4dgmtpuPmE2OtxMVHEeWoFgNnZSMiedzzgj7h/TL
        rf9lYnuZ09p1cYcbVDlgAlTMA2w4e1JlPIk+DxspHY7WvsNKgGSgJCw0XQp2C71Y0Ad3Ai
        bKUTnPv3Av7q3yyIldMpJ1IZP78bVGMlu00xew/i8MNanWpk0RnIXyCiSk1jOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601717454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0UmUWbzqKqAm61ATEp90pjpjG5yUC1rRvmCJHQnTi3g=;
        b=P69LsmKaHTl4fHWVHtrhT3rcgpmlok2FnqpU+JyDCSTcwFknU9y05eJFxgL7mq6re3xPWr
        oZFBOjc41vmjmbAg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Specify unit address in hex
Date:   Sat,  3 Oct 2020 11:30:50 +0200
Message-Id: <20201003093051.7242-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The unit address should be 1e, because the unit address is supposed
to be in hexadecimal.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Documentation/devicetree/bindings/net/dsa/b53.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
index 80437b2fc935..3bb4e1086913 100644
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
@@ -104,7 +104,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		switch0: ethernet-switch@30 {
+		switch0: ethernet-switch@1e {
 			compatible = "brcm,bcm53125";
 			reg = <30>;
 			#address-cells = <1>;
-- 
2.20.1

