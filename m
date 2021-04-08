Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6927C358284
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhDHLyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:54:22 -0400
Received: from simonwunderlich.de ([79.140.42.25]:33472 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhDHLyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:54:19 -0400
Received: from kero.packetmixer.de (p200300c5971bd8e0263584131c53e2d7.dip0.t-ipconnect.de [IPv6:2003:c5:971b:d8e0:2635:8413:1c53:e2d7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D712B17401F;
        Thu,  8 Apr 2021 13:54:02 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net-next: batman-adv 2021-04-08
Date:   Thu,  8 Apr 2021 13:53:58 +0200
Message-Id: <20210408115401.16988-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

here is a little cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit b1de0f01b0115575982cf24c88b35106449e9aa7:

  batman-adv: Use netif_rx_any_context(). (2021-02-13 18:08:40 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20210408

for you to fetch changes up to 35796c1d343871fa75a6e6b0f4584182cbeae6ac:

  batman-adv: Fix misspelled "wont" (2021-03-30 21:19:50 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - for kerneldoc in batadv_priv, by Linus Luessing

 - drop unused header preempt.h, by Sven Eckelmann

 - Fix misspelled "wont", by Sven Eckelmann

----------------------------------------------------------------
Linus Lüssing (1):
      batman-adv: Fix order of kernel doc in batadv_priv

Sven Eckelmann (2):
      batman-adv: Drop unused header preempt.h
      batman-adv: Fix misspelled "wont"

 net/batman-adv/bat_iv_ogm.c            |  2 +-
 net/batman-adv/bridge_loop_avoidance.c |  1 -
 net/batman-adv/types.h                 | 10 +++++-----
 3 files changed, 6 insertions(+), 7 deletions(-)
