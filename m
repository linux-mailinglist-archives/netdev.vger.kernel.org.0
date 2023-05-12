Return-Path: <netdev+bounces-2121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF8070056C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F361C20E1B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D208D506;
	Fri, 12 May 2023 10:26:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6816BBE5B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C727C433EF;
	Fri, 12 May 2023 10:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683887208;
	bh=ZJjlXCsgilJlEHdWzlZFkVo0T9zgBWhPYF9/8+rz5iA=;
	h=From:Subject:To:Cc:Date:From;
	b=ZcwO+ZWtalRsKSYUynj6aPuSne1D/hLv6NgVXQMj2zesO5bC+etE+/XYRiwSrOwIw
	 BiG1Gis31ZBRqeJvzDw3JZ0T9o16z8mUkG4gP1F3mo1P+1xc0qfn4xwTk83IqGsVdR
	 NTVgiCyhRod7gzsGjzWq+WzTPn3gePm3d36Ape6mjvMBZCIvXZm2Od+LanBIdoa/XH
	 HPhiVvDbXDo+LH4REUxRjpvuIoymahouivigbJjfWQ3hiowkznTi/f3G8tDPgToqZj
	 qyAuF21hFouUw2n6gXdanGgK/6niRmJJyK1L/Q5muVfikQZeVU3+HCQKgDn+Uk/dqC
	 SBuZ/20YEG2FQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2023-05-12
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Message-Id: <20230512102647.8C727C433EF@smtp.kernel.org>
Date: Fri, 12 May 2023 10:26:47 +0000 (UTC)

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 28b17f6270f182e22cdad5a0fdc4979031e4486a:

  net: phy: marvell-88x2222: remove unnecessary (void*) conversions (2023-04-25 09:43:50 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-05-12

for you to fetch changes up to 8130e94e888bf90e495f88d1a1e63c43e1cfbc18:

  wifi: rtw89: suppress the log for specific SER called CMDPSR_FRZTO (2023-05-11 16:19:51 +0300)

----------------------------------------------------------------
wireless-next patches for v6.5

The first pull request for v6.5 and only driver changes this time.
rtl8xxxu has been making lots of progress lately and now has AP mode
support.

Major changes:

rtl8xxxu

* AP mode support, initially only for rtl8188f

rtw89

* provide RSSI, EVN and SNR statistics via debugfs

* support U-NII-4 channels on 5 GHz band

----------------------------------------------------------------
Amisha Patel (2):
      wifi: wilc1000: fix for absent RSN capabilities WFA testcase
      wifi: wilc1000: Increase ASSOC response buffer

Bitterblue Smith (1):
      wifi: rtl8xxxu: Support USB RX aggregation for the newer chips

Chia-Yuan Li (1):
      wifi: rtw89: add CFO XTAL registers field to support 8851B

Chih-Kang Chang (1):
      wifi: rtw89: 8851b: add support WoWLAN to 8851B

Chin-Yen Lee (1):
      wifi: rtw89: suppress the log for specific SER called CMDPSR_FRZTO

Christophe JAILLET (2):
      wifi: mwifiex: Use list_count_nodes()
      wifi: mwifiex: Fix the size of a memory allocation in mwifiex_ret_802_11_scan()

Dan Carpenter (2):
      wifi: rtw89: fix rtw89_read_chip_ver() for RTL8852B and RTL8851B
      wifi: rtw88: unlock on error path in rtw_ops_add_interface()

Eric Huang (3):
      wifi: rtw89: initialize antenna for antenna diversity
      wifi: rtw89: add RSSI based antenna diversity
      wifi: rtw89: add EVM for antenna diversity

Martin Kaiser (1):
      wifi: rtl8xxxu: rtl8xxxu_rx_complete(): remove unnecessary return

Martin Kaistra (18):
      wifi: rtl8xxxu: Add start_ap() callback
      wifi: rtl8xxxu: Select correct queue for beacon frames
      wifi: rtl8xxxu: Add beacon functions
      wifi: rtl8xxxu: Add set_tim() callback
      wifi: rtl8xxxu: Allow setting rts threshold to -1
      wifi: rtl8xxxu: Allow creating interface in AP mode
      wifi: rtl8xxxu: Actually use macid in rtl8xxxu_gen2_report_connect
      wifi: rtl8xxxu: Add parameter role to report_connect
      wifi: rtl8xxxu: Add parameter force to rtl8xxxu_refresh_rate_mask
      wifi: rtl8xxxu: Add sta_add() and sta_remove() callbacks
      wifi: rtl8xxxu: Put the macid in txdesc
      wifi: rtl8xxxu: Add parameter macid to update_rate_mask
      wifi: rtl8xxxu: Enable hw seq for mgmt/non-QoS data frames
      wifi: rtl8xxxu: Clean up filter configuration
      wifi: rtl8xxxu: Remove usage of ieee80211_get_tx_rate()
      wifi: rtl8xxxu: Remove usage of tx_info->control.rates[0].flags
      wifi: rtl8xxxu: Declare AP mode support for 8188f
      wifi: rtl8xxxu: Set maximum number of supported stations

Ping-Ke Shih (15):
      wifi: rtw89: use struct rtw89_phy_sts_ie0 instead of macro to access PHY IE0 status
      wifi: rtw89: set capability of TX antenna diversity
      wifi: rtw89: add RSSI statistics for the case of antenna diversity to debugfs
      wifi: rtw89: add EVM and SNR statistics to debugfs
      wifi: rtw89: 8851b: add 8851B basic chip_info
      wifi: rtw89: 8851be: add 8851BE PCI entry and fill PCI capabilities
      wifi: rtw89: 8851b: add NCTL post table
      wifi: rtw89: use chip_info::small_fifo_size to choose debug_mask
      wifi: rtw89: change naming of BA CAM from V1 to V0_EXT
      wifi: rtw89: 8851b: add DLE mem and HFC quota
      wifi: rtw89: 8851b: add set_channel_rf()
      wifi: rtw89: 8851b: rfk: add AACK
      wifi: rtw89: 8851b: rfk: add RCK
      wifi: rtw89: 8851b: rfk: add DACK
      wifi: rtw89: 8851b: rfk: add IQK

Wang Jikai (1):
      wifi: mt7601u: delete dead code checking debugfs returns

Zhang Shurong (2):
      wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
      wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*

Zong-Zhe Yang (10):
      wifi: rtw89: release bit in rtw89_fw_h2c_del_pkt_offload()
      wifi: rtw89: refine packet offload delete flow of 6 GHz probe
      wifi: rtw89: packet offload wait for FW response
      wifi: rtw89: mac: handle C2H receive/done ACK in interrupt context
      wifi: rtw89: scan offload wait for FW done ACK
      wifi: rtw89: introduce realtek ACPI DSM method
      wifi: rtw89: regd: judge UNII-4 according to BIOS and chip
      wifi: rtw89: support U-NII-4 channels on 5GHz band
      wifi: rtw89: pci: fix interrupt enable mask for HALT C2H of RTL8851B
      wifi: rtw89: ser: L1 add pre-M0 and post-M0 states

 drivers/net/wireless/marvell/mwifiex/11n.h         |    4 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    6 +-
 drivers/net/wireless/marvell/mwifiex/wmm.h         |   15 -
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |    2 -
 drivers/net/wireless/microchip/wilc1000/hif.c      |    8 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |    2 -
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.h |    2 +-
 drivers/net/wireless/microchip/wilc1000/wlan_if.h  |    2 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   37 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |    3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |    2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  463 +++--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    5 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   59 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw89/Makefile        |    3 +-
 drivers/net/wireless/realtek/rtw89/acpi.c          |   52 +
 drivers/net/wireless/realtek/rtw89/acpi.h          |   21 +
 drivers/net/wireless/realtek/rtw89/core.c          |  131 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   76 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   24 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   84 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   76 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  126 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    3 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    7 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   13 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  283 +++-
 drivers/net/wireless/realtek/rtw89/phy.h           |   12 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   49 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |   61 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |  174 ++
 drivers/net/wireless/realtek/rtw89/rtw8851b.h      |   15 +
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  | 1775 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.h  |   18 +
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |   86 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   12 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |    6 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |    6 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   43 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |   19 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |    2 +-
 43 files changed, 3490 insertions(+), 302 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/acpi.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/acpi.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851be.c

