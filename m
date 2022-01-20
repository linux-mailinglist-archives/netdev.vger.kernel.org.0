Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6912494CBE
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiATLVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:21:22 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51015 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiATLVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:21:19 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4282CC0007;
        Thu, 20 Jan 2022 11:21:16 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 0/9] ieee802154: A bunch of fixes
Date:   Thu, 20 Jan 2022 12:21:06 +0100
Message-Id: <20220120112115.448077-1-miquel.raynal@bootlin.com>
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
* Fixed the build error reported by a robot. It ended up being something
  which I fixed in a commit from a following series. I've now sorted
  this out and the patch now works on its own.

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

