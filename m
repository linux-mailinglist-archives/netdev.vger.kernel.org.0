Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4A49B3BF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444208AbiAYMRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:17:06 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:33941 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355332AbiAYMOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:14:44 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 01BE2100002;
        Tue, 25 Jan 2022 12:14:27 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan v3 0/6] ieee802154: A bunch of fixes
Date:   Tue, 25 Jan 2022 13:14:20 +0100
Message-Id: <20220125121426.848337-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to a wider series, here are a number of small and random
fixes across the subsystem.

Changes in v2:
* Fixed the wrong RCU usage when updating the default channel at probe
  time in hwsim.
* Actually fixed the skb leak fix in the at86rf230 driver as suggested
  by Alexander.
* Also reordered the calls to free the skb then wake the queue
  everywhere else.
* Added a missing Fixes tag (for the meaningful error codes patch).

Miquel Raynal (6):
  net: ieee802154: hwsim: Ensure proper channel selection at probe time
  net: ieee802154: mcr20a: Fix lifs/sifs periods
  net: ieee802154: at86rf230: Stop leaking skb's
  net: ieee802154: ca8210: Stop leaking skb's
  net: ieee802154: Return meaningful error codes from the netlink
    helpers
  MAINTAINERS: Remove Harry Morris bouncing address

 MAINTAINERS                              |  3 +--
 drivers/net/ieee802154/at86rf230.c       | 13 +++++++++++--
 drivers/net/ieee802154/ca8210.c          |  1 +
 drivers/net/ieee802154/mac802154_hwsim.c |  1 +
 drivers/net/ieee802154/mcr20a.c          |  4 ++--
 net/ieee802154/nl802154.c                |  8 ++++----
 6 files changed, 20 insertions(+), 10 deletions(-)

-- 
2.27.0

