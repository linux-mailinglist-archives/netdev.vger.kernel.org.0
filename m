Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2CAF0076
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389741AbfKEO6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:58:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388985AbfKEO6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 09:58:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3FF88616AE; Tue,  5 Nov 2019 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572965903;
        bh=h6DNtuoL/EA6gBRllr0SYxlc8xF/JAHJQTUhslf2Rbo=;
        h=From:Subject:To:Cc:Date:From;
        b=Uh7xu7y+VuEn89oPA0P19RQSq5189GykCx6Ppj/hzXNujMMheDw35hQd5le5fIw/C
         9k+Gh3WLsNLjsQQ1+CT/nPxeUCgugUHsJq1ih5rRc4xJ8+FHIIUkwDyBojcFfvL8Qw
         wBIttl3q7BxGUI+VMjP93cFjMgwxQHwHIznBtZH8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47E4561632;
        Tue,  5 Nov 2019 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572965900;
        bh=h6DNtuoL/EA6gBRllr0SYxlc8xF/JAHJQTUhslf2Rbo=;
        h=From:Subject:To:Cc:From;
        b=ijJKZG2kkpEYbmhzOuPJqLqZcSLtDlqLuZN1QrkifpREX2143bd8i6sDOnP0iStdc
         V9Vkg70IaJIaURebatfgCUXal6qFwtSLqWaX+hPPPjUT/4RFjWdYCYrFuHfk80plt/
         FM9J/0ZgziC7ueLyhc4IQmoGqKE/8ysLHGyBc1S0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47E4561632
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2019-11-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191105145823.3FF88616AE@smtp.codeaurora.org>
Date:   Tue,  5 Nov 2019 14:58:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2019-11-05

