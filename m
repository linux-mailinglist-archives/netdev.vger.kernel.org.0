Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CC0DB9B1
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406810AbfJQWWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:22:36 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51541 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388926AbfJQWWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:22:36 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 312971C0003;
        Thu, 17 Oct 2019 22:22:32 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next v3 0/2] net: lpc_eth: parse phy nodes from device tree
Date:   Fri, 18 Oct 2019 00:22:29 +0200
Message-Id: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow describing connected phys using device tree. This solves issues finding
the phy on the mdio bus and allows decribing the interrupt line the phy is
possibly connected to.

Changes in v3:
 - rebased on net-next
 - collected Reviewed-by

Changes in v2:
 - move the phy decription in the mdio subnode.

Alexandre Belloni (2):
  dt-bindings: net: lpc-eth: document optional properties
  net: lpc_eth: parse phy nodes from device tree

 .../devicetree/bindings/net/lpc-eth.txt       |  5 ++++
 drivers/net/ethernet/nxp/lpc_eth.c            | 28 +++++++++++++------
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.21.0

