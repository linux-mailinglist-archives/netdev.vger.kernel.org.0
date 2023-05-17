Return-Path: <netdev+bounces-3384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4847C706C7F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5322281183
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F314DA95E;
	Wed, 17 May 2023 15:19:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858095257
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AF6C433EF;
	Wed, 17 May 2023 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684336755;
	bh=TJN15N5//cyqL/A0HblEleiYwDeDu1JM60zgbQ2Gitw=;
	h=From:Subject:To:Cc:Date:From;
	b=QGsJhA/OO1jw2n55mEsvZJpyDBEiEs2Uh1tgBb3SBRlf/gvEMxDetdB1JcCBKCxx4
	 qyv7GuSssvDJiH3MbDVfLq13xkUOOUJkDD1NdfE1vPJGVGQfrznqavpKx5YjjJNVzx
	 /bOxXjgClnKX3uSLzQihOBmAWE+mXGiCUvV/fC/cDVslxNPodcYNZ3QzlA8zjt8f2/
	 WvrDdaeRvqU4cS7TNZJAt6oYdEgmAAuegNhigQT3w039YcyJ44UcKriLQaFz441TLR
	 Nu6WVok/YlRgmzqKKnb1O7efQBlw21b/vSX/HhytjsS80vuSJue9Ne7J9CHM9NeoM8
	 z0vPl88tv8QOg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-05-17
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Message-Id: <20230517151914.B0AF6C433EF@smtp.kernel.org>
Date: Wed, 17 May 2023 15:19:14 +0000 (UTC)

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-05-17

for you to fetch changes up to 212457ccbd60dba34f965e4ffbe62f0e4f970538:

  wifi: b43: fix incorrect __packed annotation (2023-05-17 09:24:09 +0300)

----------------------------------------------------------------
wireless fixes for v6.4

A lot of fixes this time, for both the stack and the drivers. The
brcmfmac resume fix has been reported by several people so I would say
it's the most important here. The iwlwifi RFI workaround is also
something which was reported as a regression recently.

----------------------------------------------------------------
Alon Giladi (2):
      wifi: iwlwifi: fix OEM's name in the ppag approved list
      wifi: iwlwifi: mvm: fix OEM's name in the tas approved list

Ariel Malamud (1):
      wifi: iwlwifi: mvm: Add locking to the rate read flow

Arnd Bergmann (1):
      wifi: b43: fix incorrect __packed annotation

Christophe JAILLET (1):
      wifi: mac80211: Fix puncturing bitmap handling in __ieee80211_csa_finalize()

Gregory Greenman (2):
      wifi: iwlwifi: mvm: rfi: disable RFI feature
      wifi: iwlwifi: mvm: fix access to fw_id_to_mac_id

Hans de Goede (1):
      wifi: brcmfmac: Check for probe() id argument being NULL

Ilan Peer (1):
      wifi: cfg80211: Drop entries with invalid BSSIDs in RNR

Johannes Berg (10):
      wifi: mac80211: fix min center freq offset tracing
      wifi: mac80211: simplify chanctx allocation
      wifi: mac80211: consider reserved chanctx for mindef
      wifi: mac80211: recalc chanctx mindef before assigning
      wifi: iwlwifi: mvm: always free dup_data
      wifi: iwlwifi: mvm: don't double-init spinlock
      wifi: iwlwifi: mvm: fix cancel_delayed_work_sync() deadlock
      wifi: iwlwifi: mvm: fix number of concurrent link checks
      wifi: iwlwifi: fw: fix DBGI dump
      wifi: iwlwifi: mvm: don't trust firmware n_channels

Martin Blumenstingl (1):
      wifi: rtw88: sdio: Always use two consecutive bytes for word operations

Michael Lee (1):
      wifi: mac80211: Abort running color change when stopping the AP

Miri Korenblit (1):
      wifi: iwlwifi: Don't use valid_links to iterate sta links

Mirsad Goran Todorovac (1):
      wifi: mac80211: fortify the spinlock against deadlock by interrupt

Mukesh Sisodiya (1):
      wifi: iwlwifi: mvm: fix initialization of a return value

Ping-Ke Shih (3):
      wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
      wifi: rtw88: use work to update rate to avoid RCU warning
      wifi: rtw88: correct qsel_to_ep[] type as int

Ryder Lee (2):
      wifi: mt76: mt7996: fix endianness of MT_TXD6_TX_RATE
      wifi: mt76: connac: fix stats->tx_bytes calculation

Yun Lu (1):
      wifi: rtl8xxxu: fix authentication timeout due to incorrect RCR value

Zhengchao Shao (1):
      mac80211_hwsim: fix memory leak in hwsim_new_radio_nl

 drivers/net/wireless/broadcom/b43/b43.h            |  2 +-
 .../net/wireless/broadcom/b43legacy/b43legacy.h    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 11 ++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 11 ++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 19 +++---
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      | 12 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 55 ++++++++--------
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |  9 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   | 14 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 10 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       | 16 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 13 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  2 +-
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  4 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  2 +-
 drivers/net/wireless/realtek/rtw88/main.c          | 15 +++++
 drivers/net/wireless/realtek/rtw88/main.h          |  3 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |  8 ---
 drivers/net/wireless/realtek/rtw88/usb.h           |  2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  4 ++
 drivers/net/wireless/realtek/rtw89/mac.h           |  2 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      | 28 ++++----
 drivers/net/wireless/virtual/mac80211_hwsim.c      |  3 +-
 net/mac80211/cfg.c                                 |  7 +-
 net/mac80211/chan.c                                | 75 ++++++++++++++--------
 net/mac80211/ieee80211_i.h                         |  3 +-
 net/mac80211/trace.h                               |  2 +-
 net/mac80211/tx.c                                  |  5 +-
 net/mac80211/util.c                                |  2 +-
 net/wireless/scan.c                                |  6 +-
 41 files changed, 249 insertions(+), 136 deletions(-)

