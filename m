Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D4425028B
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHXQdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgHXQ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:27:56 -0400
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Aug 2020 09:27:47 PDT
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00396C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:27:47 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 1B9C862070;
        Mon, 24 Aug 2020 18:27:46 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/5] pull request for net-next: batman-adv 2020-08-24
Date:   Mon, 24 Aug 2020 18:27:36 +0200
Message-Id: <20200824162741.880-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a small cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20200824

for you to fetch changes up to 0093870aa891594d170e1dc9aa192a30d530d755:

  batman-adv: Migrate to linux/prandom.h (2020-08-18 19:39:54 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - Drop unused function batadv_hardif_remove_interfaces(),
   by Sven Eckelmann

 - delete duplicated words, by Randy Dunlap

 - Drop (even more) repeated words in comments, by Sven Eckelmann

 - Migrate to linux/prandom.h, by Sven Eckelmann

----------------------------------------------------------------
Randy Dunlap (1):
      batman-adv: types.h: delete duplicated words

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (3):
      batman-adv: Drop unused function batadv_hardif_remove_interfaces()
      batman-adv: Drop repeated words in comments
      batman-adv: Migrate to linux/prandom.h

 net/batman-adv/bat_iv_ogm.c            |  1 +
 net/batman-adv/bat_v_elp.c             |  1 +
 net/batman-adv/bat_v_ogm.c             |  1 +
 net/batman-adv/bridge_loop_avoidance.c |  2 +-
 net/batman-adv/fragmentation.c         |  2 +-
 net/batman-adv/hard-interface.c        | 19 +------------------
 net/batman-adv/hard-interface.h        |  1 -
 net/batman-adv/main.c                  |  1 -
 net/batman-adv/main.h                  |  2 +-
 net/batman-adv/multicast.c             |  2 +-
 net/batman-adv/network-coding.c        |  4 ++--
 net/batman-adv/send.c                  |  2 +-
 net/batman-adv/soft-interface.c        |  4 ++--
 net/batman-adv/types.h                 |  4 ++--
 14 files changed, 15 insertions(+), 31 deletions(-)
