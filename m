Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642883C7A2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404519AbfFKJvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:51:46 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:55095 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbfFKJvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 05:51:45 -0400
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C9946200003;
        Tue, 11 Jun 2019 09:51:39 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: [PATCH net 0/2] net: mvpp2: prs: Fixes for VID filtering
Date:   Tue, 11 Jun 2019 11:51:41 +0200
Message-Id: <20190611095143.2810-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some issues with VID filtering offload, mainly due to
the wrong ranges being used in the TCAM header parser.

The first patch fixes a bug where removing a VLAN from a port's
whitelist would also remove it from other port's, if they are on the
same PPv2 instance.

The second patch makes so that we don't invalidate the wrong TCAM
entries when clearing the whole whitelist.

Maxime Chevallier (2):
  net: mvpp2: prs: Fix parser range for VID filtering
  net: mvpp2: prs: Use the correct helpers when removing all VID filters

 .../net/ethernet/marvell/mvpp2/mvpp2_prs.c    | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
2.20.1

