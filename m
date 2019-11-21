Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC25C105A3A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKUTPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:15:49 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59682 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUTPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:15:49 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A5E0F200626;
        Thu, 21 Nov 2019 20:15:45 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 99776200625;
        Thu, 21 Nov 2019 20:15:45 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5240F203C8;
        Thu, 21 Nov 2019 20:15:45 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: MAC phylink fixes
Date:   Thu, 21 Nov 2019 21:15:24 +0200
Message-Id: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a couple of fixes on top of the
initial MAC support in dpaa2-eth.

Patch 2/3 depends on the phylink callback rename:
http://patchwork.ozlabs.org/patch/1198615/

Ioana Ciornei (3):
  dpaa2-eth: do not hold rtnl_lock on phylink_create() or _destroy()
  dpaa2-eth: add phylink_mac_ops stub callbacks
  dpaa2-eth: return all supported link modes in PHY_INTERFACE_MODE_NA

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |  4 ----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

-- 
1.9.1

