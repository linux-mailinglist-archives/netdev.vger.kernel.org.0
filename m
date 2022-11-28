Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB5263A73F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiK1LfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiK1LfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:35:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FBE12616;
        Mon, 28 Nov 2022 03:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419EFB80D59;
        Mon, 28 Nov 2022 11:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F459C433C1;
        Mon, 28 Nov 2022 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669635314;
        bh=ZkIZfPnaLcuA/RaAoaCVtaq1MX5bTLkRHY/vKivsiG8=;
        h=From:Subject:To:Cc:Date:From;
        b=h18736wmHeS+bd2tolnynxk2I/nj1FMGa6Wg5620SlaSsTgkP9w6q2SYT8BUSYLTP
         9N3vdoIhWHz+QtRLSw099OPkf/EEctQxu0tPNzR3XSxT7TJHcNt8EkGQgC22K2+KAT
         TVFou+H7W8PaSesqZJ7GoXVIJp2AhcPY5fBImy2+BEoDSorDa2zIeFFmlRBuKAA6ih
         tIOd4olKnKTJ0VNmwub+Y7AFvRWyOmCSIsFzoHLyC2jeTQzYMctMCoENssr6qKs3jn
         sUyQqkP7n3nid2Fny1wzmry5UqjXb7G86VL1yn+9Hjv33Jl79+beC/XbSPjqPqAPbm
         gjmjjGBYJydMw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-11-28
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221128113513.6F459C433C1@smtp.kernel.org>
Date:   Mon, 28 Nov 2022 11:35:13 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 91018bbcc664b6c9410ddccacd2239a4acadcfc9:

  Merge tag 'wireless-2022-11-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2022-11-03 21:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-11-28

for you to fetch changes up to 3e8f7abcc3473bc9603323803aeaed4ffcc3a2ab:

  wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration (2022-11-25 12:45:53 +0100)

----------------------------------------------------------------
wireless fixes for v6.1

Third, and hopefully final, set of fixes for v6.1. We are marking the
rsi driver as orphan, have some Information Element parsing fixes to
wilc1000 driver and three small fixes to the stack.

----------------------------------------------------------------
Johannes Berg (2):
      wifi: cfg80211: fix buffer overflow in elem comparison
      wifi: cfg80211: don't allow multi-BSSID in S1G

Lorenzo Bianconi (1):
      wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

Marek Vasut (1):
      MAINTAINERS: mark rsi wifi driver as orphan

Phil Turnbull (4):
      wifi: wilc1000: validate pairwise and authentication suite offsets
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
      wifi: wilc1000: validate number of channels

 MAINTAINERS                                        |  4 +--
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 39 +++++++++++++++++-----
 drivers/net/wireless/microchip/wilc1000/hif.c      | 21 +++++++++---
 net/mac80211/airtime.c                             |  3 ++
 net/wireless/scan.c                                | 10 ++++--
 5 files changed, 58 insertions(+), 19 deletions(-)
