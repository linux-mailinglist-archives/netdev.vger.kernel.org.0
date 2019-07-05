Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DA5605AE
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfGEMJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:09:17 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:43313 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbfGEMJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 08:09:16 -0400
Received: from mc-bl-xps13.lan (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id DF277200005;
        Fri,  5 Jul 2019 12:09:10 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: [PATCH net-next 0/2] net: mvpp2: Add classification based on the ETHER flow
Date:   Fri,  5 Jul 2019 14:09:11 +0200
Message-Id: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This series adds support for classification of the ETHER flow in the
mvpp2 driver.

The first patch allows detecting when a user specifies a flow_type that
isn't supported by the driver, while the second adds support for this
flow_type by adding the mapping between the ETHER_FLOW enum value and
the relevant classifier flow entries.

Thanks,

Maxime

Maxime Chevallier (2):
  net: mvpp2: cls: Report an error for unsupported flow types
  net: mvpp2: cls: Add support for ETHER_FLOW

 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.20.1

