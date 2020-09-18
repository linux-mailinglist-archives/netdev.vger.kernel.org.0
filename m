Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096D226FE23
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIRNUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRNUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:20:02 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8CC061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:20:02 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c59714ead05d12fb7f5a0314d0.dip0.t-ipconnect.de [IPv6:2003:c5:9714:ead0:5d12:fb7f:5a03:14d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 7B1E06206B;
        Fri, 18 Sep 2020 15:19:58 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/6] pull request for net: batman-adv 2020-09-18
Date:   Fri, 18 Sep 2020 15:19:50 +0200
Message-Id: <20200918131956.21598-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here are some late bugfixes which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 279e89b2281af3b1a9f04906e157992c19c9f163:

  batman-adv: bla: use netif_rx_ni when not in interrupt context (2020-08-18 19:40:03 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20200918

for you to fetch changes up to 2369e827046920ef0599e6a36b975ac5c0a359c2:

  batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh (2020-09-15 10:05:24 +0200)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - fix wrong type use in backbone_gw hash, by Linus Luessing

 - disable TT re-routing for multicast packets, by Linus Luessing

 - Add missing include for in_interrupt(), by Sven Eckelmann

 - fix BLA/multicast issues for packets sent via unicast,
   by Linus Luessing (3 patches)

----------------------------------------------------------------
Linus Lüssing (5):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
      batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Sven Eckelmann (1):
      batman-adv: Add missing include for in_interrupt()

 net/batman-adv/bridge_loop_avoidance.c | 145 ++++++++++++++++++++++++++-------
 net/batman-adv/bridge_loop_avoidance.h |   4 +-
 net/batman-adv/multicast.c             |  46 ++++++++---
 net/batman-adv/multicast.h             |  15 ++++
 net/batman-adv/routing.c               |   4 +
 net/batman-adv/soft-interface.c        |  11 ++-
 6 files changed, 179 insertions(+), 46 deletions(-)
