Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD1B33922E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhCLPrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:47:47 -0500
Received: from simonwunderlich.de ([79.140.42.25]:38816 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhCLPre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:47:34 -0500
Received: from kero.packetmixer.de (p4fd57512.dip0.t-ipconnect.de [79.213.117.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 891DF174022;
        Fri, 12 Mar 2021 16:47:32 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net-next: batman-adv 2021-03-12
Date:   Fri, 12 Mar 2021 16:47:23 +0100
Message-Id: <20210312154724.14980-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

this time we only have one patch in the pull request of batman-adv to
go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 25d81f9307ffc166427d93152498f45178f5936a:

  batman-adv: Fix names for kernel-doc blocks (2021-02-06 09:22:45 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20210312

for you to fetch changes up to b1de0f01b0115575982cf24c88b35106449e9aa7:

  batman-adv: Use netif_rx_any_context(). (2021-02-13 18:08:40 +0100)

----------------------------------------------------------------
There is only a single patch this time:

 - Use netif_rx_any_context(), by Sebastian Andrzej Siewior

----------------------------------------------------------------
Sebastian Andrzej Siewior (1):
      batman-adv: Use netif_rx_any_context().

 net/batman-adv/bridge_loop_avoidance.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
