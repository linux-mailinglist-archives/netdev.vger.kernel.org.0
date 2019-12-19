Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5790F126593
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSPVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:21:32 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39784 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfLSPVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 10:21:31 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 42D851A07EF;
        Thu, 19 Dec 2019 16:21:30 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 356DC1A0094;
        Thu, 19 Dec 2019 16:21:30 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AA855203C8;
        Thu, 19 Dec 2019 16:21:29 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH 0/6] Add PHY connection types for XFI and SFI
Date:   Thu, 19 Dec 2019 17:21:15 +0200
Message-Id: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a long time the only 10G interface mode registered in the code was
XGMII and some PHYs and MACs that actually supported other modes just
used that to denote 10G. Recently more modes were added (USXGMII,
10GKR) to better match the actual HW support. In this respect, the use
of 10GBase-KR to denote not only backplane but also XFI and SFI can be
improved upon. This patch series introduces XFI and SFI PHY connection
types and initial users for them.

Madalin Bucur (6):
  net: phy: add interface modes for XFI, SFI
  arm64: dts: ls104xardb: set correct PHY interface mode
  net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
  net: fsl/fman: add support for PHY_INTERFACE_MODE_XFI
  net: fsl/fman: add support for PHY_INTERFACE_MODE_SFI
  net: phy: aquantia: add support for PHY_INTERFACE_MODE_XFI

 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts |  4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c  | 10 +++++++---
 drivers/net/ethernet/freescale/fman/mac.c         | 10 +++++++---
 drivers/net/phy/aquantia_main.c                   |  5 ++++-
 include/linux/phy.h                               |  7 ++++++-
 6 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.1.0

