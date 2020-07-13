Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6332E21E24A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGMVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:35:28 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:43762 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgGMVf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:35:28 -0400
X-IronPort-AV: E=Sophos;i="5.75,348,1589209200"; 
   d="scan'208";a="51803346"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 14 Jul 2020 06:35:26 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8094940F7FC8;
        Tue, 14 Jul 2020 06:35:22 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/9] R8A774E1 SoC enable support for IPMMU, DMAC, GPIO and AVB
Date:   Mon, 13 Jul 2020 22:35:11 +0100
Message-Id: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series adds device nodes for IPMMU, DMAC, GPIO
and AVB nodes for RZ/G2H (R8A774E1) SoC.

Cheers,
Prabhakar

Lad Prabhakar (3):
  dt-bindings: iommu: renesas,ipmmu-vmsa: Add r8a774e1 support
  dt-bindings: dma: renesas,rcar-dmac: Document R8A774E1 bindings
  dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1 support

Marian-Cristian Rotariu (6):
  iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
  arm64: dts: renesas: r8a774e1: Add IPMMU device nodes
  arm64: dts: renesas: r8a774e1: Add SYS-DMAC device nodes
  arm64: dts: renesas: r8a774e1: Add GPIO device nodes
  dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC
  arm64: dts: renesas: r8a774e1: Add Ethernet AVB node

 .../bindings/dma/renesas,rcar-dmac.yaml       |   1 +
 .../bindings/gpio/renesas,rcar-gpio.yaml      |   1 +
 .../bindings/iommu/renesas,ipmmu-vmsa.yaml    |   1 +
 .../devicetree/bindings/net/renesas,ravb.txt  |   1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi     | 361 +++++++++++++++++-
 drivers/iommu/ipmmu-vmsa.c                    |   4 +
 6 files changed, 350 insertions(+), 19 deletions(-)

-- 
2.17.1

