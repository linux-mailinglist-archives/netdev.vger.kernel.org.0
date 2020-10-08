Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6992879E5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgJHQXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:23:07 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59816 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJHQXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:23:06 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 098GN0hK064790;
        Thu, 8 Oct 2020 11:23:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602174180;
        bh=1qreb2kVtUQKe4lI6IV2IRG5ZuGQneUy3UDTv28QzTA=;
        h=From:To:CC:Subject:Date;
        b=qcJEN7rzGZBrbcL+YNrBxEtyuZX7TbNE2GAwgXqUeR1V4ArIMFBLcWQRI/xWEBXNc
         HW7hLGkrh65LmdXlbDeKX/Y3GCOvL7P3i3s5x7BPmXzxdAtf2y5fz2iY9eOuTYbZBH
         5oulFjnU4cKY9YcxSsfx6NrHfe7EGl4WHjTAW2Zk=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 098GN0lq003833
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 8 Oct 2020 11:23:00 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 8 Oct
 2020 11:23:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 8 Oct 2020 11:23:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 098GMw1r067942;
        Thu, 8 Oct 2020 11:22:59 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 0/2] DP83TD510 Single Pair 10Mbps Ethernet PHY
Date:   Thu, 8 Oct 2020 11:22:36 -0500
Message-ID: <20201008162238.5083-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The DP83TD510 is an Ethernet PHY supporting single pair of twisted wires. The
PHY is capable of 10Mbps communication over long distances and exceeds the
IEEE 802.3cg 10BASE-T1L single-pair Ethernet specification.  The PHY supports
various voltage level signalling and can be forced to support a specific
voltage or allowed to perfrom auto negotiation on the voltage level. The
default for the PHY is auto negotiation but if the PHY is forced to a specific
voltage then the LP must also support the same voltage.

Dan

Dan Murphy (2):
  dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
  net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY

 .../devicetree/bindings/net/ti,dp83td510.yaml |  70 +++
 drivers/net/phy/Kconfig                       |   6 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/dp83td510.c                   | 583 ++++++++++++++++++
 4 files changed, 660 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
 create mode 100644 drivers/net/phy/dp83td510.c

-- 
2.28.0.585.ge1cfff676549

