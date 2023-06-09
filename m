Return-Path: <netdev+bounces-9533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F676729A5E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68D701C20B89
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36E013AC7;
	Fri,  9 Jun 2023 12:49:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87B1391
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522BFC433EF;
	Fri,  9 Jun 2023 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686314984;
	bh=UKK4eXQhlbptePTmyXEbijgCDxIOcJHoU/OYEAaXhfE=;
	h=From:To:Cc:Subject:Date:From;
	b=uchJPTtaoLRL932ryz9+jsf98xuSLgfsVAG+zcvg83tty1PHpgP4zZr94lqrnw3jt
	 McsuPQQxvYRSA0NJK6CQtcY/VTAe5QSurdV2TpPa7GXLt5RzfaQisiWUiB5Y1OWyD9
	 BTbwkNTF8ZnQVyNBrImaZ1NwCv+AqbbSxiiStHTpZMRwSpLzGzP55hB6mi7LO5n7nE
	 mswKnKUl3WViwFKL2TlNhklDjspuRCummmP767bsDWJlDneE2NnwbcBvvFjWhLxW40
	 iuNe+jqAaT4sHVLU5VhulvDOxvorclwlUa57f3q4dMC1mZ8dub4dK+WglmApi6/+Vm
	 ii8OJCx55ul9Q==
From: Kalle Valo <kvalo@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2023-06-09
Date: Fri, 09 Jun 2023 15:49:39 +0300
Message-ID: <87bkhohkbg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Note: git request-pull got the diffstat wrong, most likely it got
confused due to our merge from the wireless tree. I fixed it manually by
adding the output from git diff. Everything looks to be ok but I
recommend double checking anyway.

Kalle

