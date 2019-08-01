Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350EC7D643
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbfHAH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:28:07 -0400
Received: from 212.199.177.27.static.012.net.il ([212.199.177.27]:40271 "EHLO
        herzl.nuvoton.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730802AbfHAH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:28:06 -0400
Received: from taln60.nuvoton.co.il (ntil-fw [212.199.177.25])
        by herzl.nuvoton.co.il (8.13.8/8.13.8) with ESMTP id x717R6Nr004914;
        Thu, 1 Aug 2019 10:27:06 +0300
Received: by taln60.nuvoton.co.il (Postfix, from userid 8441)
        id 3EDC262A2E; Thu,  1 Aug 2019 10:27:06 +0300 (IDT)
From:   Avi Fishman <avifishman70@gmail.com>
To:     venture@google.com, yuenn@google.com, benjaminfair@google.com,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        gregkh@linuxfoundation.org
Cc:     avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        openbmc@lists.ozlabs.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: [PATCH v1 0/2] add NPCM7xx EMC 10/100 Ethernet driver
Date:   Thu,  1 Aug 2019 10:26:09 +0300
Message-Id: <20190801072611.27935-1-avifishman70@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EMC Ethernet Media Access Controller supports 10/100 Mbps and RMII.
This driver has been working on Nuvoton BMC NPCM7xx.

Avi Fishman (2):
  dt-binding: net: document NPCM7xx EMC 10/100 DT bindings
  net: npcm: add NPCM7xx EMC 10/100 Ethernet driver

 .../bindings/net/nuvoton,npcm7xx-emc.txt      |   38 +
 drivers/net/ethernet/nuvoton/Kconfig          |   21 +-
 drivers/net/ethernet/nuvoton/Makefile         |    2 +
 drivers/net/ethernet/nuvoton/npcm7xx_emc.c    | 2073 +++++++++++++++++
 4 files changed, 2131 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nuvoton,npcm7xx-emc.txt
 create mode 100644 drivers/net/ethernet/nuvoton/npcm7xx_emc.c

-- 
2.18.0

