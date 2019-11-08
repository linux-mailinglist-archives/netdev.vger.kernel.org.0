Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2CEF4BF9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfKHMi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:38:56 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60428 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfKHMi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:38:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iT3XS-0002dE-81; Fri, 08 Nov 2019 13:38:54 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-11-08
Date:   Fri,  8 Nov 2019 13:38:49 +0100
Message-Id: <20191108123850.17527-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Three more small fixes for the current cycle - the allocation
and its failure must've been around for a while but we've started
hitting it (I'm also investigating if we have a leak), and the
inactive time thing also must've been around forever.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit e0a312629fefa943534fc46f7bfbe6de3fdaf463:

  ipv4: Fix table id reference in fib_sync_down_addr (2019-11-07 16:14:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2019-11-08

for you to fetch changes up to 285531f9e6774e3be71da6673d475ff1a088d675:

  mac80211: fix station inactive_time shortly after boot (2019-11-08 09:17:28 +0100)

----------------------------------------------------------------
Three small fixes:
 * we hit a failure path bug related to
   ieee80211_txq_setup_flows()
 * also use kvmalloc() to make that less likely
 * fix a timing value shortly after boot (during
   INITIAL_JIFFIES)

----------------------------------------------------------------
Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Johannes Berg (1):
      mac80211: fix ieee80211_txq_setup_flows() failure path

Toke Høiland-Jørgensen (1):
      net/fq_impl: Switch to kvmalloc() for memory allocation

 include/net/fq_impl.h   | 4 ++--
 net/mac80211/main.c     | 2 +-
 net/mac80211/sta_info.c | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

