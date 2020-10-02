Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1302815AA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388150AbgJBOtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:49:47 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55270 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387919AbgJBOtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:49:46 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1EB9620016A;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 12AFA200138;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C234F202AC;
        Fri,  2 Oct 2020 16:49:44 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RESEND net-next 0/9] arm64: dts: layerscape: update MAC nodes with PHY information
Date:   Fri,  2 Oct 2020 17:48:38 +0300
Message-Id: <20201002144847.13793-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set aims to add the necessary DTS nodes to complete the
MAC/PCS/PHY representation on DPAA2 devices. The external MDIO bus nodes
and the PHYs found on them are added, along with the PCS MDIO internal
buses and their PCS PHYs. Also, links to these PHYs are added from the
DPMAC node.

I am resending these via netdev because I am not really sure if Shawn is
still able to take them in time for 5.10 since his last activity on the
tree has been some time ago.
I tested them on linux-next and there are no conflicts.

Ioana Ciornei (9):
  arm64: dts: ls1088a: add external MDIO device nodes
  arm64: dts: ls1088ardb: add QSGMII PHY nodes
  arm64: dts: ls1088ardb: add necessary DTS nodes for DPMAC2
  arm64: dts: ls208xa: add the external MDIO nodes
  arm64: dts: ls2088ardb: add PHY nodes for the CS4340 PHYs
  arm64: dts: ls2088ardb: add PHY nodes for the AQR405 PHYs
  arm64: dts: ls208xa: add PCS MDIO and PCS PHY nodes
  arm64: dts: lx2160a: add PCS MDIO and PCS PHY nodes
  arm64: dts: lx2160ardb: add nodes for the AQR107 PHYs

 .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 119 +++++++++
 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |  81 ++++++
 .../boot/dts/freescale/fsl-ls2088a-rdb.dts    | 118 ++++++++
 .../arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 242 +++++++++++++++++
 .../boot/dts/freescale/fsl-lx2160a-rdb.dts    |  32 +++
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 252 ++++++++++++++++++
 6 files changed, 844 insertions(+)

-- 
2.28.0

