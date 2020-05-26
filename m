Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1552F1E1F37
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbgEZKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgEZKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 06:00:14 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454D0C08C5C2
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 03:00:13 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c597221100fc44a592f3d496ba.dip0.t-ipconnect.de [IPv6:2003:c5:9722:1100:fc44:a592:f3d4:96ba])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4B37162059;
        Tue, 26 May 2020 12:00:09 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net-next: batman-adv 2020-05-26
Date:   Tue, 26 May 2020 12:00:04 +0200
Message-Id: <20200526100007.10501-1-sw@simonwunderlich.de>
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

The following changes since commit 1a33e10e4a95cb109ff1145098175df3113313ef:

  net: partially revert dynamic lockdep key changes (2020-05-04 12:05:56 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20200526

for you to fetch changes up to 9ad346c90509ebd983f60da7d082f261ad329507:

  batman-adv: Revert "disable ethtool link speed detection when auto negotiation off" (2020-05-26 09:23:33 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - Fix revert dynamic lockdep key changes for batman-adv,
   by Sven Eckelmann

 - use rcu_replace_pointer() where appropriate, by Antonio Quartulli

 - Revert "disable ethtool link speed detection when auto negotiation
   off", by Sven Eckelmann

----------------------------------------------------------------
Antonio Quartulli (1):
      batman-adv: use rcu_replace_pointer() where appropriate

Sven Eckelmann (2):
      batman-adv: Revert "Drop lockdep.h include for soft-interface.c"
      batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

 net/batman-adv/bat_v_elp.c      | 15 +--------------
 net/batman-adv/gateway_client.c |  4 ++--
 net/batman-adv/hard-interface.c |  4 ++--
 net/batman-adv/routing.c        |  4 ++--
 net/batman-adv/soft-interface.c |  1 +
 5 files changed, 8 insertions(+), 20 deletions(-)
