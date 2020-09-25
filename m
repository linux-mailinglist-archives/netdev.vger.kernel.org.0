Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254E4278B20
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIYOok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:44:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46390 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgIYOoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:44:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 580CE1A0925;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B0DB1A0921;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 158CE2030E;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: small updates
Date:   Fri, 25 Sep 2020 17:44:18 +0300
Message-Id: <20200925144421.7811-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is just a collection of small updates to the dpaa2-eth
driver.

First, we only need to check the availability of the DTS child node, not
both child and parent node. Then remove a call to
dpaa2_eth_link_state_update() which is now just a leftover and it's not
useful in how are things working now in the PHY integration. Lastly,
modify how the driver is behaving when the the flow steering table is
used between all the traffic classes.

Ioana Ciornei (2):
  dpaa2-mac: do not check for both child and parent DTS nodes
  dpaa2-eth: no need to check link state right after ndo_open

Ionut-robert Aron (1):
  dpaa2-eth: install a single steering rule when SHARED_FS is enabled

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 25 ++++++++++---------
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  3 +--
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  4 +++
 4 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.25.1

