Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A735AC542
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 10:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394548AbfIGIBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 04:01:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733174AbfIGIBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 04:01:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE65D6025A; Sat,  7 Sep 2019 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567843281;
        bh=54YB0rlhark8zxAEs9OWXIRStDXWEYc0LxV06KTf/rE=;
        h=From:To:Cc:Subject:Date:From;
        b=nwEzCwbPRJyzStPA4aM/F1V7B+EGhfLzgYz0Phs0nnIyPIltQpwwsK+Ac3IRWu1jr
         i6rg7TLdxIAZtesH8sZSI/S93HNhTtJbRtkO1qaoR+jYrnixftX5IZWeqYG/ymS1X9
         /DbfgcBgsT+G+czzFXii5oQiB9w4fBkAA2a0Fg58=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E9E216025A;
        Sat,  7 Sep 2019 08:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567843280;
        bh=54YB0rlhark8zxAEs9OWXIRStDXWEYc0LxV06KTf/rE=;
        h=From:To:Cc:Subject:Date:From;
        b=BrH8NBT4wVnTGtnvmDe+fdpTLJ8oqX4fNQ2GSgsAwSLEMgeCserud2b8bYLU0a/Ey
         /K6zYaf3hlEFFy/vWj66aamPF2QPjEI1VnAdAK32YxpigeSaSMqUvIGeY9oi1zXZrS
         XIklpi7c0bhDa0S/wsBHbfENnllc+4EVDDCR87EU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E9E216025A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-09-07
