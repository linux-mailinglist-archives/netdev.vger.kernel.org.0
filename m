Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD46365BA6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhDTPBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDTPBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:01:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4986AC06174A;
        Tue, 20 Apr 2021 08:00:38 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lYrrf-00EJf2-Ba; Tue, 20 Apr 2021 17:00:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-04-20
Date:   Tue, 20 Apr 2021 17:00:30 +0200
Message-Id: <20210420150031.24514-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a bunch more things for next, now that we got another
week "for free" ;-) Pretty much all over the map, see the tag
description and shortlog below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 3cd52c1e32fe7dfee09815ced702db9ee9f84ec9:

  net: fealnx: use module_pci_driver to simplify the code (2021-04-07 15:15:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-04-20

for you to fetch changes up to 010bfbe768f7ecc876ffba92db30432de4997e2a:

  cfg80211: scan: drop entry from hidden_list on overflow (2021-04-19 13:25:50 +0200)

----------------------------------------------------------------
Another set of updates, all over the map:
 * set sk_pacing_shift for 802.3->802.11 encap offload
 * some monitor support for 802.11->802.3 decap offload
 * HE (802.11ax) spec updates
 * userspace API for TDLS HE support
 * along with various other small features, cleanups and
   fixups

----------------------------------------------------------------
Aloka Dixit (1):
      nl80211: Add missing line in nl80211_fils_discovery_policy

Avraham Stern (2):
      ieee80211: add the values of ranging parameters max LTF total field
      nl80211/cfg80211: add a flag to negotiate for LMR feedback in NDP ranging

Colin Ian King (2):
      mac80211: remove redundant assignment of variable result
      mac80211: minstrel_ht: remove extraneous indentation on if statement

Emmanuel Grumbach (5):
      cfg80211: allow specifying a reason for hw_rfkill
      mac80211: clear the beacon's CRC after channel switch
      cfg80211: fix an htmldoc warning
      mac80211: make ieee80211_vif_to_wdev work when the vif isn't in the driver
      mac80211: properly drop the connection in case of invalid CSA IE

Guobin Huang (2):
      rfkill: use DEFINE_SPINLOCK() for spinlock
      mac80211_hwsim: use DEFINE_SPINLOCK() for spinlock

Ilan Peer (2):
      cfg80211: Remove wrong RNR IE validation check
      nl80211: Add new RSNXE related nl80211 extended features

James Prestwood (1):
      nl80211: better document CMD_ROAM behavior

Joe Perches (1):
      cfg80211: constify ieee80211_get_response_rate return

Johan Almbladh (1):
      mac80211: Set priority and queue mapping for injected frames

Johannes Berg (8):
      mac80211: don't apply flow control on management frames
      mac80211: bail out if cipher schemes are invalid
      mac80211: properly process TXQ management frames
      mac80211: aes_cmac: check crypto_shash_setkey() return value
      wireless: align some HE capabilities with the spec
      wireless: align HE capabilities A-MPDU Length Exponent Extension
      wireless: fix spelling of A-MSDU in HE capabilities
      cfg80211: scan: drop entry from hidden_list on overflow

Lorenzo Bianconi (1):
      mac80211: set sk_pacing_shift for 802.3 txpath

Naftali Goldstein (1):
      mac80211: drop the connection if firmware crashed while in CSA

Qiheng Lin (1):
      cfg80211: regulatory: use DEFINE_SPINLOCK() for spinlock

Randy Dunlap (1):
      cfg80211: fix a few kernel-doc warnings

Sriram R (1):
      mac80211: Allow concurrent monitor iface and ethernet rx decap

Vamsi Krishna (1):
      nl80211: Add interface to indicate TDLS peer's HE capability

Wei Yongjun (1):
      mac80211: minstrel_ht: remove unused variable 'mg' in minstrel_ht_next_jump_rate()

 drivers/net/wireless/ath/ath11k/mac.c              | 15 +++---
 drivers/net/wireless/broadcom/b43/main.c           |  2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 14 +++---
 drivers/net/wireless/mac80211_hwsim.c              | 24 ++++-----
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 14 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  6 +--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  6 +--
 include/linux/ieee80211.h                          | 33 ++++++------
 include/net/cfg80211.h                             | 24 ++++++---
 include/net/mac80211.h                             | 12 +++--
 include/uapi/linux/nl80211.h                       | 22 ++++++++
 net/mac80211/aes_cmac.c                            | 11 +++-
 net/mac80211/debugfs.c                             |  1 +
 net/mac80211/debugfs_sta.c                         | 37 +++++++-------
 net/mac80211/ieee80211_i.h                         |  2 +
 net/mac80211/iface.c                               |  3 +-
 net/mac80211/main.c                                | 16 ++++--
 net/mac80211/mlme.c                                | 16 +++---
 net/mac80211/rc80211_minstrel_ht.c                 |  4 +-
 net/mac80211/tx.c                                  | 58 +++++++++++++++-------
 net/mac80211/util.c                                | 10 +---
 net/rfkill/input.c                                 |  4 +-
 net/wireless/core.c                                |  7 +--
 net/wireless/nl80211.c                             |  8 +--
 net/wireless/pmsr.c                                | 12 ++++-
 net/wireless/reg.c                                 | 10 ++--
 net/wireless/scan.c                                |  4 +-
 net/wireless/util.c                                |  2 +-
 30 files changed, 232 insertions(+), 149 deletions(-)

