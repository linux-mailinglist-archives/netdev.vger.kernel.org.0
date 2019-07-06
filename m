Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E628B611E1
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGFPbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:31:13 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.130]:29948 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfGFPbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:31:13 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jul 2019 11:31:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562427071;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=6ZpbWk6c/a+q3XFLVvoxD8tk7MslyJIN8F03pvj5GTo=;
        b=o5YsGGR10DzdQO8lxWe7F8tJOh9nqSzpUhXhv+Btp1Uo9xcVHcmEexuYRuUByXBOt1
        yHxoIsxVthYEIwfCpGmYD5WZQvUuUXxCCeT4GFnVlXsDOUhyeesNz/qIH8+wdlbvjMKE
        zShPw9WqZuqGf5ftMlY4PfSzyL7VUCqP96FQCfFNLee/RkDL8fqgymQGnXcafah258Eb
        wEkNeY+gjgPJZwQ+CYqOmqkXovRAJKWuQZA0yOXbEcGEmK6aAFm28j0kEUvSzDc4O/lY
        2U1dXsfLZsGR2KunP0/YErnDcN0spZJV/nEpni+7EFF7BsnskTszOU6RhfnMF5HUBMK1
        6oEQ==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v66FJ96MV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 6 Jul 2019 17:19:09 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
Date:   Sat,  6 Jul 2019 17:18:57 +0200
Message-Id: <20190706151900.14355-2-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190706151900.14355-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
Update the binding to allow the extra clock to be specified.

Cc: stable@vger.kernel.org
Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
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

