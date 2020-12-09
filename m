Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316EE2D43C6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgLIOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:00:35 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:54212 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728641AbgLIOAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:00:31 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C5F4941281;
        Wed,  9 Dec 2020 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1607522387; x=1609336788; bh=2rBLwXjbYaU6Lc0KkvDy5lJ3TXLcica6b7Q
        4dvDhu2Q=; b=EqoGWxES9XMSgFqnsVAFLX8oDuhC5lmzJ2nW2zRrGzzM3bAyvqy
        X6xxVaqICN7efEhBprZftEtagzFU36gdWKrAEEEA2Bi0JzwqeXkZbO5HiVViE6FB
        Ed/65wHNZIcfb48N+GDPUINKSdp9H72CTmF+pN5dD0aA2gqnnr1ws1y4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i6CYG39ScHEh; Wed,  9 Dec 2020 16:59:47 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9213B4129F;
        Wed,  9 Dec 2020 16:59:45 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.0.125) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 9 Dec 2020 16:59:44 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] dt-bindings: net: phy: micrel: add LED mode behavior and select properties
Date:   Wed, 9 Dec 2020 17:05:01 +0300
Message-ID: <20201209140501.17415-3-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201209140501.17415-1-i.mikhaylov@yadro.com>
References: <20201209140501.17415-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.125]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LED mode behavior and LED mode select properties which can be used
in KSZ9131 PHY.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 Documentation/devicetree/bindings/net/micrel.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index 8d157f0295a5..3022c979287a 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -16,9 +16,16 @@ Optional properties:
 	KSZ8051: register 0x1f, bits 5..4
 	KSZ8081: register 0x1f, bits 5..4
 	KSZ8091: register 0x1f, bits 5..4
+	KSZ9131: register 0x1a, bit  14
 
 	See the respective PHY datasheet for the mode values.
 
+ - micrel,led-mode-select
+	See the respective PHY datasheet for the mode select values.
+
+ - micrel,led-mode-behavior
+	See the respective PHY datasheet for the mode behavior values.
+
  - micrel,rmii-reference-clock-select-25-mhz: RMII Reference Clock Select
 						bit selects 25 MHz mode
 
-- 
2.21.1

