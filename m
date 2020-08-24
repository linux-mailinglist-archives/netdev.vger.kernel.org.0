Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5409625025D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgHXQbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:31:10 -0400
Received: from simonwunderlich.de ([79.140.42.25]:47744 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgHXQas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:30:48 -0400
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 394C562016;
        Mon, 24 Aug 2020 18:21:14 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net: batman-adv 2020-08-24
Date:   Mon, 24 Aug 2020 18:21:08 +0200
Message-Id: <20200824162111.29220-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here are some bugfixes which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20200824

for you to fetch changes up to 279e89b2281af3b1a9f04906e157992c19c9f163:

  batman-adv: bla: use netif_rx_ni when not in interrupt context (2020-08-18 19:40:03 +0200)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - Avoid uninitialized memory access when handling DHCP, by Sven Eckelmann

 - Fix check for own OGM in OGM receive handler, by Linus Luessing

 - Fix netif_rx access for non-interrupt context in BLA, by Jussi Kivilinna

----------------------------------------------------------------
Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Linus Lüssing (1):
      batman-adv: Fix own OGM check in aggregated OGMs

Sven Eckelmann (1):
      batman-adv: Avoid uninitialized chaddr when handling DHCP

 net/batman-adv/bat_v_ogm.c             | 11 ++++++-----
 net/batman-adv/bridge_loop_avoidance.c |  5 ++++-
 net/batman-adv/gateway_client.c        |  6 ++++--
 3 files changed, 14 insertions(+), 8 deletions(-)
