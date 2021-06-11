Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE73A4272
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhFKM5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:57:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36544 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFKM5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623416105; x=1654952105;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EZCKknjivukT40dCuENLWqZf5ravlUcNSXMt5MuT85c=;
  b=dcb2j/1gxJF/YFJaRZWhIRblsf82N6YvTDCjIuXzc7cGLU1gDboCeCdp
   kS4EqNLITlxLcVE8eoCFsUVploOXbmLNa2BMUb4QVJMIJiQCLjf6vLOfy
   pbtyuFfq2TqJKjKY0TZEMGeY9ReSNUAkyDwM8IH3/HX7n5Wj0ejaYK1kF
   wZbwa6cNEF4J25F9PV67gszV31LKe+HKc+wkHEMyiYsEAc/Io0aikgx1Y
   D7CauZ3wka16SaSCvFq7sJ5gGuNnZCcjvm8r01UwcZPQ9C1wpsdO+hrgA
   ybF8E/iteu4KNMmmhU75lUD82YXylkK2JvKYmR1dZg0OVSxjAv4+7Wndn
   Q==;
IronPort-SDR: X32b0Wrm3bw6hVrEuwnHgxrB7cxJrFksqTbfz0crccTFrjGvjOUfkf58aCxhk/cq6sUFYvs3mF
 P31Fcm41Q/iMk8UNgkJV2m8kbxu95GsQn2WxmqdG7h4ra913sgPUPxK3g1b7Jmw6m3vRBQhweu
 QIxemBG2b82K7VVOyNc9srK/Nwfw3jILWpu8vUNNstzYltoZK3BZJIADj9v/iwhflAOkrzKNzI
 d0cYaE98NTHEtU4xywPD+L6Uv2FQCdPeCy+GZxVOm8/ge+HO8wlHSv2oeJ0uaGzl0H6Mpc9qya
 l/c=
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="131631314"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2021 05:55:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 05:55:03 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 11 Jun 2021 05:55:02 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net-next 0/4] Add 25G BASE-R support
Date:   Fri, 11 Jun 2021 14:54:49 +0200
Message-ID: <20210611125453.313308-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add the 25G BASE-R mode to the set modes supported.
This mode is used by the Sparx5 Switch for its 25G SerDes.

Steen Hegelund (4):
  dt-bindings: net: Add 25G BASE-R phy interface
  net: phy: Add 25G BASE-R interface mode
  net: sfp: add support for 25G BASE-R SFPs
  net: phylink: Add 25G BASE-R support

 .../devicetree/bindings/net/ethernet-controller.yaml        | 1 +
 Documentation/networking/phy.rst                            | 6 ++++++
 drivers/net/phy/phylink.c                                   | 5 +++++
 drivers/net/phy/sfp-bus.c                                   | 5 +++++
 include/linux/phy.h                                         | 4 ++++
 5 files changed, 21 insertions(+)

-- 
2.32.0

