Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B147F0AA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhLXT0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:35 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:11823 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234457AbhLXT0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:35 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="104635847"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:33 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4CB3840F521F;
        Sat, 25 Dec 2021 04:26:32 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 0/8] net: Use platform_get_irq*() variants to fetch IRQ's
Date:   Fri, 24 Dec 2021 19:26:18 +0000
Message-Id: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series aims to drop using platform_get_resource() for IRQ types
in preparation for removal of static setup of IRQ resource from DT core
code.

Dropping usage of platform_get_resource() was agreed based on
the discussion [0].

[0] https://patchwork.kernel.org/project/linux-renesas-soc/
patch/20211209001056.29774-1-prabhakar.mahadev-lad.rj@bp.renesas.com/

Cheers,
Prabhakar

Lad Prabhakar (8):
  ethernet: netsec: Use platform_get_irq() to get the interrupt
  net: pxa168_eth: Use platform_get_irq() to get the interrupt
  fsl/fman: Use platform_get_irq() to get the interrupt
  net: ethoc: Use platform_get_irq() to get the interrupt
  net: xilinx: emaclite: Use platform_get_irq() to get the interrupt
  wcn36xx: Use platform_get_irq_byname() to get the interrupt
  ath10k: Use platform_get_irq() to get the interrupt
  net: ethernet: ti: davinci_emac: Use platform_get_irq() to get the
    interrupt

 drivers/net/ethernet/ethoc.c                  |  9 +--
 drivers/net/ethernet/freescale/fman/fman.c    | 32 ++++-----
 drivers/net/ethernet/marvell/pxa168_eth.c     |  9 +--
 drivers/net/ethernet/socionext/netsec.c       | 13 ++--
 drivers/net/ethernet/ti/davinci_emac.c        | 69 +++++++++++--------
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  9 +--
 drivers/net/wireless/ath/ath10k/snoc.c        | 15 ++--
 drivers/net/wireless/ath/wcn36xx/main.c       | 21 +++---
 8 files changed, 88 insertions(+), 89 deletions(-)

-- 
2.17.1

