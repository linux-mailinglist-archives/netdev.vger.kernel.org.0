Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B30537AE4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiE3M5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiE3M5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:57:36 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73085101CE;
        Mon, 30 May 2022 05:57:32 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UCDg4J004646;
        Mon, 30 May 2022 05:57:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=KUOaiXdtrNFz+pU87J94GmVNlBDbYQuMw0tvy80h41Y=;
 b=grBir0/uqiS4o45ISjuhi+2NgHk5NVmZ7/RBUYL11sU1EIA4KoUAsayW9nxMZH1wulCH
 QHyufc4k9p/XGuEAFiVVwsKkoFpi2Vu0Kf9xHfKUlIRl6Mc0yvZwSUq7sztOQgfx8am5
 LwdLvPobQp56TBx0HlvggQNSgTHVoD0goWIYHe/TNTez7rhB9q25fXvIaMemOx3hFlNU
 YX+QtCwVEdWGRmXX3Vc4lU44hvTHI5mkAzBpcIXId74OpefKUQAFySeyr8MsoBkqBIm2
 qVzzr7z20pSep6IJqNDb+Xkhw5fRgNLbnUjJwkOj7HnKDmVZ86WqWwQCEx8xIInw2/7J wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gbk8n5fd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 05:57:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 May
 2022 05:57:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 May 2022 05:57:21 -0700
Received: from localhost.localdomain (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id CFA7F3F7048;
        Mon, 30 May 2022 05:57:20 -0700 (PDT)
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <cchavva@marvell.com>, <deppel@marvell.com>,
        Piyush Malgujar <pmalgujar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 2/3] dt-bindings: net: cavium-mdio.txt: add clock-frequency attribute
Date:   Mon, 30 May 2022 05:53:27 -0700
Message-ID: <20220530125329.30717-3-pmalgujar@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220530125329.30717-1-pmalgujar@marvell.com>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OyHbLr-8lWooY_zkqHNwv509e02rDhId
X-Proofpoint-GUID: OyHbLr-8lWooY_zkqHNwv509e02rDhId
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_04,2022-05-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to configure MDIO clock frequency via DTS

Signed-off-by: Damian Eppel <deppel@marvell.com>
Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
---
 Documentation/devicetree/bindings/net/cavium-mdio.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cavium-mdio.txt b/Documentation/devicetree/bindings/net/cavium-mdio.txt
index 020df08b8a30f4df80766bb90e100ae6210a777b..638c341966a80823b9eb2f33b947f38110907cc1 100644
--- a/Documentation/devicetree/bindings/net/cavium-mdio.txt
+++ b/Documentation/devicetree/bindings/net/cavium-mdio.txt
@@ -41,6 +41,9 @@ Properties:
 
 - reg: The PCI device and function numbers of the nexus device.
 
+- clock-frequency: MDIO bus clock frequency in Hz. It defaults to 3.125 MHz and
+		   and not to standard 2.5 MHz for Marvell Octeon family.
+
 - #address-cells: Must be <2>.
 
 - #size-cells: Must be <2>.
@@ -64,6 +67,7 @@ Example:
                         #address-cells = <1>;
                         #size-cells = <0>;
                         reg = <0x87e0 0x05003800 0x0 0x30>;
+                        clock-frequency = <3125000>;
 
                         ethernet-phy@0 {
                                 ...
@@ -75,6 +79,7 @@ Example:
                         #address-cells = <1>;
                         #size-cells = <0>;
                         reg = <0x87e0 0x05003880 0x0 0x30>;
+                        clock-frequency = <3125000>;
 
                         ethernet-phy@0 {
                                 ...
-- 
2.17.1

