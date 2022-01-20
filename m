Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D34944BB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357831AbiATAgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357827AbiATAgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:36:50 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC66BC061574;
        Wed, 19 Jan 2022 16:36:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AC6FAC0003;
        Thu, 20 Jan 2022 00:36:45 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 0/9] ieee802154: A bunch of fixes
Date:   Thu, 20 Jan 2022 01:36:36 +0100
Message-Id: <20220120003645.308498-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to a wider series, here are a number of small and random
fixes across the subsystem.

Miquel Raynal (9):
  net: ieee802154: hwsim: Ensure proper channel selection at probe time
  net: ieee802154: hwsim: Ensure frame checksum are valid
  net: ieee802154: mcr20a: Fix lifs/sifs periods
  net: ieee802154: at86rf230: Stop leaking skb's
  net: ieee802154: ca8210: Stop leaking skb's
  net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
  net: ieee802154: Return meaningful error codes from the netlink
    helpers
  net: mac802154: Explain the use of ieee802154_wake/stop_queue()
  MAINTAINERS: Remove Harry Morris bouncing address

 MAINTAINERS                              |  3 +--
 drivers/net/ieee802154/at86rf230.c       |  1 +
 drivers/net/ieee802154/ca8210.c          |  1 +
 drivers/net/ieee802154/mac802154_hwsim.c | 12 ++----------
 drivers/net/ieee802154/mcr20a.c          |  4 ++--
 include/net/mac802154.h                  | 12 ++++++++++++
 net/ieee802154/nl-phy.c                  |  5 +++--
 net/ieee802154/nl802154.c                |  8 ++++----
 8 files changed, 26 insertions(+), 20 deletions(-)

-- 
2.27.0

