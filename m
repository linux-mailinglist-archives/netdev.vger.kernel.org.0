Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537633F2872
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhHTIdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:33:44 -0400
Received: from simonwunderlich.de ([79.140.42.25]:49630 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhHTIdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:33:43 -0400
Received: from kero.packetmixer.de (p200300c5970e73c0a32126881010a2d4.dip0.t-ipconnect.de [IPv6:2003:c5:970e:73c0:a321:2688:1010:a2d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 96A5E17401E;
        Fri, 20 Aug 2021 10:33:04 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/6] (updated) pull request for net-next: batman-adv 2021-08-20
Date:   Fri, 20 Aug 2021 10:32:54 +0200
Message-Id: <20210820083300.32289-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

here is the updated pull request of batman-adv, with the missing sign-off
added which you pointed out yesterday.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit b37a466837393af72fe8bcb8f1436410f3f173f3:

  netdevice: add the case if dev is NULL (2021-08-05 13:29:26 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20210820

for you to fetch changes up to a006aa51ea27fa64afc7990f8f100ff0baa92413:

  batman-adv: bcast: remove remaining skb-copy calls (2021-08-20 08:17:10 +0200)

----------------------------------------------------------------
This (updated) cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - update docs about move IRC channel away from freenode,
   by Sven Eckelmann (updated, added missing sign-off)

 - Switch to kstrtox.h for kstrtou64, by Sven Eckelmann

 - Update NULL checks, by Sven Eckelmann (2 patches)

 - remove remaining skb-copy calls for broadcast packets,
   by Linus Lüssing

----------------------------------------------------------------
Linus Lüssing (1):
      batman-adv: bcast: remove remaining skb-copy calls

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (4):
      batman-adv: Move IRC channel to hackint.org
      batman-adv: Switch to kstrtox.h for kstrtou64
      batman-adv: Check ptr for NULL before reducing its refcnt
      batman-adv: Drop NULL check before dropping references

 Documentation/networking/batman-adv.rst |   2 +-
 MAINTAINERS                             |   2 +-
 net/batman-adv/bat_iv_ogm.c             |  75 ++++++++---------------
 net/batman-adv/bat_v.c                  |  30 ++++------
 net/batman-adv/bat_v_elp.c              |   9 +--
 net/batman-adv/bat_v_ogm.c              |  39 ++++--------
 net/batman-adv/bridge_loop_avoidance.c  |  33 +++++------
 net/batman-adv/distributed-arp-table.c  |  24 ++++----
 net/batman-adv/fragmentation.c          |   6 +-
 net/batman-adv/gateway_client.c         |  57 +++++-------------
 net/batman-adv/gateway_client.h         |  16 ++++-
 net/batman-adv/gateway_common.c         |   2 +-
 net/batman-adv/hard-interface.c         |  21 +++----
 net/batman-adv/hard-interface.h         |   3 +
 net/batman-adv/main.h                   |   2 +-
 net/batman-adv/multicast.c              |   2 +-
 net/batman-adv/netlink.c                |   6 +-
 net/batman-adv/network-coding.c         |  24 ++++----
 net/batman-adv/originator.c             | 102 +++++---------------------------
 net/batman-adv/originator.h             |  96 +++++++++++++++++++++++++++---
 net/batman-adv/routing.c                |  39 ++++--------
 net/batman-adv/send.c                   |  33 ++++++-----
 net/batman-adv/soft-interface.c         |  27 ++-------
 net/batman-adv/soft-interface.h         |  16 ++++-
 net/batman-adv/tp_meter.c               |  27 ++++-----
 net/batman-adv/translation-table.c      | 100 +++++++++++--------------------
 net/batman-adv/translation-table.h      |  18 +++++-
 net/batman-adv/tvlv.c                   |   9 ++-
 28 files changed, 364 insertions(+), 456 deletions(-)
