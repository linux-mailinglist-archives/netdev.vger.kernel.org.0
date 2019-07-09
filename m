Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4063657
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfGINBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:01:34 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.134]:15962 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfGINBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562677290;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=yZFSZarwrfLVOtNyEWb+j9fYESRw53un+LCy+I41Z5g=;
        b=pMqErDPt2ls4EV7aKzP00mGVbjDLwyZRGMj8jUDbpjgLu7jcWx/T5hhHexe+jewDJP
        KWwYjvhxa7t5Zmb6J3c7WUp8jvyIGdKBy76eKf4RyMlilN1EFoiIMMCH1KkxSjBD+lSh
        pWVWggBahV1+pFD6WWAQdq2tea1DJF8Oj5NXZidhNsR1zldjL8WUED7CUyqqsGQQGvwA
        xSvTAFtG2HQxsC5xRDWpZBvEbpEGspE7TDxcJg5gV9mAvr01v0ssECvrtcVdm0r9wAGU
        GBddPc3vMHXaZnSCIufOzjCp0uhC02zxf5irWwS143Tg88bU+qFlHJGF9BVj5JmDM6ea
        dk7g==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v69D1IEg7
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 9 Jul 2019 15:01:18 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 1/4] dt-bindings: allow up to four clocks for orion-mdio
Date:   Tue,  9 Jul 2019 15:00:58 +0200
Message-Id: <20190709130101.5160-2-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190709130101.5160-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190709130101.5160-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
Update the binding to allow the extra clock to be specified.

Cc: stable@vger.kernel.org
Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
index 42cd81090a2c..3f3cfc1d8d4d 100644
--- a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
+++ b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
@@ -16,7 +16,7 @@ Required properties:
 
 Optional properties:
 - interrupts: interrupt line number for the SMI error/done interrupt
-- clocks: phandle for up to three required clocks for the MDIO instance
+- clocks: phandle for up to four required clocks for the MDIO instance
 
 The child nodes of the MDIO driver are the individual PHY devices
 connected to this MDIO bus. They must have a "reg" property given the
-- 
2.16.4

