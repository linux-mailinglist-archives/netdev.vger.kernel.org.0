Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5BA1E24EA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgEZPDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:03:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60167 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbgEZPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:03:24 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id BB560E000B;
        Tue, 26 May 2020 15:03:21 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: [PATCH net-next 0/2] net: mscc: allow forwarding ioctl operations to attached PHYs
Date:   Tue, 26 May 2020 17:01:47 +0200
Message-Id: <20200526150149.456719-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

These two patches allow forwarding ioctl to the PHY MII implementation,
and support is added for offloading timestamping operations to
compatible attached PHYs.

Thanks,
Antoine

Antoine Tenart (2):
  net: mscc: use the PHY MII ioctl interface when possible
  net: mscc: allow offloading timestamping operations to the PHY

 drivers/net/ethernet/mscc/ocelot.c       | 23 ++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_board.c |  3 ++-
 2 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.26.2

