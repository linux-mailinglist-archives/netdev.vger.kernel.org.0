Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4653D1955F0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 12:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgC0LEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 07:04:23 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:57392 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgC0LEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 07:04:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585307062; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=Zgz+I9cv0vt1kCHzBek7Brb8xia1rfWioa/XR3pNCEY=; b=fhqK/5lEpfC0MxcqHvrsqTGDXqR5uT8dk6i58pkVWXXPUw0FueUwxUa9h9hwhZr5Sw1tdKy0
 DdZuj9w+qlti8RUWo+HUFLUMllg4Nqlxhm2mOX58cGBuuyWVsppItVCL9gMfOKV8NWmmZxdf
 cd3wgsHD6VsEGeqwZOFs4pJx7Ts=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7dddb1.7fba31912b58-smtp-out-n01;
 Fri, 27 Mar 2020 11:04:17 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F051C44791; Fri, 27 Mar 2020 11:04:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21982C43637;
        Fri, 27 Mar 2020 11:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 21982C43637
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-03-27
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200327110416.4F051C44791@smtp.codeaurora.org>
Date:   Fri, 27 Mar 2020 11:04:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit cd556e40fdf3b09e229097021a9148ecb6e7725e:

  devlink: expand the devlink-info documentation (2020-03-24 16:47:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-03-27

for you to fetch changes up to 5988b8ec713270fa29e0535ff3d0ef26a94c8220:

  Merge tag 'iwlwifi-next-for-kalle-2020-03-27' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2020-03-27 09:20:48 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.7

Third set of patches for v5.7. Nothing really special this time,
business as usual.

When pulling this to net-next there's again a conflict in:

drivers/net/wireless/intel/iwlwifi/pcie/drv.c

To solve this drop these three lines from the conflict (the first hunk
from "HEAD") as the whole AX200 block was moved above in the same
file:

	IWL_DEV_INFO(0x2723, 0x1653, iwl_ax200_cfg_cc, iwl_ax200_killer_1650w_name),
	IWL_DEV_INFO(0x2723, 0x1654, iwl_ax200_cfg_cc, iwl_ax200_killer_1650x_name),
	IWL_DEV_INFO(0x2723, IWL_CFG_ANY, iwl_ax200_cfg_cc, iwl_ax200_name),

And keep all the __IWL_DEV_INFO() entries (the second hunk). In other
words, take everything from wireless-drivers-next. When running 'git
diff' after the resolution the output should be empty.

Major changes:

brcmfmac

* add USB autosuspend support

ath11k

* handle RX fragments

* enable PN offload

* add support for HE BSS color

iwlwifi

* support new FW API version

* support for EDCA measurements

* new scan API features

* enable new firmware debugging code

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: add support for non EDCA based measurements

Chris Chiu (2):
      rtl8xxxu: add enumeration for channel bandwidth
      rtl8xxxu: Feed current txrate information for mac80211

Johannes Berg (6):
      iwlwifi: pass trans and NVM data to HE capability parsing
      iwlwifi: mvm: rs-fw: fix some indentation
      iwlwifi: mvm: enable SF also when we have HE
      iwlwifi: remove IWL_FW_DBG_DOMAIN macro
      iwlwifi: pcie: make iwl_pcie_cmdq_reclaim static
      iwlwifi: mvm: remove newline from rs_pretty_print_rate()

John Crispin (3):
      ath11k: set queue_len to 4096
      ath11k: add WMI calls required for handling BSS color
      ath11k: add handling for BSS color

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2020-03-27' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Luca Coelho (15):
      iwlwifi: yoyo: add PCI config space region type
      iwlwifi: pcie: implement read_config32
      iwlwifi: remove redundant iwl9560_2ac_cfg struct
      iwlwifi: move integrated, extra_phy and soc_latency to trans_cfg
      iwlwifi: remove some unused extern declarations from iwl-config.h
      iwlwifi: add HW step to new cfg device table
      iwlwifi: convert all Qu with Jf devices to the new config table
      iwlwifi: convert QnJ with Jf devices to new config table
      iwlwifi: remove unnecessary cfg mangling for Qu C and QuZ with Jf
      iwlwifi: add support for version 2 of SOC_CONFIGURATION_CMD
      iwlwifi: add trans_cfg for devices with long latency
      iwlwifi: remove support for QnJ Hr STEP A
      iwlwifi: remove support for QnJ HR FPGA
      iwlwifi: yoyo: enable yoyo by default
      iwlwifi: bump FW API to 53 for 22000 series

Madhan Mohan R (1):
      brcmfmac: increase max hanger slots from 1K to 3K in fws layer

Manikanta Pubbisetty (3):
      ath11k: handle RX fragments
      ath11k: enable PN offload
      ath11k: dump SRNG stats during FW assert

Pravas Kumar Panda (1):
      ath11k: Adding proper validation before accessing tx_stats

Raveendran Somu (3):
      brcmfmac: Fix driver crash on USB control transfer timeout
      brcmfmac: Fix double freeing in the fmac usb data path
      brcmfmac: fix the incorrect return value in brcmf_inform_single_bss().

Shahar S Matityahu (2):
      iwlwifi: mvm: add soc latency support
      iwlwifi: scan: support scan req cmd ver 14

Sriram R (3):
      ath11k: Supporting RX ring backpressure HTT event and stats handling
      ath11k: Configure hash based reo destination ring selection
      ath11k: Perform per-msdu rx processing

Tova Mussai (1):
      iwlwifi: scan: support FW APIs with variable number of profiles

Tzu-En Huang (1):
      rtw88: fix non-increase management packet sequence number

Venkateswara Naralasetty (1):
      ath11k: fill channel info from rx channel

Wright Feng (1):
      brcmfmac: add USB autosuspend feature support

Yan-Hsuan Chuang (2):
      rtw88: add a debugfs entry to dump coex's info
      rtw88: add a debugfs entry to enable/disable coex mechanism

Yingying Tang (1):
      ath10k: Fill GCMP MIC length for PMF

YueHaibing (1):
      hostap: convert to struct proc_ops

rotem saado (1):
      iwlwifi: yoyo: don't block dumping internal memory when not in SRAM mode

 drivers/net/wireless/ath/ath10k/core.h             |    2 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   12 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   25 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   17 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |    1 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   11 +-
 drivers/net/wireless/ath/ath11k/ce.h               |    1 +
 drivers/net/wireless/ath/ath11k/core.h             |    8 +-
 drivers/net/wireless/ath/ath11k/debug.h            |    2 +
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  |   44 +
 drivers/net/wireless/ath/ath11k/debug_htt_stats.h  |   28 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |    3 +
 drivers/net/wireless/ath/ath11k/dp.c               |   47 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   24 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 1403 ++++++++++++++------
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   12 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    2 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   66 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   23 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   29 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   75 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    1 +
 drivers/net/wireless/ath/ath11k/peer.c             |    3 +
 drivers/net/wireless/ath/ath11k/peer.h             |    9 +
 drivers/net/wireless/ath/ath11k/qmi.c              |    1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  113 ++
 drivers/net/wireless/ath/ath11k/wmi.h              |   43 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |    5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  127 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  300 ++---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   32 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    9 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |    6 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   83 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/soc.h    |   87 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   47 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    2 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    6 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    4 +
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    9 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   46 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  169 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  721 +++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    1 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   10 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |    2 +-
 .../net/wireless/intersil/hostap/hostap_download.c |   10 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   21 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   77 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  492 +++++++
 drivers/net/wireless/realtek/rtw88/coex.h          |   10 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   62 +
 drivers/net/wireless/realtek/rtw88/main.h          |   21 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   30 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   28 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    6 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    6 +
 73 files changed, 3353 insertions(+), 1215 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/soc.h
