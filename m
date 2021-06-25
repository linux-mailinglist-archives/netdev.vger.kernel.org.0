Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772733B4A54
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFYV7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 17:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhFYV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 17:59:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44290C061574;
        Fri, 25 Jun 2021 14:56:43 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lwtoW-00BaXN-Pf; Fri, 25 Jun 2021 23:56:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-06-25
Date:   Fri, 25 Jun 2021 23:56:34 +0200
Message-Id: <20210625215635.10743-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a bunch of new changes for -next. I meant to include
another set of patches handling some 6 GHz regulatory stuff,
but still had some questions so wanted to get this out now,
so I don't miss the merge window with everything...

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 38f75922a6905b010f597fc70dbb5db28398728e:

  Merge branch 'mptcp-C-flag-and-fixes' (2021-06-22 14:36:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-06-25

for you to fetch changes up to 2433647bc8d983a543e7d31b41ca2de1c7e2c198:

  mac80211: Switch to a virtual time-based airtime scheduler (2021-06-23 18:12:00 +0200)

----------------------------------------------------------------
Lots of changes:
 * aggregation handling improvements for some drivers
 * hidden AP discovery on 6 GHz and other HE 6 GHz
   improvements
 * minstrel improvements for no-ack frames
 * deferred rate control for TXQs to improve reaction
   times
 * virtual time-based airtime scheduler
 * along with various little cleanups/fixups

----------------------------------------------------------------
Abinaya Kalaiselvan (1):
      mac80211: fix NULL ptr dereference during mesh peer connection for non HE devices

Avraham Stern (1):
      nl80211/cfg80211: add BSS color to NDP ranging parameters

Bassem Dawood (1):
      mac80211: Enable power save after receiving NULL packet ACK

Christophe JAILLET (1):
      ieee80211: add the value for Category '6' in "rtw_ieee80211_category"

Dan Carpenter (1):
      cfg80211: clean up variable use in cfg80211_parse_colocated_ap()

Emmanuel Grumbach (1):
      cfg80211: expose the rfkill device to the low level driver

Felix Fietkau (2):
      mac80211: move A-MPDU session check from minstrel_ht to mac80211
      mac80211: remove iwlwifi specific workaround that broke sta NDP tx

Gustavo A. R. Silva (1):
      wireless: wext-spy: Fix out-of-bounds warning

Ilan Peer (2):
      mac80211: Properly WARN on HW scan before restart
      cfg80211: Support hidden AP discovery over 6GHz band

Johannes Berg (23):
      cfg80211: remove CFG80211_MAX_NUM_DIFFERENT_CHANNELS
      mac80211: unify queueing SKB to iface
      mac80211: refactor SKB queue processing a bit
      mac80211: use sdata->skb_queue for TDLS
      mac80211: simplify ieee80211_add_station()
      mac80211: consider per-CPU statistics if present
      mac80211: don't open-code LED manipulations
      mac80211: allow SMPS requests only in client mode
      mac80211: free skb in WEP error case
      ieee80211: add defines for HE PHY cap byte 10
      mac80211: rearrange struct txq_info for fewer holes
      mac80211: improve AP disconnect message
      cfg80211: trace more information in assoc trace event
      mac80211: remove use of ieee80211_get_he_sta_cap()
      cfg80211: remove ieee80211_get_he_sta_cap()
      cfg80211: reg: improve bad regulatory warning
      cfg80211: add cfg80211_any_usable_channels()
      mac80211: conditionally advertise HE in probe requests
      cfg80211: allow advertising vendor-specific capabilities
      mac80211: add vendor-specific capabilities to assoc request
      mac80211: always include HE 6GHz capability in probe request
      mac80211: notify driver on mgd TX completion
      mac80211: add HE 6 GHz capability only if supported

Krishnanand Prabhu (1):
      ieee80211: define timing measurement in extended capabilities IE

Miri Korenblit (1):
      cfg80211: set custom regdomain after wiphy registration

Mordechay Goodstein (1):
      mac80211: handle rate control (RC) racing with chanctx definition

Nguyen Dinh Phi (1):
      mac80211_hwsim: record stats in non-netlink path

Philipp Borgers (4):
      mac80211: minstrel_ht: ignore frame that was sent with noAck flag
      mac80211: add ieee80211_is_tx_data helper function
      mac80211: do not use low data rates for data frames with no ack flag
      mac80211: refactor rc_no_data_or_no_ack_use_min function

Ping-Ke Shih (3):
      cfg80211: fix default HE tx bitrate mask in 2G band
      mac80211: remove iwlwifi specific workaround NDPs of null_response
      Revert "mac80211: HE STA disassoc due to QOS NULL not sent"

Ryder Lee (3):
      mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue
      mac80211: add rate control support for encap offload
      mac80211: check per vif offload_flags in Tx path

Shaokun Zhang (1):
      mac80211: remove the repeated declaration

Shaul Triebitz (2):
      mac80211: move SMPS mode setting after ieee80211_prep_connection
      mac80211: add to bss_conf if broadcast TWT is supported

Sosthène Guédon (1):
      nl80211: Fix typo pmsr->pmsr

Toke Høiland-Jørgensen (1):
      mac80211: Switch to a virtual time-based airtime scheduler

Weilun Du (1):
      mac80211_hwsim: add concurrent channels scanning support over virtio

Wen Gong (1):
      wireless: add check of field VHT Extended NSS BW Capable for 160/80+80 MHz setting

Yang Li (2):
      net: wireless: wext_compat.c: Remove redundant assignment to ps
      mac80211: Remove redundant assignment to ret

Zheng Yongjun (1):
      mac80211: fix some spelling mistakes

 drivers/net/wireless/ath/ath9k/main.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |   3 +
 drivers/net/wireless/mac80211_hwsim.c             |  55 ++-
 drivers/net/wireless/realtek/rtw88/mac80211.c     |   2 +-
 include/linux/ieee80211.h                         |  10 +-
 include/net/cfg80211.h                            |  49 ++-
 include/net/mac80211.h                            |  72 +++-
 include/uapi/linux/nl80211.h                      |   9 +-
 net/mac80211/cfg.c                                |  45 ++-
 net/mac80211/chan.c                               | 108 +++--
 net/mac80211/debugfs.c                            |  70 +++-
 net/mac80211/debugfs_netdev.c                     |  33 +-
 net/mac80211/debugfs_sta.c                        |  24 +-
 net/mac80211/driver-ops.h                         |  26 +-
 net/mac80211/he.c                                 |   8 +-
 net/mac80211/ht.c                                 |  18 +-
 net/mac80211/ieee80211_i.h                        | 194 ++++++++-
 net/mac80211/iface.c                              | 234 ++++++-----
 net/mac80211/led.c                                |  12 +-
 net/mac80211/main.c                               |  32 +-
 net/mac80211/mesh.h                               |   2 +-
 net/mac80211/mesh_hwmp.c                          |   2 +-
 net/mac80211/mesh_pathtbl.c                       |   2 +-
 net/mac80211/mesh_plink.c                         |   2 +-
 net/mac80211/mlme.c                               | 248 +++++-------
 net/mac80211/rate.c                               |  13 +-
 net/mac80211/rc80211_minstrel_ht.c                |  34 +-
 net/mac80211/rx.c                                 |  54 ++-
 net/mac80211/sta_info.c                           |  83 ++--
 net/mac80211/sta_info.h                           |  11 +-
 net/mac80211/status.c                             |  26 +-
 net/mac80211/tdls.c                               |  28 +-
 net/mac80211/trace.h                              |  33 +-
 net/mac80211/tx.c                                 | 466 +++++++++++++++-------
 net/mac80211/util.c                               |  35 +-
 net/wireless/chan.c                               |  43 +-
 net/wireless/core.c                               |  50 +--
 net/wireless/core.h                               |   3 +-
 net/wireless/nl80211.c                            |  22 +-
 net/wireless/pmsr.c                               |  12 +
 net/wireless/rdev-ops.h                           |  12 +-
 net/wireless/reg.c                                |   5 +-
 net/wireless/scan.c                               |  22 +-
 net/wireless/trace.h                              |  36 +-
 net/wireless/wext-compat.c                        |   8 +-
 net/wireless/wext-spy.c                           |  14 +-
 47 files changed, 1492 insertions(+), 786 deletions(-)

