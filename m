Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C9E18CF52
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCTNqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:46:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46446 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:46:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jFHz9-00Ay9P-Ey; Fri, 20 Mar 2020 14:46:51 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-03-20
Date:   Fri, 20 Mar 2020 14:46:41 +0100
Message-Id: <20200320134642.87932-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's another set of changes for net-next, nothing really stands out,
but see the description and shortlog below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 74522e7baae2561870ea8ddf09dc6a126458cd7b:

  net: sched: set the hw_stats_type in pedit loop (2020-03-16 02:13:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-03-20

for you to fetch changes up to 8fa180bb4aceaa25233ea61032eab5b025fb522f:

  mac80211: driver can remain on channel if not using chan_ctx (2020-03-20 14:42:21 +0100)

----------------------------------------------------------------
Another set of changes:
 * HE ranging (fine timing measurement) API support
 * hwsim gets virtio support, for use with wmediumd,
   to be able to simulate with multiple machines
 * eapol-over-nl80211 improvements to exclude preauth
 * IBSS reset support, to recover connections from
   userspace
 * and various others.

----------------------------------------------------------------
Avraham Stern (1):
      nl80211/cfg80211: add support for non EDCA based ranging measurement

Erel Geron (1):
      mac80211_hwsim: add frame transmission support over virtio

Johannes Berg (4):
      cfg80211: fix documentation format
      mac80211: don't leave skb->next/prev pointing to stack
      mac80211: consider WLAN_EID_EXT_HE_OPERATION for parsing CRC
      nl80211: clarify code in nl80211_del_station()

Markus Theil (2):
      nl80211: add no pre-auth attribute and ext. feature flag for ctrl. port
      mac80211: handle no-preauth flag for control port

Nicolas Cavallari (2):
      cfg80211: Add support for userspace to reset stations in IBSS mode
      mac80211: Allow deleting stations in ibss mode to reset their state

Qiujun Huang (1):
      mac80211: update documentation about tx power

Seevalamuthu Mariappan (1):
      mac80211: Read rx_stats with perCPU pointers

Shaul Triebitz (3):
      nl80211: pass HE operation element to the driver
      mac80211: HE: set missing bss_conf fields in AP mode
      nl80211: add PROTECTED_TWT nl80211 extended feature

Taehee Yoo (1):
      virt_wifi: implement ndo_get_iflink

Veerendranath Jakkam (1):
      cfg80211: Configure PMK lifetime and reauth threshold for PMKSA entries

Yan-Hsuan Chuang (1):
      mac80211: driver can remain on channel if not using chan_ctx

 drivers/net/wireless/mac80211_hwsim.c | 327 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/mac80211_hwsim.h |  21 +++
 drivers/net/wireless/virt_wifi.c      |  12 +-
 include/net/cfg80211.h                |  36 +++-
 include/net/mac80211.h                |   5 +
 include/uapi/linux/nl80211.h          |  73 +++++++-
 include/uapi/linux/virtio_ids.h       |   1 +
 net/mac80211/cfg.c                    |  16 +-
 net/mac80211/ieee80211_i.h            |   1 +
 net/mac80211/iface.c                  |   4 +
 net/mac80211/main.c                   |   8 +-
 net/mac80211/mlme.c                   |   1 +
 net/mac80211/rx.c                     |   3 +-
 net/mac80211/sta_info.c               |  35 +++-
 net/mac80211/tx.c                     |   6 +-
 net/mac80211/util.c                   |   6 +-
 net/wireless/core.c                   |   6 +
 net/wireless/nl80211.c                |  47 ++++-
 net/wireless/pmsr.c                   |  32 ++++
 19 files changed, 596 insertions(+), 44 deletions(-)