Date:   Sat, 07 Sep 2019 11:01:15 +0300
Message-ID: <87blvwlelw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next for v5.4, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 67538eb5c00f08d7fe27f1bb703098b17302bdc0:

  Merge branch 'mvpp2-per-cpu-buffers' (2019-09-02 12:07:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-09-07

for you to fetch changes up to 67e974c3ae21c8ced474eae3ce9261a6f827e95c:

  Merge tag 'iwlwifi-next-for-kalle-2019-09-06' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-09-07 10:21:07 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.4

Second set of patches for 5.4. Lots of changes for iwlwifi and mt76,
but also smaller changes to other drivers.

Major changes:

iwlwifi

* remove broken and unused runtime power management mode for PCIe
  devices, removes IWLWIFI_PCIE_RTPM Kconfig option as well

* support new ACPI value for per-platform antenna gain

* support for single antenna diversity

* support for new WoWLAN FW API

brcmfmac

* add reset debugfs file for testing firmware restart

mt76

* DFS pattern detector for mt7615 (DFS channels not enabled yet)

* Channel Switch Announcement (CSA) support for mt7615

* new device support for mt76x0

* support for more ciphers in mt7615

* smart carrier sense on mt7615

* survey support on mt7615

* multiple interfaces on mt76x02u

rtw88

* enable MSI interrupt

----------------------------------------------------------------
Alex Malamud (2):
      iwlwifi: LTR updates
      iwlwifi: Set w-pointer upon resume according to SN

Andy Shevchenko (3):
      hostap: use %*ph to print small buffer
      brcmfmac: use %*ph to print small buffer
      zd1211rw: use %*ph to print small buffer

Ayala Beker (2):
      iwlwifi: scan: add support for new scan request command version
      iwlwifi: scan: don't pass large argument by value

Beker Ayala (1):
      iwlwifi: mvm: fix scan config command size

Christoph Hellwig (1):
      iwlwifi: stop passing bogus gfp flags arguments to dma_alloc_coherent

Colin Ian King (4):
      rtw88: remove redundant assignment to pointer debugfs_topdir
      brcmfmac: remove redundant assignment to pointer hash
      ipw2x00: fix spelling mistake "initializationg" -> "initialization"
      bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA

Dan Carpenter (1):
      rtw88: Fix an error message

Emmanuel Grumbach (20):
      iwlwifi: mvm: remove redundant condition in iwl_mvm_set_hw_rfkill_sta=
te
      iwlwifi: mvm: start to remove the code for d0i3
      iwlwifi: remove all the d0i3 references
      iwlwifi: mvm: remove the tx defer for d0i3
      iwlwifi: mvm: remove the d0i3 entry/exit flow
      iwlwifi: mvm: iwl_mvm_wowlan_config_key_params is for wowlan only
      iwlwifi: mvm: remove d0i3_ap_sta_id
      iwlwifi: mvm: remove iwl_mvm_update_d0i3_power_mode
      iwlwifi: mvm: remove last leftovers of d0i3
      iwlwifi: remove CMD_HIGH_PRIO
      iwlwifi: trans: remove suspending flag
      iwlwifi: remove the code under IWLWIFI_PCIE_RTPM
      iwlwifi: remove runtime_pm_mode
      iwlwifi: remove the opmode's d0i3 handlers
      iwlwifi: pcie: remove the refs / unrefs from the transport
      iwlwifi: pcie: remove some more d0i3 code from the transport
      iwlwifi: remove the d0i3 related module parameters
      iwlwifi: remove pm_runtime completely
      iwlwifi: mvm: simplify the channel switch flow for newer firmware
      iwlwifi: mvm: don't log un-decrypted frames

Felix Fietkau (16):
      mt76: round up length on mt76_wr_copy
      mt76: mt7615: clean up FWDL TXQ during/after firmware upload
      mt76: mt7603: enable hardware rate up/down selection
      mt76: mt7615: move mt7615_mcu_set_rates to mac.c
      mt76: mt7615: reset rate index/counters on rate table update
      mt76: mt7615: sync with mt7603 rate control changes
      mt76: mt7615: fix using VHT STBC rates
      mt76: mt7615: fix PS buffering of action frames
      mt76: mt7615: fix invalid fallback rates
      mt76: mt7603: fix invalid fallback rates
      mt76: mt7615: add missing register initialization
      mt76: mt7615: apply calibration-free data from OTP
      mt76: dma: reset q->rx_head on rx reset
      mt76: stop rx aggregation on station removal
      mt76: do not send BAR frame on tx aggregation flush stop
      mt76: remove offchannel check in tx scheduling

Gil Adam (1):
      iwlwifi: support per-platform antenna gain

Guenter Roeck (1):
      rtw88: drop unused rtw_coex_coex_dm_reset()

Gustavo A. R. Silva (1):
      zd1211rw: zd_usb: Use struct_size() helper

Haim Dreyfuss (4):
      iwlwifi: remove unused regdb_ptrs allocation
      iwlwifi: add support for suspend-resume flow for new device generation
      iwlwifi: add sta_id to WOWLAN_CONFIG_CMD
      iwlwifi: mvm: add support for single antenna diversity

Hariprasad Kelam (1):
      iwlwifi: fix warning iwl-trans.h is included more than once

Ilan Peer (1):
      iwlwifi: mvm: Block 26-tone RU OFDMA transmissions

Ilia Lin (1):
      iwlwifi: Send DQA enable command only if TVL is on

Jia-Ju Bai (1):
      brcm80211: Avoid possible null-pointer dereferences in wlc_phy_radio_=
init_2056()

Jian-Hong Pan (1):
      rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ

Johannes Berg (5):
      iwlwifi: mvm: remove unnecessary forward declarations
      iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL
      iwlwifi: api: fix FTM struct documentation
      iwlwifi: mvm: drop BA sessions on too many old-SN frames
      iwlwifi: mvm: handle BAR_FRAME_RELEASE (0xc2) notification

Kalle Valo (2):
      Merge tag 'mt76-for-kvalo-2019-09-05' of https://github.com/nbd168/wi=
reless
      Merge tag 'iwlwifi-next-for-kalle-2019-09-06' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Larry Finger (14):
      rtlwifi: rtl8192cu: Fix value set in descriptor
      rtlwifi: rtl_pci: Fix memory leak when hardware init fails
      rtlwifi: rtl8192ee: Remove unused GET_XXX and SET_XXX
      rtlwifi: rtl8192ee: Replace local bit manipulation macros
      rtlwifi: rtl8192ee: Convert macros that set descriptor
      rtlwifi: rtl8192ee: Convert inline routines to little-endian words
      rtlwifi: rtl8192ee: Remove some variable initializations
      rtlwifi: rtl8192cu: Remove unused GET_XXX and SET_XXX
      rtlwifi: rtl8192cu: Replace local bit manipulation macros
      rtlwifi: rtl8192cu: Convert macros that set descriptor
      rtlwifi: rtl8192cu: Convert inline routines to little-endian words
      rtlwifi: rtl8821ae: Fix incorrect returned values
      rtlwifi: rtl8188ee: Fix incorrect returned values
      rtlwifi: rtl8192ce: Fix incorrect returned values

Lorenzo Bianconi (33):
      mt76: mt7615: fix sparse warnings: warning: restricted __le16 degrade=
s to integer
      mt76: mt7615: introduce mt7615_regd_notifier
      mt76: mt7615: add hw dfs pattern detector support
      mt76: mt7615: do not perform txcalibration before cac is complited
      mt76: mt7615: add csa support
      mt76: mt7615: add radar pattern test knob to debugfs
      mt76: mt7615: fall back to sw encryption for unsupported ciphers
      mt76: mt7615: always release sem in mt7615_load_patch
      mt76: mt7615: introduce mt7615_mcu_send_ram_firmware routine
      mt76: mt76u: fix typo in mt76u_fill_rx_sg
      mt76: mt76x0u: add support to TP-Link T2UHP
      mt76: mt7615: move mt7615_mac_get_key_info in mac.c
      mt76: mt7615: add mt7615_mac_wtbl_addr routine
      mt76: mt7615: introduce mt7615_mac_wtbl_set_key routine
      mt76: mt7615: remove wtbl_sec_key definition
      mt76: mt7615: add set_key_cmd and mt76_wcid to mt7615_mac_wtbl_set_ke=
y signature
      mt76: introduce mt76_mmio_read_copy routine
      mt76: mt7615: fix MT7615_WATCHDOG_TIME definition
      mt76: mt7603: fix watchdog rescheduling in mt7603_set_channel
      mt76: mt7615: rework locking scheme for mt7615_set_channel
      mt76: mt7615: add Smart Carrier Sense support
      mt76: mt76x02: introduce mt76x02_pre_tbtt_enable and mt76x02_beacon_e=
nable macros
      mt76: mt76x02: do not copy beacon skb in mt76x02_mac_set_beacon_enable
      mt76: mt76x02u: enable multi-vif support
      mt76: mt76x02u: enable survey support
      mt76: mt7603: move survey_time in mt76_dev
      mt76: mt7615: enable survey support
      mt76: move mt76_tx_tasklet in mt76 module
      mt76: mt7603: remove unnecessary mcu queue initialization
      mt76: mt7615: add BIP_CMAC_128 cipher support
      mt76: add default implementation for mt76_sw_scan/mt76_sw_scan_comple=
te
      mt76: mt7615: introduce mt7615_txwi_to_txp utility routine
      mt76: mt7615: add support to read temperature from mcu

Luca Coelho (12):
      iwlwifi: bump FW API to 49 for 22000 series
      iwlwifi: mvm: remove check for lq_sta in __iwl_mvm_rs_tx_status()
      iwlwifi: bump FW API to 50 for 22000 series
      iwlwifi: remove duplicate FW string definitions
      iwlwifi: remove unnecessary IWL_DEVICE_AX200_COMMON definition
      iwlwifi: separate elements from cfg that are needed by trans_alloc
      iwlwifi: pcie: use the cfg we passed to iwl_trans_pcie_alloc()
      iwlwifi: pcie: move some cfg mangling from trans_pcie_alloc to probe
      iwlwifi: pcie: set iwl_trans->cfg later in the probe function
      iwlwifi: pass the iwl_config_trans_params when needed
      iwlwifi: add a pointer to the trans_cfg directly in trans
      iwlwifi: always access the trans configuration via trans

Mordechay Goodstein (1):
      iwlwifi: mvm: name magic numbers with enum

Oliver Neukum (1):
      zd1211rw: remove false assertion from zd_mac_clear()

Rafa=C5=82 Mi=C5=82ecki (3):
      brcmfmac: get chip's default RAM info during PCIe setup
      brcmfmac: add stub version of brcmf_debugfs_get_devdir()
      brcmfmac: add "reset" debugfs entry for testing reset

Ryder Lee (8):
      mt76: mt7615: add 4 WMM sets support
      mt76: mt7615: update cw_min/max related settings
      mt76: Add paragraphs to describe the config symbols fully
      mt76: mt7603: fix some checkpatch warnings
      mt76: mt7615: fix some checkpatch warnings
      mt76: mt76x02: fix some checkpatch warnings
      mt76: switch to SPDX tag instead of verbose boilerplate text
      mt76: fix some checkpatch warnings

Shahar S Matityahu (24):
      iwlwifi: dbg: move monitor recording functionality from header file
      iwlwifi: dbg: move debug recording stop from trans to op mode
      iwlwifi: dbg: support debug recording suspend resume command
      iwlwifi: add ldbg config cmd debug print
      iwlwifi: dbg_ini: align dbg tlv functions names to a single format
      iwlwifi: dbg: add debug periphery registers to 9000 device family
      iwlwifi: dbg_ini: maintain buffer allocations from trans instead of T=
LVs buffer
      iwlwifi: dbg_ini: use linked list to store debug TLVs
      iwlwifi: dbg_ini: remove periphery phy and aux regions handling
      iwlwifi: dbg_ini: use function to check if ini dbg mode is on
      iwlwifi: dbg_ini: verify debug TLVs at allocation phase
      iwlwifi: dbg_ini: remove debug flow TLV
      iwlwifi: dbg: align wrt log prints to the same format
      iwlwifi: dbg_ini: separate cfg and dump flows to different modules
      iwlwifi: dbg_ini: use linked list for dump TLVs during dump creation
      iwlwifi: dbg_ini: move tx fifo data into fw runtime
      iwlwifi: dbg_ini: make a single ops struct for paging collect
      iwlwifi: dbg_ini: use regions ops array instead of switch case in dum=
p flow
      iwlwifi: add iwl_tlv_array_len()
      iwlwifi: dbg_ini: remove apply point, switch to time point API
      iwlwifi: fw api: add DRAM buffer allocation command
      iwlwifi: dbg_ini: fix dump structs doc
      iwlwifi: dbg_ini: remove periodic trigger
      iwlwifi: dbg: remove iwl_fw_cancel_dumps function

Shaul Triebitz (2):
      iwlwifi: mvm: add the skb length to a print
      iwlwifi: pass the iwl_trans instead of cfg to some functions

Stanislaw Gruszka (9):
      rt2x00: do not set IEEE80211_TX_STAT_AMPDU_NO_BACK on tx status
      mt76: usb: fix endian in mt76u_copy
      mt76: usb: remove unneeded {put,get}_unaligned
      mt76: mt76x02: use params->ssn value directly
      mt76: mt7603: use params->ssn value directly
      mt76: mt7615: use params->ssn value directly
      mt76: make mt76_rx_convert static
      mt76: mt76x0: remove redundant chandef copy
      mt76: mt76x0: remove unneeded return value on set channel

Tova Mussai (2):
      iwlwifi: allocate bigger nvm data in case of UHB
      iwlwifi: mvm: look for the first supported channel when add/remove ph=
y ctxt

Valdis Kletnieks (1):
      rtlwifi: fix non-kerneldoc comment in usb.c

Wei Yongjun (2):
      rtw88: fix seq_file memory leak
      rtlwifi: Fix file release memory leak

Wenwen Wang (1):
      airo: fix memory leaks

Xulin Sun (1):
      brcmfmac: replace strncpy() by strscpy()

Yu-Yen Ting (1):
      rtw88: pci: enable MSI interrupt

YueHaibing (3):
      rtlwifi: remove unused variables 'RTL8712_SDIO_EFUSE_TABLE' and 'MAX_=
PGPKT_SIZE'
      bcma: remove two unused variables
      mt76: mt7603: use devm_platform_ioremap_resource() to simplify code

zhong jiang (1):
      hostap: remove set but not used variable 'copied' in prism2_io_debug_=
proc_read

 drivers/bcma/driver_mips.c                         |   16 -
 drivers/bcma/driver_pci.c                          |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   25 +
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |    4 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    1 -
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    6 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |    2 +-
 drivers/net/wireless/cisco/airo.c                  |   11 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   14 -
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |   14 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |   26 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   46 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |   18 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |   44 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |    5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   12 +
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    7 +
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    6 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  102 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   83 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |    4 +
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |    7 +
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   12 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   18 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   32 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   55 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 1155 +++++++---------=
----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  121 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   38 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   29 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    9 -
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    2 -
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   23 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   51 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  236 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   36 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h  |    1 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   30 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   21 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |    4 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |    6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   21 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   60 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |   27 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   16 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  150 +--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  224 +---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  154 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  183 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  424 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  150 +--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  480 +-------
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   82 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  115 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   98 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    9 -
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   19 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  326 ++----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   38 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   77 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  380 +++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   52 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  176 ++-
 .../net/wireless/intersil/hostap/hostap_download.c |    6 +-
 drivers/net/wireless/intersil/hostap/hostap_plx.c  |    3 +-
 drivers/net/wireless/intersil/hostap/hostap_proc.c |    3 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   36 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   13 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   21 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   13 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   13 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   78 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   13 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |   28 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   43 +-
 drivers/net/wireless/mediatek/mt76/mt7603/Kconfig  |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    1 -
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    3 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   91 ++
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   38 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   80 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  733 ++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   28 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  111 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  474 ++++----
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   75 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig  |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   15 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   49 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   28 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   45 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |   83 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h   |   13 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c    |   13 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   29 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   26 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   24 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   41 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_trace.c |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_trace.h |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |   13 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   13 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   75 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig  |   14 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   23 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h    |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2/mt76x2u.h    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   14 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   15 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |   17 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   14 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   20 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   24 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mcu.c    |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/trace.c         |   13 +-
 drivers/net/wireless/mediatek/mt76/trace.h         |   22 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   44 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   60 +-
 drivers/net/wireless/mediatek/mt76/usb_trace.c     |   13 +-
 drivers/net/wireless/mediatek/mt76/usb_trace.h     |   24 +-
 drivers/net/wireless/mediatek/mt76/util.c          |   13 +-
 drivers/net/wireless/mediatek/mt76/util.h          |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |    3 -
 drivers/net/wireless/realtek/rtlwifi/debug.c       |    2 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   17 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    2 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   14 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.h   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |  272 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   |  529 ++++-----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  314 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   |  861 +++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   10 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   16 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    7 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    4 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   70 +-
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c      |    3 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |    1 -
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   11 +-
 216 files changed, 5206 insertions(+), 6244 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
