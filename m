Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046514284AF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhJKBdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhJKBcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D2C061773;
        Sun, 10 Oct 2021 18:30:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w14so9364995edv.11;
        Sun, 10 Oct 2021 18:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=fEHVnzIDBOwywq4tRKSVWk97ytARebLVl76qcOY98he91yLZKJBZR1XWaXHCTtKa0/
         eP3whMIjACOD+ZBd1GMXoy+5PHITnFY+1lIzelYMpDKOPBpEYXgoeu/HvfVV+g+spQCO
         CSNU/pMNDc5v9eLrXM9GI1Tulq/eKpDJ43NTDvOZ96HZz2faJ4uluUcz/+inFVaDnf45
         dPF/837VHFZ7LOsGsd2Evo1FWBcBQ2YyT/xsOk8yYUa9iPKY+RPRYp4XWeVWF7jFB30N
         iBBCv8uEnkx+usHAoLs6eqNcZgsxfBkpAoTXZrHj+vqD5JgfZATvsnIXPCXtL/g1uICE
         SVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=RMtenpwE+8wj3Zrg/KmNWW3R4CqbVslZypDmKcH9S+U0KEQiXzZt1l2qjYOZ3KBVPz
         5ii78VlsVIZjqXY2NXvGpbWBOjEUPyC3jUcz1IaJHEbQ4QvpOw+Ko5uuskmY358Y6INz
         2PaMailOwablppAhZlzjA6kWwJWsfQ4QAENoU76ObfrPpWoIIckyi6A07AVhF3zNz9C2
         +LM7a04Wt8Ouuaf6g1CY1PjN5EETElFaFaE7RRQpsFnpKYQ19xuJJFZ4ttjytJMMnjLn
         qw1BGaDd6S/8AtN9vNWfI9y9LDDV4onvYuOjygiMWXFrZw+dNV3GX5QIyT1rDpDkCWSj
         q6KQ==
X-Gm-Message-State: AOAM5302tbj2eSaCuXM1CPO+ILZtoAbyjiw/Qyzxat2hkOwMyHNA+HwT
        XWcBEN26rbwKOiU4jOZcsv8=
X-Google-Smtp-Source: ABdhPJxf/ARbDIn9m5eT8AJj+c3P0+tte2qThrNSfw4rol37bIIw2FLnHa96t2c/vBNSFSoVHxexbg==
X-Received: by 2002:a17:906:8a45:: with SMTP id gx5mr15641051ejc.144.1633915849896;
        Sun, 10 Oct 2021 18:30:49 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:49 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 07/14] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Mon, 11 Oct 2021 03:30:17 +0200
Message-Id: <20211011013024.569-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document qca,sgmii-enable-pll binding used in the CPU nodes to
enable SGMII PLL on MAC config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index aeb206556f54..05a8ddfb5483 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -45,6 +45,16 @@ A CPU port node has the following optional node:
                                 Mostly used in qca8327 with CPU port 0 set to
                                 sgmii.
 - qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
+- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
+                          chain along with Signal Detection.
+                          This should NOT be enabled for qca8327. If enabled with
+                          qca8327 the sgmii port won't correctly init and an err
+                          is printed.
+                          This can be required for qca8337 switch with revision 2.
+                          A warning is displayed when used with revision greater
+                          2.
+                          With CPU port set to sgmii and qca8337 it is advised
+                          to set this unless a communication problem is observed.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

