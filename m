Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C1B426134
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbhJHAZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242778AbhJHAZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141FC061773;
        Thu,  7 Oct 2021 17:23:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so16319308eda.4;
        Thu, 07 Oct 2021 17:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7JaUG9XOtD68taTwa7qpisFGXs4Xezjwxb6ClFFnC0M=;
        b=ScpPoxpotHZlf9VuAI4voqjYT+NUhg90FxRgRfuK5XJmBbpC4hXlSR75ZMIYcTxTbc
         Bb5ew/CTOj3nUrwbxe3xZfwxlK+JfRAwT1xHq4IxqrMLFUdAOEkhJ4JYdI156Rj59Q1h
         N6v98812LbSeWUqUVaRA1RfZAtBbYfZUNwkV2EeEFrjBjupzqBCnDiyz7bIpMlcQWqah
         g3AG/ZmX33ReOrvxRVxA6UXQnlvexdrPlNnESTWXeLREqJMjIDkfdxudAD4B9uqIGP+L
         UDtg5zApNtEI7+L/lfZPvhAcWfOCPfEQjgnZ4hRsCriID4rOw/QdQQXwQbZnTQR1OGQt
         QQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JaUG9XOtD68taTwa7qpisFGXs4Xezjwxb6ClFFnC0M=;
        b=3s8GeAv0Ad5O95lJA7vzlun2oRscBjPr3ST1aJ4bHLbk7HTPYgsd3BEsDkF69xQeqx
         yLgxO9emUHRe26cvMkpEiJxn3rjhM7xCRn9E3pgYAOnrOR1+rmg7aBZ91Pl3yeaobo3/
         oN3hh/WCLB4W9AwJGxzNCsPEKj7+Z1TbrnHJvCUUkOgRvPyrV24TvU09DqhuE8iSTDPD
         1NMbI0+HtFWUGyLapvXr30wkzv7HafPNwlw7an1UnLBL4d+zgVIZ5CwkJaHvHRAoUgWC
         fFQ/TcR1/6rVrqcxL4ysrQFD2DSi+o0+FKGXXokGZNeIF4yzxHnaBgqovv7ZAH5iaZwv
         HZfQ==
X-Gm-Message-State: AOAM532zNcZ8WGffa24n/C0aK5m7P+RB+qLU3/ywB9TNFe33Ase33x9/
        goszOlsz0in9av9r3SuXMq46mkrl0OM=
X-Google-Smtp-Source: ABdhPJzK7UKENaG96vxEfsfv4vQaH6ehc41I0AWUu9arPTJohl2Qgr7xzvxfsTnqmPqj7ioFapDYqw==
X-Received: by 2002:a17:906:b183:: with SMTP id w3mr146748ejy.394.1633652591212;
        Thu, 07 Oct 2021 17:23:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:11 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 11/15] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Fri,  8 Oct 2021 02:22:21 +0200
Message-Id: <20211008002225.2426-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document qca,sgmii-enable-pll binding used in the CPU nodes to
enable SGMII PLL on MAC config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 208ee5bc1bbb..b9cccb657373 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -50,6 +50,12 @@ A CPU port node has the following optional node:
                           managed entity. See
                           Documentation/devicetree/bindings/net/fixed-link.txt
                           for details.
+- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
+                          chain along with Signal Detection.
+                          This should NOT be enabled for qca8327.
+                          This can be required for qca8337 switch with revision 2.
+                          With CPU port set to sgmii and qca8337 it is advised
+                          to set this unless a communication problem is observed.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

