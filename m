Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAABA330EE3
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCHNJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhCHNJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:09:00 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D3C06174A;
        Mon,  8 Mar 2021 05:09:00 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id c10so20220303ejx.9;
        Mon, 08 Mar 2021 05:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COQSx+BU5m3hRHXgEDr9pW1DvKqmkyBSspURkSZqzdo=;
        b=SkRZUSy+Q+ZZJNP90Qf0zfiJEPy6Z1GxVFohwD8Jo95gY0KNjktEBZlSfd5w38WenP
         9Hou8ZCGQ45HNXyzyGbCZg90OWu9Jg8gIOuUB5gKGVctiM8bLb7JK1dXaRjqGzetfdra
         bs32OYys8L3ymP15WNcfESDAM7OuMENaHahxJd2k4Oh+3M9IjIlg+rT/YlBTU/WHZxPi
         zS0okbJVsrVsP5BQ0cs+lGTZ0vqsKlp868sgvIX+Tk5eT0AzABC/7dv/++ZmpzDCy49A
         ntCiVOl9WHz7HmLs2YwTBgpixyWvGgtnAEBTbJITYhRQyaGc0LqXyMiQjGhVSrW1/qIG
         EMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COQSx+BU5m3hRHXgEDr9pW1DvKqmkyBSspURkSZqzdo=;
        b=k3TCEweBLrNVVZhsnjo20R+boSYdPos3RGXHhhq1QDv0Yy2OACO0TbXnYhCbN59kFK
         /Q/3kVp7zDxHs43FtzDbCrqus1lwPc9JHj2vdbUcIhtPHV14vENwVl+64CLj9w7qmj+o
         LdZePWAoCAXGWT9hFFrVYsVqEfRRKAyJHIelfwcX1smvQ6AKpmwe64v/1ytIUJiB9/bM
         r4KeKWz3GAS30R1IwnDX7CDIV3VUi/YRIu1rD2jxHkJfbFjHpIxz5pdWRhs2cuPdcRaq
         qpI75qMYvtlYFb1QJSbPeHgpZPCEI5Rr9NN9468di26etSEwSBeVDYwuHF2cpACLNrsC
         ZsPg==
X-Gm-Message-State: AOAM531YG66JgmN/PtVq7dk6LwqvD/zr8CLhxmMRek3cW5J322pidi0A
        PcEfPXNa0/PwGCWOdRrhwxQ=
X-Google-Smtp-Source: ABdhPJy3vySAVrTjjiQgeBSEnREDCrTSbGTD/9AOrzK/k5Q1/va3eokyUO1aWkkFREtDsjtHe+Ht0Q==
X-Received: by 2002:a17:906:2db2:: with SMTP id g18mr15307428eji.73.1615208938930;
        Mon, 08 Mar 2021 05:08:58 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id s13sm7260961edr.86.2021.03.08.05.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 05:08:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH devicetree] arm64: dts: ls1028a: set up the real link speed for ENETC port 2
Date:   Mon,  8 Mar 2021 15:08:34 +0200
Message-Id: <20210308130834.2994658-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In NXP LS1028A there is a MAC-to-MAC internal link between enetc_port2
and mscc_felix_port4. This link operates at 2.5Gbps and is described as
such for the mscc_felix_port4 node.

The reason for the discrepancy is a limitation in the PHY library
support for fixed-link nodes. Due to the fact that the PHY library
registers a software PHY which emulates the clause 22 register map, the
drivers/net/phy/fixed_phy.c driver only supports speeds up to 1Gbps.

The mscc_felix_port4 node is probed by DSA, which does not use the PHY
library directly, but phylink, and phylink has a different representation
for fixed-link nodes, one that does not have the limitation of not being
able to represent speeds > 1Gbps.

Since the enetc driver was converted to phylink too as of commit
71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX"), the limitation
has been practically lifted there too, and we can describe the real link
speed in the device tree now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 262fbad8f0ec..bf60f3858b0f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1027,7 +1027,7 @@ enetc_port2: ethernet@0,2 {
 				status = "disabled";
 
 				fixed-link {
-					speed = <1000>;
+					speed = <2500>;
 					full-duplex;
 				};
 			};
-- 
2.25.1