for you to fetch changes up to 086ddf860650cfa3065d6698fae81335b1846cdb:

  mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops (2019-10-31 10:10:35 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 5.5

First set of patches for 5.5. The most active driver here clearly is
rtw88, lots of patches for it. More quiet on other drivers, smaller
fixes and cleanups all over.

This pull request also has a trivial conflict, the report and example
resolution here:

https://lkml.kernel.org/r/20191031111242.50ab1eca@canb.auug.org.au

Major changes:

rtw88

* add deep power save support

* add mac80211 software tx queue (wake_tx_queue) support

* enable hardware rate control

* add TX-AMSDU support

* add NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 support

* add power tracking support

* add 802.11ac beamformee support

* add set_bitrate_mask support

* add phy_info debugfs to show Tx/Rx physical status

* add RFE type 3 support for 8822b

ath10k

* add support for hardware rfkill on devices where firmware supports it

rtl8xxxu

* add bluetooth co-existence support for single antenna

iwlwifi

* Revamp the debugging infrastructure

----------------------------------------------------------------
Adrian Ratiu (2):
      brcmfmac: don't WARN when there are no requests
      brcmfmac: fix suspend/resume when power is cut off

Allen Pais (1):
      libertas: fix a potential NULL pointer dereference

Anilkumar Kolli (2):
      ath10k: coredump: fix IRAM addr for QCA9984, QCA4019, QCA9888 and QCA99x0
      ath10k: fix backtrace on coredump

Austin Kim (1):
      rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable

Ben Greear (1):
      ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

Bjorn Andersson (4):
      ath10k: Fix HOST capability QMI incompatibility
      ath10k: snoc: skip regulator operations
      ath10k: Use standard regulator bulk API in snoc
      ath10k: Use standard bulk clock API in snoc

Brian Norris (4):
      mwifiex: use 'total_ie_len' in mwifiex_update_bss_desc_with_ie()
      rtw88: use a for loop in rtw_power_mode_change(), not goto
      rtw88: include interrupt.h for tasklet_struct
      rtw88: mark rtw_fw_hdr __packed

Chin-Yen Lee (1):
      rtw88: check firmware leave lps successfully

Chris Chiu (4):
      rtl8xxxu: Improve TX performance of RTL8723BU on rtl8xxxu driver
      rtl8xxxu: add bluetooth co-existence support for single antenna
      rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
      rtl8xxxu: fix warnings for symbol not declared

Christian Lamparter (1):
      ath10k: restore QCA9880-AR1A (v1) detection

Christophe JAILLET (1):
      brcmsmac: remove a useless test

Chuhong Yuan (1):
      ath: Use dev_get_drvdata where possible

Chung-Hsien Hsu (2):
      brcmfmac: send port authorized event for FT-802.1X
      brcmfmac: add support for SAE authentication offload

Colin Ian King (6):
      ath10k: fix spelling mistake "eanble" -> "enable"
      ath: fix various spelling mistakes
      libertas: remove redundant assignment to variable ret
      iwlegacy: make array interval static, makes object smaller
      rtl8xxxu: make arrays static, makes object smaller
      rtw88: remove redundant null pointer check on arrays

Dan Carpenter (2):
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      rtw88: Fix an error message

Denis Efremov (6):
      brcmsmac: remove duplicated if condition
      rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()
      ath9k_hw: fix uninitialized variable data
      ar5523: check NULL before memcpy() in ar5523_cmd()
      wil6210: check len before memcpy() calls
      rsi: fix potential null dereference in rsi_probe()

Emmanuel Grumbach (1):
      iwlwifi: mvm: use the new session protection command

Erik Stromdahl (1):
      ath10k: switch to ieee80211_tx_dequeue_ni

Fuqian Huang (2):
      net/wireless: Use kmemdup rather than duplicating its implementation
      wireless: Remove call to memset after dma_alloc_coherent

Govind Singh (4):
      ath10k: revalidate the msa region coming from firmware
      dt: bindings: ath10k: add dt entry for XO calibration support
      ath10k: Add xo calibration support for wifi rf clock
      ath10k: Enable MSA region dump support for WCN3990

Haim Dreyfuss (1):
      iwlwifi: mvm: add support for new version for D0I3_END_CMD

Hauke Mehrtens (1):
      ath10k: Check if station exists before forwarding tx airtime report

Johan Hovold (2):
      Revert "rsi: fix potential null dereference in rsi_probe()"
      rsi: drop bogus device-id checks from probe

Johannes Berg (1):
      iwlwifi: mvm: remove leftover rs_remove_sta_debugfs() prototype

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2019-10-18-2' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Kangjie Lu (1):
      ath10k: fix missing checks for bmi reads and writes

Larry Finger (4):
      rtlwifi: rtl8192se: Remove unused GET_XXX and SET_XXX
      rtlwifi: rtl8192se: Replace local bit manipulation macros
      rtlwifi: rtl8192se: Convert macros that set descriptor
      rtlwifi: rtl8192se: Convert inline routines to little-endian words

Lior Cohen (1):
      iwlwifi: mvm: add notification for missed VAP

Lorenzo Bianconi (1):
      mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

Markus Elfring (1):
      net/wireless: Delete unnecessary checks before the macro call “dev_kfree_skb”

Masashi Honma (2):
      ath9k_htc: Modify byte order for an error message
      ath9k_htc: Discard undersized packets

Miaoqing Pan (1):
      ath10k: fix latency issue for QCA988x

Mordechay Goodstein (1):
      iwlwifi: mvm: consider ieee80211 station max amsdu value

Nathan Chancellor (1):
      rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Navid Emamdoost (6):
      ath10k: fix memory leak
      rsi: release skb if rsi_prepare_beacon fails
      rtlwifi: prevent memory leak in rtl_usb_probe
      rtl8xxxu: prevent leaking urb
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Ping-Ke Shih (5):
      rtw88: Don't set RX_FLAG_DECRYPTED if packet has no encryption
      rtw88: use struct rtw_fw_hdr to access firmware header
      rtw88: fix NSS of hw_cap
      rtw88: fix error handling when setup efuse info
      rtw88: coex: Set 4 slot mode for A2DP

Rakesh Pillai (1):
      ath10k: Add peer param map for tlv and non-tlv

Saurav Girepunje (4):
      rtlwifi: rtl8192c: Drop condition with no effect
      b43: main: Fix use true/false for bool type
      b43: dma: Fix use true/false for bool type variable
      rtlwifi: rtl8821ae: Drop condition with no effect

Shahar S Matityahu (18):
      iwlwifi: dbg_ini: load external dbg cfg after internal cfg is loaded
      iwlwifi: dbg_ini: use new region TLV in dump flow
      iwlwifi: dbg_ini: use new trigger TLV in dump flow
      iwlwifi: dbg: remove multi buffers infra
      iwlwifi: dbg_ini: add monitor dumping support
      iwlwifi: dbg_ini: add error tables dumping support
      iwlwifi: dbg_ini: use new API in dump info
      iwlwifi: dbg_ini: add TLV allocation new API support
      iwlwifi: dbg_ini: implement time point handling
      iwlwifi: dbg_ini: implement monitor allocation flow
      iwlwifi: dbg_ini: add periodic trigger new API support
      iwlwifi: dbg_ini: support domain changing via debugfs
      iwlwifi: dbg_ini: support FW response/notification region type
      iwlwifi: dbg_ini: rename external debug configuration file
      iwlwifi: dbg_ini: remove old API and some related code
      iwlwifi: dbg_ini: support FW notification dumping in case of missed beacon
      iwlwifi: dbg_ini: add user trigger support
      iwlwifi: dbg_ini: use vzalloc to allocate dumping memory regions

Surabhi Vishnoi (1):
      ath10k: Add support to provide higher range mem chunks in wmi init command

Sven Eckelmann (1):
      ath10k: avoid leaving .bss_info_changed prematurely

Tomislav Požega (5):
      ath10k: use ath10k_pci_soc_ functions for all warm_reset instances
      ath10k: add 2ghz channel arguments to service ready structure
      ath10k: print service ready returned channel range
      ath10k: print supported MCS rates within service ready event
      ath10k: change sw version print format to hex

Tony Lindgren (1):
      wlcore: clean-up clearing of WL1271_FLAG_IRQ_RUNNING

Tova Mussai (4):
      iwlwifi: mvm: create function to convert nl80211 band to phy band
      iwlwifi: mvm: Invert the condition for OFDM rate
      iwlwifi: nvm: create function to convert channel index to nl80211_band
      iwlwifi: rx: use new api to get band from rx mpdu

Tsang-Shian Lin (1):
      rtw88: add phy_info debugfs to show Tx/Rx physical status

Tzu-En Huang (7):
      rtw88: report tx rate to mac80211 stack
      rtw88: config 8822c multicast address in MAC init flow
      rtw88: add NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 support
      rtw88: add power tracking support
      rtw88: Enable 802.11ac beamformee support
      rtw88: add set_bitrate_mask support
      rtw88: fix potential read outside array boundary

Vasyl Gomonovych (1):
      ath10k: Use ARRAY_SIZE

Wen Gong (2):
      ath10k: remove the warning of sdio not full support
      ath10k: add support for hardware rfkill

Wenwen Wang (1):
      ath10k: add cleanup in ath10k_sta_state()

Yadav Lamichhane (1):
      bcma: fix block comment style

Yan-Hsuan Chuang (31):
      rtw88: 8822c: fix boolreturn.cocci warnings
      rtw88: remove redundant flag check helper function
      rtw88: pci: reset H2C queue indexes in a single write
      rtw88: not to enter or leave PS under IRQ
      rtw88: not to control LPS by each vif
      rtw88: remove unused lps state check helper
      rtw88: LPS enter/leave should be protected by lock
      rtw88: leave PS state for dynamic mechanism
      rtw88: add deep power save support
      rtw88: not to enter LPS by coex strategy
      rtw88: select deep PS mode when module is inserted
      rtw88: add deep PS PG mode for 8822c
      rtw88: remove misleading module parameter rtw_fw_support_lps
      rtw88: allows to set RTS in TX descriptor
      rtw88: add driver TX queue support
      rtw88: take over rate control from mac80211
      rtw88: add TX-AMSDU support
      rtw88: flush hardware tx queues
      rtw88: fix beaconing mode rsvd_page memory violation issue
      rtw88: configure TX queue EDCA parameters
      rtw88: raise firmware version debug level
      rtw88: Use rtw_write8_set to set SYS_FUNC
      rtw88: pci: config phy after chip info is setup
      rtw88: use macro to check the current band
      rtw88: fix GENMASK_ULL for u64
      rtw88: fix sparse warnings for DPK
      rtw88: fix sparse warnings for power tracking
      rtw88: 8822b: add RFE type 3 support
      rtw88: use rtw_phy_pg_cfg_pair struct, not arrays
      rtw88: rearrange if..else statements for rx rate indexes
      rtw88: avoid FW info flood

YueHaibing (5):
      ath9k: remove unused including <linux/version.h>
      adm80211: remove set but not used variables 'mem_addr' and 'io_addr'
      atmel: remove set but not used variable 'dev'
      rtl8xxxu: remove set but not used variable 'rate_mask'
      iwlwifi: mvm: fix old-style declaration

zhengbin (15):
      rtlwifi: Remove set but not used variable 'rtstate'
      rtlwifi: Remove set but not used variables 'dataempty','hoffset'
      rtlwifi: rtl8192ee: Remove set but not used variables 'short_gi','buf_len'
      rtlwifi: rtl8192ee: Remove set but not used variables 'reg_ecc','reg_eac'
      rtlwifi: rtl8723be: Remove set but not used variables 'reg_ecc','reg_eac'
      rtlwifi: rtl8821ae: Remove set but not used variables 'rtstatus','bd'
      rtlwifi: rtl8723ae: Remove set but not used variables 'reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
      rtlwifi: rtl8192c: Remove set but not used variables 'reg_ecc','reg_eac'
      rtlwifi: rtl8188ee: Remove set but not used variables 'v3','rtstatus','reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
      rtlwifi: rtl8188ee: Remove set but not used variable 'h2c_parameter'
      rtlwifi: btcoex: Remove set but not used variable 'result'
      rtlwifi: btcoex: Remove set but not used variables 'wifi_busy','bt_info_ext'
      rtlwifi: rtl8723: Remove set but not used variable 'own'
      rtlwifi: rtl8192ee: Remove set but not used variable 'cur_tx_wp'
      rtlwifi: rtl8192ee: Remove set but not used variable 'err'

zhong jiang (1):
      mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops

 .../bindings/net/wireless/qcom,ath10k.txt          |   6 +
 drivers/bcma/driver_chipcommon_pmu.c               |  24 +-
 drivers/net/wireless/admtek/adm8211.c              |   6 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   5 -
 drivers/net/wireless/ath/ath10k/core.c             |  58 +-
 drivers/net/wireless/ath/ath10k/core.h             |   9 +
 drivers/net/wireless/ath/ath10k/coredump.c         |  38 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   1 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   3 +
 drivers/net/wireless/ath/ath10k/hw.h               |   3 +
 drivers/net/wireless/ath/ath10k/mac.c              | 189 +++--
 drivers/net/wireless/ath/ath10k/mac.h              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  62 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |  48 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |  22 +
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   3 -
 drivers/net/wireless/ath/ath10k/snoc.c             | 387 +++------
 drivers/net/wireless/ath/ath10k/snoc.h             |  30 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  82 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  68 ++
 drivers/net/wireless/ath/ath10k/wmi.c              |  49 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |  27 +
 drivers/net/wireless/ath/ath5k/pci.c               |   3 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   6 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  23 +-
 drivers/net/wireless/ath/ath9k/pci.c               |   5 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   6 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   8 +-
 drivers/net/wireless/atmel/atmel_cs.c              |   2 -
 drivers/net/wireless/broadcom/b43/dma.c            |   4 +-
 drivers/net/wireless/broadcom/b43/main.c           |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  53 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  81 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  13 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |   4 +
 .../wireless/broadcom/brcm80211/brcmsmac/channel.c |  10 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |   3 +-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |   2 +
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   8 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |   3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  55 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  25 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   8 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    | 514 +++++-------
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  33 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   5 +
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  80 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 811 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  47 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  35 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  63 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |  12 -
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  58 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  28 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 891 ++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  31 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  20 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 189 ++++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   2 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  77 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 149 ++--
 drivers/net/wireless/marvell/libertas/if_sdio.c    |   5 +
 drivers/net/wireless/marvell/libertas/mesh.c       |   1 -
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   9 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  14 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |   5 +-
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |   2 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   2 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |   2 -
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |   2 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  93 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   9 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 508 +++++++++++-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   9 -
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |   9 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   6 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   6 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |  21 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |   2 -
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/def.h   | 619 ++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |  31 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   | 189 ++---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |  17 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |   8 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   4 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   9 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/net/wireless/realtek/rtw88/Makefile        |   1 +
 drivers/net/wireless/realtek/rtw88/bf.c            | 400 +++++++++
 drivers/net/wireless/realtek/rtw88/bf.h            |  92 +++
 drivers/net/wireless/realtek/rtw88/coex.c          |  38 +-
 drivers/net/wireless/realtek/rtw88/debug.c         | 174 +++-
 drivers/net/wireless/realtek/rtw88/debug.h         |   2 +
 drivers/net/wireless/realtek/rtw88/fw.c            | 227 +++++-
 drivers/net/wireless/realtek/rtw88/fw.h            |  80 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |   6 +
 drivers/net/wireless/realtek/rtw88/mac.c           | 138 +++-
 drivers/net/wireless/realtek/rtw88/mac.h           |   6 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      | 260 +++++-
 drivers/net/wireless/realtek/rtw88/main.c          | 315 ++++++--
 drivers/net/wireless/realtek/rtw88/main.h          | 239 +++++-
 drivers/net/wireless/realtek/rtw88/pci.c           |  81 +-
 drivers/net/wireless/realtek/rtw88/phy.c           | 171 +++-
 drivers/net/wireless/realtek/rtw88/phy.h           |  30 +
 drivers/net/wireless/realtek/rtw88/ps.c            | 188 +++--
 drivers/net/wireless/realtek/rtw88/ps.h            |  16 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   7 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      | 469 ++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |  12 +
 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 829 ++++++++++++++++---
 .../net/wireless/realtek/rtw88/rtw8822b_table.h    |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 376 ++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |  12 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  94 +--
 drivers/net/wireless/realtek/rtw88/rx.c            | 101 ++-
 drivers/net/wireless/realtek/rtw88/rx.h            |  11 +
 drivers/net/wireless/realtek/rtw88/sec.c           |  21 +
 drivers/net/wireless/realtek/rtw88/sec.h           |   1 +
 drivers/net/wireless/realtek/rtw88/tx.c            | 135 +++-
 drivers/net/wireless/realtek/rtw88/tx.h            |   8 +
 drivers/net/wireless/realtek/rtw88/util.c          |  27 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   1 +
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   4 +-
 drivers/net/wireless/st/cw1200/fwio.c              |   6 +-
 drivers/net/wireless/st/cw1200/queue.c             |   3 +-
 drivers/net/wireless/st/cw1200/scan.c              |   3 +-
 drivers/net/wireless/ti/wlcore/main.c              |  15 +-
 162 files changed, 8550 insertions(+), 2529 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/bf.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/bf.h
