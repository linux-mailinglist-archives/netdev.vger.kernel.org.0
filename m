Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5A187BE9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgCQJTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:19:11 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48632 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgCQJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:19:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D2CBE40217;
        Tue, 17 Mar 2020 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584436750; bh=i644QpwR/Pj8qreHw+wBacaYLXNNUovwNW3FcT/AZtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=OfZq2MZzAWJUiBUpabfvxRyce94+M7ijQWQWeKEUhxtu9YWe2XammtdJgjX/k+gpN
         opuPMxZKaZxEKAzNp3ufX54v74LfXi30TjuZbQdcuUrCeEVMF/ITbPDbdHLGSAkFaO
         jWXiTfoPbE4a6eV4FnWJMy+K1cPue227m8lK166/BkqVjOH0N7ZVa+gcb2MDA4R26l
         tsLpqH9i1syLaHaUbrhnzSt5muB48RABT18pmZJzEg2A42WlYdXCbufa1ryCMypL6v
         eLsCjC2uDjAKG2wYcokZ1pdEsU0B1hHpvZkXkpASDq3zw/f5yuioZ35pAmX8WX+m0L
         6axOiJyx8CTdw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 644BDA006E;
        Tue, 17 Mar 2020 09:19:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-doc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] Documentation: networking: stmmac: Mention new XLGMAC support
Date:   Tue, 17 Mar 2020 10:18:53 +0100
Message-Id: <b036ffbc3649297c5b08860c5b6776af025570a4.1584436401.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Enterprise MAC support to the list of supported IP versions and
the newly added XLGMII interface support.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/networking/device_drivers/stmicro/stmmac.rst | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/stmicro/stmmac.rst b/Documentation/networking/device_drivers/stmicro/stmmac.rst
index c34bab3d2df0..5d46e5036129 100644
--- a/Documentation/networking/device_drivers/stmicro/stmmac.rst
+++ b/Documentation/networking/device_drivers/stmicro/stmmac.rst
@@ -32,7 +32,8 @@ is also supported.
 DesignWare(R) Cores Ethernet MAC 10/100/1000 Universal version 3.70a
 (and older) and DesignWare(R) Cores Ethernet Quality-of-Service version 4.0
 (and upper) have been used for developing this driver as well as
-DesignWare(R) Cores XGMAC - 10G Ethernet MAC.
+DesignWare(R) Cores XGMAC - 10G Ethernet MAC and DesignWare(R) Cores
+Enterprise MAC - 100G Ethernet MAC.
 
 This driver supports both the platform bus and PCI.
 
@@ -48,6 +49,8 @@ Cores Ethernet Controllers and corresponding minimum and maximum versions:
 +-------------------------------+--------------+--------------+--------------+
 | XGMAC - 10G Ethernet MAC      | 2.10a        | N/A          | XGMAC2+      |
 +-------------------------------+--------------+--------------+--------------+
+| XLGMAC - 100G Ethernet MAC    | 2.00a        | N/A          | XLGMAC2+     |
++-------------------------------+--------------+--------------+--------------+
 
 For questions related to hardware requirements, refer to the documentation
 supplied with your Ethernet adapter. All hardware requirements listed apply
@@ -57,7 +60,7 @@ Feature List
 ============
 
 The following features are available in this driver:
- - GMII/MII/RGMII/SGMII/RMII/XGMII Interface
+ - GMII/MII/RGMII/SGMII/RMII/XGMII/XLGMII Interface
  - Half-Duplex / Full-Duplex Operation
  - Energy Efficient Ethernet (EEE)
  - IEEE 802.3x PAUSE Packets (Flow Control)
-- 
2.7.4

