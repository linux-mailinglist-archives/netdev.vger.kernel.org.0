Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8799049F891
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiA1LpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348153AbiA1LpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:45:08 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2D4C061714;
        Fri, 28 Jan 2022 03:45:08 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d705dc252cd134b0e26de30d.dip0.t-ipconnect.de [IPv6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 29CC5C0220;
        Fri, 28 Jan 2022 12:45:05 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-01-28
Date:   Fri, 28 Jan 2022 12:45:01 +0100
Message-Id: <20220128114501.2732329-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

A bunch of fixes in drivers, all from Miquel Raynal.
Clarifying the default channel in hwsim, leak fixes in at86rf230 and ca8210 as
well as a symbol duration fix for mcr20a. Topping up the driver fixes with
better error codes in nl802154 and a cleanup in MAINTAINERS for an orphaned
driver.

regards
Stefan Schmidt


The following changes since commit 2f61353cd2f789a4229b6f5c1c24a40a613357bb:

  net: hns3: handle empty unknown interrupt for VF (2022-01-25 13:08:05 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-01-28

for you to fetch changes up to 5d8a8b324ff48c9d9fe4f1634e33dc647d2481b4:

  MAINTAINERS: Remove Harry Morris bouncing address (2022-01-27 08:20:54 +0100)

----------------------------------------------------------------
Miquel Raynal (6):
      net: ieee802154: hwsim: Ensure proper channel selection at probe time
      net: ieee802154: mcr20a: Fix lifs/sifs periods
      net: ieee802154: at86rf230: Stop leaking skb's
      net: ieee802154: ca8210: Stop leaking skb's
      net: ieee802154: Return meaningful error codes from the netlink helpers
      MAINTAINERS: Remove Harry Morris bouncing address

 MAINTAINERS                              |  3 +--
 drivers/net/ieee802154/at86rf230.c       | 13 +++++++++++--
 drivers/net/ieee802154/ca8210.c          |  1 +
 drivers/net/ieee802154/mac802154_hwsim.c |  1 +
 drivers/net/ieee802154/mcr20a.c          |  4 ++--
 net/ieee802154/nl802154.c                |  8 ++++----
 6 files changed, 20 insertions(+), 10 deletions(-)
