Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9157213AC30
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgANOXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:23:55 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49786 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANOXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:23:54 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2020 09:23:53 EST
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 34D426205F;
        Tue, 14 Jan 2020 15:23:52 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/7] pull request for net-next: batman-adv 2020-01-14
Date:   Tue, 14 Jan 2020 15:23:44 +0100
Message-Id: <20200114142351.26622-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a small feature/cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 5759af0682b3395e64cf615e062d6ecad01428dc:

  batman-adv: Drop lockdep.h include for soft-interface.c (2019-11-03 08:30:58 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20200114

for you to fetch changes up to b2e55ca89245fccd459a2d56850822a69a6f91da:

  batman-adv: Disable CONFIG_BATMAN_ADV_SYSFS by default (2020-01-01 00:57:07 +0100)

----------------------------------------------------------------
This feature/cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - fix typo and kerneldocs, by Sven Eckelmann

 - use WiFi txbitrate for B.A.T.M.A.N. V as fallback, by René Treffer

 - silence some endian sparse warnings by adding annotations,
   by Sven Eckelmann

 - Update copyright years to 2020, by Sven Eckelmann

 - Disable deprecated sysfs configuration by default, by Sven Eckelmann

----------------------------------------------------------------
René Treffer (1):
      batman-adv: ELP - use wifi tx bitrate as fallback throughput

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (5):
      batman-adv: Strip dots from variable macro kerneldoc
      batman-adv: Fix typo metAdata
      batman-adv: Annotate bitwise integer pointer casts
      batman-adv: Update copyright years for 2020
      batman-adv: Disable CONFIG_BATMAN_ADV_SYSFS by default

 include/uapi/linux/batadv_packet.h     |  2 +-
 include/uapi/linux/batman_adv.h        |  2 +-
 net/batman-adv/Kconfig                 |  3 +--
 net/batman-adv/Makefile                |  2 +-
 net/batman-adv/bat_algo.c              |  2 +-
 net/batman-adv/bat_algo.h              |  2 +-
 net/batman-adv/bat_iv_ogm.c            |  2 +-
 net/batman-adv/bat_iv_ogm.h            |  2 +-
 net/batman-adv/bat_v.c                 |  2 +-
 net/batman-adv/bat_v.h                 |  2 +-
 net/batman-adv/bat_v_elp.c             | 15 +++++++++++----
 net/batman-adv/bat_v_elp.h             |  2 +-
 net/batman-adv/bat_v_ogm.c             |  2 +-
 net/batman-adv/bat_v_ogm.h             |  2 +-
 net/batman-adv/bitarray.c              |  2 +-
 net/batman-adv/bitarray.h              |  2 +-
 net/batman-adv/bridge_loop_avoidance.c |  4 ++--
 net/batman-adv/bridge_loop_avoidance.h |  2 +-
 net/batman-adv/debugfs.c               |  2 +-
 net/batman-adv/debugfs.h               |  2 +-
 net/batman-adv/distributed-arp-table.c | 10 ++++++----
 net/batman-adv/distributed-arp-table.h |  2 +-
 net/batman-adv/fragmentation.c         |  2 +-
 net/batman-adv/fragmentation.h         |  2 +-
 net/batman-adv/gateway_client.c        |  2 +-
 net/batman-adv/gateway_client.h        |  2 +-
 net/batman-adv/gateway_common.c        |  2 +-
 net/batman-adv/gateway_common.h        |  2 +-
 net/batman-adv/hard-interface.c        |  2 +-
 net/batman-adv/hard-interface.h        |  2 +-
 net/batman-adv/hash.c                  |  2 +-
 net/batman-adv/hash.h                  |  2 +-
 net/batman-adv/icmp_socket.c           |  2 +-
 net/batman-adv/icmp_socket.h           |  2 +-
 net/batman-adv/log.c                   |  2 +-
 net/batman-adv/log.h                   | 12 ++++++------
 net/batman-adv/main.c                  |  2 +-
 net/batman-adv/main.h                  |  4 ++--
 net/batman-adv/multicast.c             |  2 +-
 net/batman-adv/multicast.h             |  2 +-
 net/batman-adv/netlink.c               |  2 +-
 net/batman-adv/netlink.h               |  2 +-
 net/batman-adv/network-coding.c        |  2 +-
 net/batman-adv/network-coding.h        |  2 +-
 net/batman-adv/originator.c            |  2 +-
 net/batman-adv/originator.h            |  2 +-
 net/batman-adv/routing.c               |  2 +-
 net/batman-adv/routing.h               |  2 +-
 net/batman-adv/send.c                  |  2 +-
 net/batman-adv/send.h                  |  2 +-
 net/batman-adv/soft-interface.c        |  2 +-
 net/batman-adv/soft-interface.h        |  2 +-
 net/batman-adv/sysfs.c                 |  2 +-
 net/batman-adv/sysfs.h                 |  2 +-
 net/batman-adv/tp_meter.c              |  2 +-
 net/batman-adv/tp_meter.h              |  2 +-
 net/batman-adv/trace.c                 |  2 +-
 net/batman-adv/trace.h                 |  2 +-
 net/batman-adv/translation-table.c     |  2 +-
 net/batman-adv/translation-table.h     |  2 +-
 net/batman-adv/tvlv.c                  |  2 +-
 net/batman-adv/tvlv.h                  |  2 +-
 net/batman-adv/types.h                 |  6 +++---
 63 files changed, 87 insertions(+), 79 deletions(-)
