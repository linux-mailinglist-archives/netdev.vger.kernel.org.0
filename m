Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E19F4BF3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKHMhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:37:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60362 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfKHMhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:37:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iT3WO-0002bo-7o; Fri, 08 Nov 2019 13:37:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2019-11-08
Date:   Fri,  8 Nov 2019 13:37:36 +0100
Message-Id: <20191108123738.17359-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here are a couple of more things for net-next. Nothing
really that relevant, but I figured I'd flush my queue
now and get some preparatory patches in for 5.5 still.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 5b7fe93db008ff013db24239136a25f3ac5142ac:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2019-10-26 22:57:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2019-11-08

for you to fetch changes up to 14f34e36b36ceede9877ca422a62fcac17b52023:

  cfg80211: VLAN offload support for set_key and set_sta_vlan (2019-11-08 11:19:19 +0100)

----------------------------------------------------------------
Some relatively small changes:
 * typo fixes in docs
 * APIs for station separation using VLAN tags rather
   than separate wifi netdevs
 * some preparations for upcoming features (802.3 offload
   and airtime queue limits (AQL)
 * stack reduction in ieee80211_assoc_success()
 * use DEFINE_DEBUGFS_ATTRIBUTE in hwsim

----------------------------------------------------------------
Chris Packham (1):
      mac80211: typo fixes in kerneldoc comments

Gurumoorthi Gnanasambandhan (1):
      cfg80211: VLAN offload support for set_key and set_sta_vlan

Joe Perches (1):
      mac80211: fix a typo of "function"

Johannes Berg (1):
      mac80211: don't re-parse elems in ieee80211_assoc_success()

John Crispin (1):
      mac80211: move store skb ack code to its own function

Toke Høiland-Jørgensen (1):
      mac80211: Shrink the size of ack_frame_id to make room for tx_time_est

zhong jiang (1):
      mac80211_hwsim: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops

 drivers/net/wireless/mac80211_hwsim.c |  14 ++---
 include/net/cfg80211.h                |   4 ++
 include/net/mac80211.h                |  22 ++++----
 include/uapi/linux/nl80211.h          |  26 +++++++++
 net/mac80211/cfg.c                    |   2 +-
 net/mac80211/mlme.c                   | 103 ++++++++++++++++------------------
 net/mac80211/tx.c                     |  49 +++++++++-------
 net/wireless/nl80211.c                |  11 ++++
 8 files changed, 139 insertions(+), 92 deletions(-)