The following changes since commit f7e60032c6618dfd643c7210d5cba2789e2de2e2:

  wifi: cfg80211: fix locking in regulatory disconnect (2023-06-06 14:51:32 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-06-09

for you to fetch changes up to fef0f427f71224442698ea4e052315a894d9de69:

  wifi: rtlwifi: remove misused flag from HAL data (2023-06-08 19:03:13 +0300)

----------------------------------------------------------------
wireless-next patches for v6.5

The second pull request for v6.5. We have support for three new
Realtek chipsets, all from different generations. Shows how active
Realtek development is right now, even older generations are being
worked on.

Note: We merged wireless into wireless-next to avoid complex conflicts
between the trees.

Major changes:

rtl8xxxu

* RTL8192FU support

rtw89

* RTL8851BE support

rtw88

* RTL8723DS support

ath11k

* Multiple Basic Service Set Identifier (MBSSID) and Enhanced MBSSID
  Advertisement (EMA) support in AP mode

iwlwifi

* support for segmented PNVM images and power tables

* new vendor entries for PPAG (platform antenna gain) feature

cfg80211/mac80211

* more Multi-Link Operation (MLO) support such as hardware restart

* fixes for a potential work/mutex deadlock and with it beginnings of
  the previously discussed locking simplifications

----------------------------------------------------------------
Abhishek Naik (1):
      wifi: iwlwifi: update response for mcc_update command

Aishwarya R (1):
      wifi: ath12k: increase vdev setup timeout

Alexander Wetzel (1):
      wifi: ath10k: Serialize wake_tx_queue ops

Aloka Dixit (7):
      wifi: ath11k: driver settings for MBSSID and EMA
      wifi: ath11k: MBSSID configuration during vdev create/start
      wifi: ath11k: rename MBSSID fields in wmi_vdev_up_cmd
      wifi: ath11k: MBSSID parameter configuration in AP mode
      wifi: ath11k: refactor vif parameter configurations
      wifi: ath11k: MBSSID beacon support
      wifi: ath11k: EMA beacon support

Alon Giladi (13):
      wifi: iwlwifi: support PPAG in China for older FW cmd version
      wifi: iwlwifi: Add vendors to TAS approved list
      wifi: iwlwifi: Add Dell to ppag approved list
      wifi: iwlwifi: Generalize the parsing of the pnvm image
      wifi: iwlwifi: Separate loading and setting of pnvm image into two functions
      wifi: iwlwifi: Take loading and setting of pnvm image out of parsing part
      wifi: iwlwifi: Allow trans_pcie track more than 1 pnvm DRAM region
      wifi: iwlwifi: Add support for fragmented pnvm images
      wifi: iwlwifi: Implement loading and setting of fragmented pnvm image
      wifi: iwlwifi: Separate loading and setting of power reduce tables
      wifi: iwlwifi: Use iwl_pnvm_image in reduce power tables flow
      wifi: iwlwifi: Enable loading of reduce-power tables into several segments
      wifi: iwlwifi: Separate reading and parsing of reduce power table

Anjaneyulu (1):
      wifi: mac80211: consistently use u64 for BSS changes

Ariel Malamud (1):
      wifi: iwlwifi: fw: Add new ODM vendor to ppag approved list

Arnd Bergmann (2):
      wifi: ath: work around false-positive stringop-overread warning
      wifi: rtw89: use flexible array member in rtw89_btc_btf_tlv

Avraham Stern (3):
      wifi: iwlwifi: mvm: support PASN for MLO
      wifi: iwlwifi: iwlmei: fix compilation error
      wifi: iwlwifi: mvm: FTM initiator MLO support

Benjamin Berg (1):
      wifi: iwlwifi: do not log undefined DRAM buffers unnecessarily

Bitterblue Smith (2):
      wifi: rtl8xxxu: Support new chip RTL8192FU
      wifi: rtl8xxxu: Rename some registers

Carl Huang (3):
      wifi: ath12k: add qmi_cnss_feature_bitmap field to hardware parameters
      wifi: ath12k: set PERST pin no pull request for WCN7850
      wifi: ath12k: send WMI_PEER_REORDER_QUEUE_SETUP_CMDID when ADDBA session starts

Chin-Yen Lee (1):
      wifi: rtw89: add tx_wake notify for 8851B

Christophe JAILLET (8):
      wifi: ath12k: Remove some dead code
      wifi: ath10k: Use list_count_nodes()
      wifi: ath11k: Use list_count_nodes()
      wifi: orinoco: Fix an error handling path in spectrum_cs_probe()
      wifi: orinoco: Fix an error handling path in orinoco_cs_probe()
      wifi: atmel: Fix an error handling path in atmel_probe()
      wifi: wl3501_cs: Fix an error handling path in wl3501_probe()
      wifi: ray_cs: Fix an error handling path in ray_probe()

Colin Ian King (1):
      wifi: rtw89: 8851b: rfk: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE

Dmitry Antipov (3):
      wifi: rtlwifi: remove unused timer and related code
      wifi: rtlwifi: remove unused dualmac control leftovers
      wifi: rtlwifi: remove misused flag from HAL data

Dongliang Mu (2):
      wifi: ray_cs: remove one redundant del_timer
      wifi: ray_cs: add sanity check on local->sram/rmem/amem

Emmanuel Grumbach (3):
      wifi: iwlwifi: mvm: update the FW apis for LINK and MAC commands
      wifi: mac80211: fetch and store the EML capability information
      wifi: mac80211: provide a helper to fetch the medium synchronization delay

Fedor Pchelkin (1):
      wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx

Golan Ben Ami (2):
      wifi: iwlwifi: cfg: freeze 22500 devices FW API
      wifi: iwlwifi: acpi: add other Google OEMs to the ppag approved list

Gregory Greenman (4):
      wifi: iwlwifi: mvm: adjust csa notifications and commands to MLO
      wifi: iwlwifi: disable RX STBC when a device doesn't support it
      wifi: iwlwifi: fw: don't use constant size with efi.get_variable
      wifi: iwlwifi: pnvm: handle memory descriptor tlv

Haim Dreyfuss (2):
      wifi: iwlwifi: don't silently ignore missing suspend or resume ops
      wifi: iwlwifi: mvm: offload BTM response during D3

Ilan Peer (1):
      wifi: mac80211_hwsim: Fix possible NULL dereference

Johannes Berg (40):
      wifi: iwlwifi: mvm: make internal callback structs const
      wifi: iwlwifi: mvm: dissolve iwl_mvm_mac_add_interface_common()
      wifi: iwlwifi: mvm: remove useless code
      wifi: iwlwifi: mvm: support injection rate control
      wifi: iwlwifi: mvm: clarify EHT RU allocation bits
      wifi: iwlwifi: pcie: adjust Bz device timings
      wifi: iwlwifi: mvm: remove warning for beacon filtering error
      wifi: iwlwifi: mvm: send time sync only if needed
      wifi: iwlwifi: mvm: tell firmware about per-STA MFP enablement
      wifi: iwlwifi: api: link context action in kernel-doc
      wifi: iwlwifi: api: use __le16 instead of u16
      wifi: iwlwifi: api: remove unused commands
      wifi: iwlwifi: api: fix kernel-doc links
      wifi: iwlwifi: fw: clean up PNVM loading code
      wifi: mac80211: HW restart for MLO
      wifi: mac80211: remove element scratch_len
      wifi: mac80211_hwsim: avoid warning with MLO PS stations
      wifi: mac80211: skip EHT BSS membership selector
      wifi: mac80211: implement proper AP MLD HW restart
      wifi: mac80211: recalc min chandef for new STA links
      wifi: mac80211: move sta_info_move_state() up
      wifi: mac80211: batch recalc during STA flush
      wifi: mac80211: stop warning after reconfig failures
      Revert "wifi: iwlwifi: mvm: FTM initiator MLO support"
      Revert "wifi: iwlwifi: update response for mcc_update command"
      Merge wireless into wireless-next
      wifi: cfg80211: hold wiphy lock in auto-disconnect
      wifi: cfg80211: hold wiphy lock in pmsr work
      wifi: cfg80211: move wowlan disable under locks
      wifi: cfg80211: wext: hold wiphy lock in siwgenie
      wifi: cfg80211: hold wiphy lock when sending wiphy
      wifi: cfg80211: add a work abstraction with special semantics
      wifi: mac80211: use wiphy work for sdata->work
      wifi: mac80211: unregister netdevs through cfg80211
      wifi: mac80211: use wiphy work for SMPS
      wifi: mac80211: use wiphy work for channel switch
      wifi: mac80211: ibss: move disconnect to wiphy work
      wifi: mac80211: mlme: move disconnects to wiphy work
      wifi: cfg80211: move sched scan stop to wiphy work
      wifi: cfg80211: move scan done work to wiphy work

Juhee Kang (2):
      wifi: rtlwifi: use helper function rtl_get_hdr()
      wifi: brcmutil: use helper function pktq_empty() instead of open code

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthik M (2):
      wifi: ath12k: add wait operation for tx management packets for flush from mac80211
      wifi: ath12k: fix potential wmi_mgmt_tx_queue race condition

Maharaja Kennadyrajan (2):
      wifi: ath11k: Relocate the func ath11k_mac_bitrate_mask_num_ht_rates() and change hweight16 to hweight8
      wifi: ath11k: Send HT fixed rate in WMI peer fixed param

Marek Vasut (2):
      wifi: rsi: Do not configure WoWlan in shutdown hook if not enabled
      wifi: rsi: Do not set MMC_PM_KEEP_POWER in shutdown

Martin Blumenstingl (4):
      wifi: rtw88: sdio: Check the HISR RX_REQUEST bit in rtw_sdio_rx_isr()
      wifi: rtw88: rtw8723d: Implement RTL8723DS (SDIO) efuse parsing
      mmc: sdio: Add/rename SDIO ID of the RTL8723DS SDIO wifi cards
      wifi: rtw88: Add support for the SDIO based RTL8723DS chipset

Matthias Brugger (1):
      wifi: brcmfmac: wcc: Add debug messages

Maxime Bizon (1):
      wifi: ath11k: fix registration of 6Ghz-only phy without the full channel range

Miri Korenblit (1):
      wifi: iwlwifi: mvm: Make iwl_mvm_diversity_iter() MLO aware

Mukesh Sisodiya (4):
      wifi: iwlwifi: remove dead code in iwl_dump_ini_imr_get_size()
      wifi: mac80211: use u64 to hold enum ieee80211_bss_change flags
      wifi: mac80211: refactor ieee80211_select_link_key()
      wifi: mac80211_hwsim: check the return value of nla_put_u32

Neal Sidhwaney (1):
      wifi: brcmfmac: Detect corner error case earlier with log

Niklas Schnelle (1):
      wifi: add HAS_IOPORT dependencies

Peter Seiderer (1):
      wifi: ath9k: fix AR9003 mac hardware hang check register offset calculation

Ping-Ke Shih (21):
      wifi: rtw89: 8851b: add to read efuse version to recognize hardware version B
      wifi: rtw89: 8851b: configure GPIO according to RFE type
      wifi: rtw89: 8851b: add BT coexistence support function
      wifi: rtw89: 8851b: add basic power on function
      wifi: rtw89: 8851b: add set channel function
      wifi: rtw89: 8851b: add to parse efuse content
      wifi: rtw89: 8851b: rfk: add RX DCK
      wifi: rtw89: 8851b: rfk: add DPK
      wifi: rtw89: 8851b: rfk: add TSSI
      wifi: rtw89: 8851b: add TX power related functions
      wifi: rtw89: 8851b: fill BB related capabilities to chip_info
      wifi: rtw89: 8851b: add MAC configurations to chip_info
      wifi: rtw89: 8851b: add RF configurations
      wifi: rtw89: enlarge supported length of read_reg debugfs entry
      wifi: rtw89: 8851b: add 8851be to Makefile and Kconfig
      wifi: rtw89: add chip_ops::query_rxdesc() and rxd_len as helpers to support newer chips
      wifi: rtw89: use struct and le32_get_bits to access RX info
      wifi: rtw89: use struct and le32_get_bits() to access received PHY status IEs
      wifi: rtw89: use struct and le32_get_bits() to access RX descriptor
      wifi: rtw89: use struct to access register-based H2C/C2H
      wifi: rtw89: 8852c: update RF radio A/B parameters to R63

Po-Hao Huang (1):
      wifi: rtw89: 8851b: enable hw_scan support

Sascha Hauer (1):
      wifi: rtw88: usb: silence log flooding error message

Yedidya Benshimol (1):
      wifi: iwlwifi: mvm: use link ID in missed beacon notification

Zong-Zhe Yang (13):
      wifi: rtw89: ser: reset total_sta_assoc and tdls_peer when L2
      wifi: rtw89: tweak H2C TX waiting function for SER
      wifi: rtw89: refine packet offload handling under SER
      wifi: rtw89: debug: txpwr table access only valid page according to chip
      wifi: rtw89: set TX power without precondition during setting channel
      wifi: rtw89: 8851b: configure CRASH_TRIGGER feature for 8851B
      wifi: rtw89: refine clearing supported bands to check 2/5 GHz first
      wifi: rtw89: regd: judge 6 GHz according to chip and BIOS
      wifi: rtw89: regd: update regulatory map to R64-R40
      wifi: rtw89: process regulatory for 6 GHz power type
      wifi: rtw89: 8852c: update TX power tables to R63 with 6 GHz power type (1 of 3)
      wifi: rtw89: 8852c: update TX power tables to R63 with 6 GHz power type (2 of 3)
      wifi: rtw89: 8852c: update TX power tables to R63 with 6 GHz power type (3 of 3)

 drivers/net/wireless/ath/ath10k/core.c             |     3 +
 drivers/net/wireless/ath/ath10k/core.h             |     3 +
 drivers/net/wireless/ath/ath10k/debug.c            |     4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |     6 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    34 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |     2 -
 drivers/net/wireless/ath/ath11k/hw.c               |     3 +
 drivers/net/wireless/ath/ath11k/hw.h               |     1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   419 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |    50 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    48 +-
 drivers/net/wireless/ath/ath12k/core.c             |     1 +
 drivers/net/wireless/ath/ath12k/core.h             |     1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    19 +-
 drivers/net/wireless/ath/ath12k/hw.c               |     6 +
 drivers/net/wireless/ath/ath12k/hw.h               |     2 +
 drivers/net/wireless/ath/ath12k/mac.c              |    49 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |     6 +-
 drivers/net/wireless/ath/ath12k/qmi.h              |     1 +
 drivers/net/wireless/ath/ath12k/wmi.c              |     8 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    27 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |     4 +
 drivers/net/wireless/atmel/Kconfig                 |     2 +-
 drivers/net/wireless/atmel/atmel_cs.c              |    13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |     6 +
 .../broadcom/brcm80211/brcmfmac/wcc/core.c         |     4 +-
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |     4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    20 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    38 +-
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |     6 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    23 +-
 .../net/wireless/intel/iwlwifi/fw/api/context.h    |    13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |     2 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |     6 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |    16 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |    65 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |    24 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    11 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |     3 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |     6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |    10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |     4 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    16 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     5 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   254 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   284 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |    47 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |    32 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |     5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |     7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    10 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    99 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |     5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      |     6 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    96 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   124 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |    27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c   |    10 +-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |     6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |    20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    31 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |     4 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |     2 -
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    50 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    62 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    20 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   279 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |     8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    49 +-
 drivers/net/wireless/intersil/hostap/Kconfig       |     2 +-
 drivers/net/wireless/intersil/orinoco/orinoco_cs.c |    13 +-
 .../net/wireless/intersil/orinoco/spectrum_cs.c    |    13 +-
 drivers/net/wireless/legacy/ray_cs.c               |    31 +-
 drivers/net/wireless/legacy/wl3501_cs.c            |    16 +-
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |     3 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    47 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |    23 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    28 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192f.c |  2090 ++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c |    37 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |     5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   110 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    47 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |    20 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |     1 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |     5 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |     6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |     2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |     8 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    13 -
 drivers/net/wireless/realtek/rtw88/Kconfig         |    11 +
 drivers/net/wireless/realtek/rtw88/Makefile        |     3 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     9 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |     6 +
 drivers/net/wireless/realtek/rtw88/rtw8723ds.c     |    41 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |    24 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |     2 +-
 drivers/net/wireless/realtek/rtw89/Kconfig         |    14 +
 drivers/net/wireless/realtek/rtw89/Makefile        |     9 +
 drivers/net/wireless/realtek/rtw89/coex.c          |     9 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   132 +-
 drivers/net/wireless/realtek/rtw89/core.h          |    57 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    36 +-
 drivers/net/wireless/realtek/rtw89/efuse.c         |    21 +
 drivers/net/wireless/realtek/rtw89/efuse.h         |     1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |    33 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   104 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |    26 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |     2 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |     9 +
 drivers/net/wireless/realtek/rtw89/pci.c           |    12 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |    17 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    62 +
 drivers/net/wireless/realtek/rtw89/regd.c          |   263 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |  2263 ++
 drivers/net/wireless/realtek/rtw89/rtw8851b.h      |    61 +
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |  1776 ++
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.h  |     8 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |     2 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |     2 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |     2 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 28038 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/ser.c           |     5 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |   151 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |     9 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |    18 +-
 include/linux/ieee80211.h                          |    75 +-
 include/linux/mmc/sdio_ids.h                       |     3 +-
 include/net/cfg80211.h                             |    95 +-
 include/net/mac80211.h                             |     5 +
 net/mac80211/cfg.c                                 |    77 +-
 net/mac80211/chan.c                                |     8 +-
 net/mac80211/driver-ops.h                          |    10 +-
 net/mac80211/ht.c                                  |     5 +-
 net/mac80211/ibss.c                                |    38 +-
 net/mac80211/ieee80211_i.h                         |    33 +-
 net/mac80211/iface.c                               |    37 +-
 net/mac80211/main.c                                |     7 +-
 net/mac80211/mesh.c                                |    40 +-
 net/mac80211/mesh.h                                |    19 +-
 net/mac80211/mesh_hwmp.c                           |     6 +-
 net/mac80211/mesh_plink.c                          |    37 +-
 net/mac80211/mesh_ps.c                             |     7 +-
 net/mac80211/mlme.c                                |   136 +-
 net/mac80211/ocb.c                                 |    10 +-
 net/mac80211/rx.c                                  |     2 +-
 net/mac80211/scan.c                                |     2 +-
 net/mac80211/sta_info.c                            |   235 +-
 net/mac80211/status.c                              |     6 +-
 net/mac80211/tdls.c                                |     4 +-
 net/mac80211/tx.c                                  |    30 +-
 net/mac80211/util.c                                |   150 +-
 net/wireless/core.c                                |   158 +-
 net/wireless/core.h                                |    13 +-
 net/wireless/nl80211.c                             |     6 +-
 net/wireless/pmsr.c                                |     4 +-
 net/wireless/scan.c                                |    14 +-
 net/wireless/sme.c                                 |     4 +-
 net/wireless/sysfs.c                               |     8 +-
 net/wireless/wext-sme.c                            |     4 +-
 173 files changed, 33442 insertions(+), 6229 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192f.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723ds.c

