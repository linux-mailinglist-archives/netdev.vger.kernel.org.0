Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3962349B7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732856AbgGaQyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbgGaQyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:54:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9F2C061574;
        Fri, 31 Jul 2020 09:54:18 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k1YIR-00EBrk-IT; Fri, 31 Jul 2020 18:54:15 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-07-31
Date:   Fri, 31 Jul 2020 18:54:02 +0200
Message-Id: <20200731165403.31899-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a set of patches for -next, in case we get a release
on Sunday :-) If not I may have some more next week, but no
point waiting now with this.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 41d707b7332f1386642c47eb078110ca368a46f5:

  fib: fix fib_rules_ops indirect calls wrappers (2020-07-29 13:26:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2020-07-31

for you to fetch changes up to c8ad010665c0b85c6a35466b2159e907b8dd85d1:

  mac80211: warn only once in check_sdata_in_driver() at each caller (2020-07-31 09:27:02 +0200)

----------------------------------------------------------------
We have a number of changes
 * code cleanups and fixups as usual
 * AQL & internal TXQ improvements from Felix
 * some mesh 802.1X support bits
 * some injection improvements from Mathy of KRACK
   fame, so we'll see what this results in ;-)
 * some more initial S1G supports bits, this time
   (some of?) the userspace APIs

----------------------------------------------------------------
Christophe JAILLET (2):
      nl80211: Remove a misleading label in 'nl80211_trigger_scan()'
      nl80211: Simplify error handling path in 'nl80211_trigger_scan()'

Chung-Hsien Hsu (1):
      nl80211: support 4-way handshake offloading for WPA/WPA2-PSK in AP mode

Colin Ian King (1):
      mac80211: remove the need for variable rates_idx

Emmanuel Grumbach (1):
      cfg80211: allow the low level driver to flush the BSS table

Felix Fietkau (4):
      mac80211: improve AQL tx airtime estimation
      net/fq_impl: use skb_get_hash instead of skb_get_hash_perturb
      mac80211: calculate skb hash early when using itxq
      mac80211: add a function for running rx without passing skbs to the stack

Gustavo A. R. Silva (1):
      mac80211: Use fallthrough pseudo-keyword

Johannes Berg (2):
      cfg80211: invert HE BSS color 'disabled' to 'enabled'
      mac80211: warn only once in check_sdata_in_driver() at each caller

Julian Squires (1):
      cfg80211: allow vendor dumpit to terminate by returning 0

Linus Lüssing (1):
      cfg80211/mac80211: add mesh_param "mesh_nolearn" to skip path discovery

Markus Theil (2):
      cfg80211/mac80211: add connected to auth server to meshconf
      cfg80211/mac80211: add connected to auth server to station info

Mathy Vanhoef (6):
      mac80211: never drop injected frames even if normally not allowed
      mac80211: add radiotap flag to prevent sequence number overwrite
      mac80211: do not overwrite the sequence number if requested
      mac80211: use same flag everywhere to avoid sequence number overwrite
      mac80211: remove unused flags argument in transmit functions
      mac80211: parse radiotap header when selecting Tx queue

P Praneesh (1):
      cfg80211/mac80211: avoid bss color setting in non-HE modes

Randy Dunlap (5):
      net/wireless: nl80211.h: drop duplicate words in comments
      net/wireless: wireless.h: drop duplicate word in comments
      net/wireless: cfg80211.h: drop duplicate words in comments
      net/wireless: mac80211.h: drop duplicate words in comments
      net/wireless: regulatory.h: drop duplicate word in comment

Thomas Pedersen (1):
      nl80211: S1G band and channel definitions

Veerendranath Jakkam (1):
      cfg80211: Add support to advertize OCV support

 drivers/net/wireless/ath/ath10k/mac.c |  9 +---
 drivers/net/wireless/ath/ath11k/mac.c |  2 +-
 drivers/net/wireless/mac80211_hwsim.c |  2 +-
 include/net/cfg80211.h                | 41 +++++++++++++--
 include/net/fq.h                      |  1 -
 include/net/fq_impl.h                 |  3 +-
 include/net/ieee80211_radiotap.h      |  1 +
 include/net/mac80211.h                | 42 +++++++++++++--
 include/net/regulatory.h              |  2 +-
 include/uapi/linux/nl80211.h          | 94 +++++++++++++++++++++++++--------
 include/uapi/linux/wireless.h         |  2 +-
 net/mac80211/airtime.c                | 26 +++++++--
 net/mac80211/cfg.c                    | 21 +++++---
 net/mac80211/chan.c                   |  9 +++-
 net/mac80211/debugfs_netdev.c         |  5 ++
 net/mac80211/driver-ops.h             | 11 ++--
 net/mac80211/ht.c                     |  4 +-
 net/mac80211/ibss.c                   |  4 +-
 net/mac80211/ieee80211_i.h            | 16 +++---
 net/mac80211/iface.c                  | 25 +++++----
 net/mac80211/key.c                    |  2 +-
 net/mac80211/mesh.c                   |  9 ++--
 net/mac80211/mesh_hwmp.c              | 41 ++++++++++++++-
 net/mac80211/mesh_plink.c             |  2 +-
 net/mac80211/mlme.c                   | 14 ++---
 net/mac80211/offchannel.c             |  6 +--
 net/mac80211/rx.c                     | 66 ++++++++++++++---------
 net/mac80211/scan.c                   |  8 +--
 net/mac80211/sta_info.c               |  6 ++-
 net/mac80211/sta_info.h               |  2 +
 net/mac80211/status.c                 |  4 +-
 net/mac80211/tdls.c                   |  8 +--
 net/mac80211/tx.c                     | 99 +++++++++++++++++------------------
 net/mac80211/util.c                   | 20 ++++---
 net/mac80211/wme.c                    |  2 +-
 net/wireless/chan.c                   | 35 +++++++++++++
 net/wireless/core.c                   |  5 +-
 net/wireless/mesh.c                   |  1 +
 net/wireless/nl80211.c                | 74 ++++++++++++++------------
 net/wireless/scan.c                   | 10 ++++
 net/wireless/trace.h                  |  4 +-
 net/wireless/util.c                   |  8 +++
 42 files changed, 511 insertions(+), 235 deletions(-)

