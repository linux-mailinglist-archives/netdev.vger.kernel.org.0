Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457814944F6
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345470AbiATAn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbiATAnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:43:55 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64F1C06161C;
        Wed, 19 Jan 2022 16:43:54 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C85C220002;
        Thu, 20 Jan 2022 00:43:50 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 0/4] ieee802154: General preparation to scan support
Date:   Thu, 20 Jan 2022 01:43:46 +0100
Message-Id: <20220120004350.308866-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These few patches are preparation patches and light cleanups before the
introduction of scan support.

David Girault (4):
  net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
  net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
    menu
  net: ieee802154: Move the address structure earlier
  net: ieee802154: Add a kernel doc header to the ieee802154_addr
    structure

 include/net/cfg802154.h | 28 +++++++++++++++++++---------
 net/Kconfig             |  3 +--
 net/ieee802154/Kconfig  |  1 +
 3 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.27.0

