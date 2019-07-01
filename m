Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AEE5B89E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfGAKF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:05:26 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:48047 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbfGAKF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:05:26 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 9F1F6200009;
        Mon,  1 Jul 2019 10:05:21 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next 0/8] net: mscc: PTP Hardware Clock (PHC) support
Date:   Mon,  1 Jul 2019 12:03:19 +0200
Message-Id: <20190701100327.6425-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series introduces the PTP Hardware Clock (PHC) support to the Mscc
Ocelot switch driver. In order to make use of this, a new register bank
is added and described in the device tree, as well as a new interrupt.
The use this bank and interrupt was made optional in the driver for dt
compatibility reasons.

Patches 2 and 4 should probably go through the MIPS tree.

Thanks!
Antoine

Antoine Tenart (8):
  Documentation/bindings: net: ocelot: document the PTP bank
  MIPS: dts: mscc: describe the PTP register range
  Documentation/bindings: net: ocelot: document the PTP ready IRQ
  MIPS: dts: mscc: describe the PTP ready interrupt
  net: mscc: describe the PTP register range
  net: mscc: improve the frame header parsing readability
  net: mscc: remove the frame_info cpuq member
  net: mscc: PTP Hardware Clock (PHC) support

 .../devicetree/bindings/net/mscc-ocelot.txt   |  20 +-
 arch/mips/boot/dts/mscc/ocelot.dtsi           |   7 +-
 drivers/net/ethernet/mscc/ocelot.c            | 382 +++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h            |  47 ++-
 drivers/net/ethernet/mscc/ocelot_board.c      | 139 ++++++-
 drivers/net/ethernet/mscc/ocelot_ptp.h        |  41 ++
 drivers/net/ethernet/mscc/ocelot_regs.c       |  11 +
 7 files changed, 615 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_ptp.h

-- 
2.21.0

