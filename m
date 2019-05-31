Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6572D314A6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfEaSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:19 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfEaSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:19 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIG5p6030585
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:05 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Di043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:05 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 00/13] Xilinx axienet driver updates
Date:   Fri, 31 May 2019 12:15:32 -0600
Message-Id: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of enhancements and bug fixes in order to get the mainline
version of this driver into a more generally usable state, including on
x86 or ARM platforms. It also converts the driver to use the phylink API
in order to provide support for SFP modules.

Robert Hancock (13):
  net: axienet: Fixed 64-bit compile, enable build on X86 and ARM
  net: axienet: clean up MDIO handling
  net: axienet: Cleanup DMA device reset and halt process
  net: axienet: Make RX/TX ring sizes configurable
  net: axienet: Add DMA registers to ethtool register dump
  net: axienet: Support shared interrupts
  net: axienet: Add optional support for Ethernet core interrupt
  net: axienet: Fix race condition causing TX hang
  net: axienet: Make missing MAC address non-fatal
  net: axienet: stop interface during shutdown
  net: axienet: document axistream-connected attribute
  net: axienet: make use of axistream-connected attribute optional
  net: axienet: convert to phylink API

 .../devicetree/bindings/net/xilinx_axienet.txt     |  24 +-
 drivers/net/ethernet/xilinx/Kconfig                |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  43 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 652 ++++++++++++++-------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 171 +++---
 5 files changed, 602 insertions(+), 294 deletions(-)

-- 
1.8.3.1

