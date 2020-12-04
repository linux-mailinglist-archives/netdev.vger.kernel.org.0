Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A52CF107
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgLDPrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgLDPrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:47:31 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFC6C061A54
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:46:38 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59716c1e0c1b6a3b925be22c4.dip0.t-ipconnect.de [IPv6:2003:c5:9716:c1e0:c1b6:a3b9:25be:22c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D16C917405F;
        Fri,  4 Dec 2020 16:46:32 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/8] pull request for net-next: batman-adv 2020-12-04
Date:   Fri,  4 Dec 2020 16:46:23 +0100
Message-Id: <20201204154631.21063-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

here is a late cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 992b03b88e36254e26e9a4977ab948683e21bd9f:

  batman-adv: Don't always reallocate the fragmentation skb head (2020-11-27 08:02:55 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20201204

for you to fetch changes up to 34a14c2e6310a348a3f23af6e95bf9ea040f3ec8:

  batman-adv: Drop unused soft-interface.h include in fragmentation.c (2020-12-04 08:41:16 +0100)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - update include for min/max helpers, by Sven Eckelmann

 - add infrastructure and netlink functions for routing algo selection,
   by Sven Eckelmann (2 patches)

 - drop deprecated debugfs and sysfs support and obsoleted
   functionality, by Sven Eckelmann (3 patches)

 - drop unused include in fragmentation.c, by Simon Wunderlich

----------------------------------------------------------------
Simon Wunderlich (2):
      batman-adv: Start new development cycle
      batman-adv: Drop unused soft-interface.h include in fragmentation.c

Sven Eckelmann (6):
      batman-adv: Add new include for min/max helpers
      batman-adv: Prepare infrastructure for newlink settings
      batman-adv: Allow selection of routing algorithm over rtnetlink
      batman-adv: Drop deprecated sysfs support
      batman-adv: Drop deprecated debugfs support
      batman-adv: Drop legacy code for auto deleting mesh interfaces

 .../ABI/obsolete/sysfs-class-net-batman-adv        |   32 -
 Documentation/ABI/obsolete/sysfs-class-net-mesh    |  110 --
 MAINTAINERS                                        |    2 -
 include/uapi/linux/batman_adv.h                    |   26 +
 net/batman-adv/Kconfig                             |   27 +-
 net/batman-adv/Makefile                            |    3 -
 net/batman-adv/bat_algo.c                          |   34 +-
 net/batman-adv/bat_algo.h                          |    5 +-
 net/batman-adv/bat_iv_ogm.c                        |  229 ----
 net/batman-adv/bat_v.c                             |  247 +---
 net/batman-adv/bat_v_elp.c                         |    1 +
 net/batman-adv/bat_v_ogm.c                         |    1 +
 net/batman-adv/bridge_loop_avoidance.c             |  130 --
 net/batman-adv/bridge_loop_avoidance.h             |   16 -
 net/batman-adv/debugfs.c                           |  442 -------
 net/batman-adv/debugfs.h                           |   73 --
 net/batman-adv/distributed-arp-table.c             |   55 -
 net/batman-adv/distributed-arp-table.h             |    2 -
 net/batman-adv/fragmentation.c                     |    3 +-
 net/batman-adv/gateway_client.c                    |   39 -
 net/batman-adv/gateway_client.h                    |    2 -
 net/batman-adv/hard-interface.c                    |   35 +-
 net/batman-adv/hard-interface.h                    |   25 +-
 net/batman-adv/icmp_socket.c                       |  392 ------
 net/batman-adv/icmp_socket.h                       |   38 -
 net/batman-adv/log.c                               |  209 ----
 net/batman-adv/main.c                              |   46 +-
 net/batman-adv/main.h                              |    5 +-
 net/batman-adv/multicast.c                         |  111 --
 net/batman-adv/multicast.h                         |    3 -
 net/batman-adv/netlink.c                           |    1 +
 net/batman-adv/network-coding.c                    |   87 --
 net/batman-adv/network-coding.h                    |   13 -
 net/batman-adv/originator.c                        |  121 --
 net/batman-adv/originator.h                        |    4 -
 net/batman-adv/routing.c                           |   10 -
 net/batman-adv/soft-interface.c                    |  137 +--
 net/batman-adv/soft-interface.h                    |    1 -
 net/batman-adv/sysfs.c                             | 1272 --------------------
 net/batman-adv/sysfs.h                             |   93 --
 net/batman-adv/tp_meter.c                          |    1 +
 net/batman-adv/translation-table.c                 |  212 ----
 net/batman-adv/translation-table.h                 |    3 -
 net/batman-adv/types.h                             |   66 -
 44 files changed, 121 insertions(+), 4243 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-batman-adv
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-mesh
 delete mode 100644 net/batman-adv/debugfs.c
 delete mode 100644 net/batman-adv/debugfs.h
 delete mode 100644 net/batman-adv/icmp_socket.c
 delete mode 100644 net/batman-adv/icmp_socket.h
 delete mode 100644 net/batman-adv/sysfs.c
 delete mode 100644 net/batman-adv/sysfs.h
