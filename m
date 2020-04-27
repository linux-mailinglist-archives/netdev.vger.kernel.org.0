Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E01BA739
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgD0PGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727794AbgD0PGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:06:10 -0400
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Apr 2020 08:06:10 PDT
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8353C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:06:10 -0700 (PDT)
Received: from kero.packetmixer.de (p4FD5799A.dip0.t-ipconnect.de [79.213.121.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 63D2862058;
        Mon, 27 Apr 2020 17:06:09 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/5] pull request for net-next: batman-adv 2020-04-27
Date:   Mon, 27 Apr 2020 17:06:02 +0200
Message-Id: <20200427150607.31401-1-sw@simonwunderlich.de>
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

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20200427

for you to fetch changes up to e73f94d1b6f05f6f22434c63de255a9dec6fd23d:

  batman-adv: remove unused inline function batadv_arp_change_timeout (2020-04-24 15:22:41 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - fix spelling error, by Sven Eckelmann

 - drop unneeded types.h include, by Sven Eckelmann

 - change random number generation to prandom_u32_max(),
   by Sven Eckelmann

 - remove unused function batadv_arp_change_timeout(), by Yue Haibing

----------------------------------------------------------------
Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (3):
      batman-adv: Fix spelling error in term buffer
      batman-adv: trace: Drop unneeded types.h include
      batman-adv: Utilize prandom_u32_max for random [0, max) values

YueHaibing (1):
      batman-adv: remove unused inline function batadv_arp_change_timeout

 net/batman-adv/bat_iv_ogm.c            | 4 ++--
 net/batman-adv/bat_v_elp.c             | 2 +-
 net/batman-adv/bat_v_ogm.c             | 4 ++--
 net/batman-adv/distributed-arp-table.h | 5 -----
 net/batman-adv/main.h                  | 2 +-
 net/batman-adv/trace.h                 | 1 -
 net/batman-adv/types.h                 | 2 +-
 7 files changed, 7 insertions(+), 13 deletions(-)
