Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2AD313A53
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhBHRAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:00:43 -0500
Received: from simonwunderlich.de ([79.140.42.25]:33676 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbhBHRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:00:25 -0500
Received: from kero.packetmixer.de (p4fd575e5.dip0.t-ipconnect.de [79.213.117.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 2E75317401E;
        Mon,  8 Feb 2021 17:59:39 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/4] pull request for net-next: batman-adv 2021-02-08
Date:   Mon,  8 Feb 2021 17:59:34 +0100
Message-Id: <20210208165938.13262-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

here is the updated pull request of batman-adv to go into net-next. We
have updated the first two patches as discussed (added justification
for the first, replaced the second to remove copyright years). The other
two patches are unchanged.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 5c8fe583cce542aa0b84adc939ce85293de36e5e:

  Linux 5.11-rc1 (2020-12-27 15:30:22 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20210208

for you to fetch changes up to 25d81f9307ffc166427d93152498f45178f5936a:

  batman-adv: Fix names for kernel-doc blocks (2021-02-06 09:22:45 +0100)

----------------------------------------------------------------
This feature/cleanup patchset is an updated version of the pull request
of Feb 2nd (batadv-next-pullrequest-20210202) and includes the
following patches:

 - Bump version strings, by Simon Wunderlich (added commit log)

 - Drop publication years from copyright info, by Sven Eckelmann
   (replaced the previous patch which updated copyright years, as per
    our discussion)

 - Avoid sizeof on flexible structure, by Sven Eckelmann (unchanged)

 - Fix names for kernel-doc blocks, by Sven Eckelmann (unchanged)

----------------------------------------------------------------
Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (3):
      batman-adv: Drop publication years from copyright info
      batman-adv: Avoid sizeof on flexible structure
      batman-adv: Fix names for kernel-doc blocks

 include/uapi/linux/batadv_packet.h     | 2 +-
 include/uapi/linux/batman_adv.h        | 2 +-
 net/batman-adv/Kconfig                 | 2 +-
 net/batman-adv/Makefile                | 2 +-
 net/batman-adv/bat_algo.c              | 2 +-
 net/batman-adv/bat_algo.h              | 2 +-
 net/batman-adv/bat_iv_ogm.c            | 2 +-
 net/batman-adv/bat_iv_ogm.h            | 2 +-
 net/batman-adv/bat_v.c                 | 2 +-
 net/batman-adv/bat_v.h                 | 2 +-
 net/batman-adv/bat_v_elp.c             | 2 +-
 net/batman-adv/bat_v_elp.h             | 2 +-
 net/batman-adv/bat_v_ogm.c             | 2 +-
 net/batman-adv/bat_v_ogm.h             | 2 +-
 net/batman-adv/bitarray.c              | 2 +-
 net/batman-adv/bitarray.h              | 2 +-
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 net/batman-adv/bridge_loop_avoidance.h | 2 +-
 net/batman-adv/distributed-arp-table.c | 6 +++---
 net/batman-adv/distributed-arp-table.h | 2 +-
 net/batman-adv/fragmentation.c         | 2 +-
 net/batman-adv/fragmentation.h         | 2 +-
 net/batman-adv/gateway_client.c        | 2 +-
 net/batman-adv/gateway_client.h        | 2 +-
 net/batman-adv/gateway_common.c        | 2 +-
 net/batman-adv/gateway_common.h        | 2 +-
 net/batman-adv/hard-interface.c        | 2 +-
 net/batman-adv/hard-interface.h        | 2 +-
 net/batman-adv/hash.c                  | 2 +-
 net/batman-adv/hash.h                  | 2 +-
 net/batman-adv/log.c                   | 2 +-
 net/batman-adv/log.h                   | 2 +-
 net/batman-adv/main.c                  | 2 +-
 net/batman-adv/main.h                  | 4 ++--
 net/batman-adv/multicast.c             | 4 ++--
 net/batman-adv/multicast.h             | 2 +-
 net/batman-adv/netlink.c               | 6 +++---
 net/batman-adv/netlink.h               | 2 +-
 net/batman-adv/network-coding.c        | 2 +-
 net/batman-adv/network-coding.h        | 2 +-
 net/batman-adv/originator.c            | 2 +-
 net/batman-adv/originator.h            | 2 +-
 net/batman-adv/routing.c               | 2 +-
 net/batman-adv/routing.h               | 2 +-
 net/batman-adv/send.c                  | 2 +-
 net/batman-adv/send.h                  | 2 +-
 net/batman-adv/soft-interface.c        | 2 +-
 net/batman-adv/soft-interface.h        | 2 +-
 net/batman-adv/tp_meter.c              | 4 ++--
 net/batman-adv/tp_meter.h              | 2 +-
 net/batman-adv/trace.c                 | 2 +-
 net/batman-adv/trace.h                 | 2 +-
 net/batman-adv/translation-table.c     | 2 +-
 net/batman-adv/translation-table.h     | 2 +-
 net/batman-adv/tvlv.c                  | 2 +-
 net/batman-adv/tvlv.h                  | 2 +-
 net/batman-adv/types.h                 | 5 +++--
 57 files changed, 66 insertions(+), 65 deletions(-)
