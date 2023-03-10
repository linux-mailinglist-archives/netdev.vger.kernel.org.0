Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20796B3E92
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjCJMCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCJMCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:02:05 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EE3B9C95;
        Fri, 10 Mar 2023 04:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=JW6mpsY6t2RcRbcj/8ifzBWs4WP38P09E10y7mHzgEU=; t=1678449723; x=1679659323; 
        b=KKrVqDf81RA76xyvkilWmwIWwto77U20FMsjoVsSoBWxsW9RalKBXvjI+av2Vf+tKKTkbAscrs1
        9RhM9bCFdpHFS9u+FtavICx2rV6qb7nk+djIGIohuK0fVCZ+YMXSq8GJFPziT05WyktHqc+Fl4hRO
        PiHzFqVs2nOxNc9hg+sCXQWmcLtW2uE8hzJF+pMFVOS3vKg0V4bjiE4ddeguz6JlAieFEvnUqvUHg
        PanFWGIbkJb7NaFRxC3p5hzqmddnOOFmoVqSdDZQ4DA/DyxoEcKER6Ep+nlyu1H8NSiuwTsYOxC/x
        bveWzUzLsA+YjaPqAXEKIN2qLoyR/JSspX/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pabRi-00H0lf-0R;
        Fri, 10 Mar 2023 13:02:02 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2023-03-10
Date:   Fri, 10 Mar 2023 13:01:58 +0100
Message-Id: <20230310120159.36518-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And for wireless-next, here's a bigger pull request, though
I expect much more iwlwifi work in the near future.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f2b6cfda76d2119871e10fa01ecdc7178401ef22:

  net/mlx5e: Align IPsec ASO result memory to be as required by hardware (2023-02-20 16:52:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-03-10

for you to fetch changes up to da1185449c669076276027c600666286124eef9f:

  wifi: iwlwifi: mvm: fix EOF bit reporting (2023-03-07 22:14:15 +0100)

----------------------------------------------------------------
wireless-next patches for 6.4

Major changes:

cfg80211
 * 6 GHz improvements
 * HW timestamping support
 * support for randomized auth/deauth TA for PASN privacy
   (also for mac80211)

mac80211
 * radiotap TLV and EHT support for the iwlwifi sniffer
 * HW timestamping support
 * per-link debugfs for multi-link

brcmfmac
 * support for Apple (M1 Pro/Max) devices

iwlwifi
 * support for a few new devices
 * EHT sniffer support

rtw88
 * better support for some SDIO devices
   (e.g. MAC address from efuse)

rtw89
 * HW scan support for 8852b
 * better support for 6 GHz scanning

----------------------------------------------------------------
Alon Giladi (1):
      wifi: iwlwifi: mvm: allow Microsoft to use TAS

Avraham Stern (2):
      wifi: nl80211: add a command to enable/disable HW timestamping
      wifi: mac80211: add support for set_hw_timestamp command

Benjamin Berg (3):
      wifi: mac80211: add pointer from bss_conf to vif
      wifi: mac80211: remove SMPS from AP debugfs
      wifi: mac80211: add netdev per-link debugfs data and driver hook

Bitterblue Smith (1):
      wifi: rtl8xxxu: Remove always true condition in rtl8xxxu_print_chipinfo

Chih-Kang Chang (1):
      wifi: rtw89: fix SER L1 might stop entering LPS issue

Chin-Yen Lee (1):
      wifi: rtw89: add tx_wake notify for 8852B

Christophe JAILLET (1):
      wifi: wfx: Remove some dead code

Golan Ben Ami (2):
      wifi: iwlwifi: reduce verbosity of some logging events
      wifi: iwlwifi: Add support for B step of BnJ-Fm4

Hector Martin (13):
      wifi: brcmfmac: acpi: Add support for fetching Apple ACPI properties
      wifi: brcmfmac: pcie: Provide a buffer of random bytes to the device
      wifi: brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
      wifi: brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
      wifi: brcmfmac: cfg80211: Add support for scan params v2
      wifi: brcmfmac: feature: Add support for setting feats based on WLC version
      wifi: brcmfmac: cfg80211: Add support for PMKID_V3 operations
      wifi: brcmfmac: cfg80211: Pass the PMK in binary instead of hex
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4387
      wifi: brcmfmac: common: Add support for downloading TxCap blobs
      wifi: brcmfmac: pcie: Load and provide TxCap blobs
      wifi: brcmfmac: common: Add support for external calibration blobs
      wifi: brcmfmac: pcie: Add BCM4378B3 support

Ilan Peer (3):
      wifi: nl80211: Update the documentation of NL80211_SCAN_FLAG_COLOCATED_6GHZ
      wifi: mac80211_hwsim: Indicate support for NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT
      wifi: iwlwifi: Do not include radiotap EHT user info if not needed

Jacob Keller (1):
      wifi: nl80211: convert cfg80211_scan_request allocation to *_size macros

Jiapeng Chong (2):
      wifi: rtlwifi: rtl8192de: Remove the unused variable bcnfunc_enable
      wifi: rtlwifi: rtl8192se: Remove some unused variables

Johannes Berg (11):
      wifi: mac80211: adjust scan cancel comment/check
      wifi: mac80211: check key taint for beacon protection
      wifi: mac80211: allow beacon protection HW offload
      wifi: cfg80211/mac80211: report link ID on control port RX
      wifi: mac80211: warn only once on AP probe
      wifi: mac80211: mlme: remove pointless sta check
      wifi: mac80211: simplify reasoning about EHT capa handling
      wifi: mac80211: fix ieee80211_link_set_associated() type
      wifi: iwlwifi: mvm: avoid UB shift of snif_queue
      wifi: iwlwifi: mvm: make flush code a bit clearer
      wifi: iwlwifi: mvm: fix EOF bit reporting

John Keeping (1):
      wifi: brcmfmac: support CQM RSSI notification with older firmware

Konrad Dybcio (1):
      wifi: brcmfmac: pcie: Add 4359C0 firmware definition

Lu jicong (1):
      wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values

Martin Blumenstingl (7):
      wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
      wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
      wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
      wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
      wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
      wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
      wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()

Mordechay Goodstein (19):
      wifi: mac80211: clear all bits that relate rtap fields on skb
      wifi: wireless: return primary channel regardless of DUP
      wifi: wireless: correct primary channel validation on 6 GHz
      wifi: wireless: cleanup unused function parameters
      wifi: radiotap: Add EHT radiotap definitions
      wifi: mac80211: add support for driver adding radiotap TLVs
      wifi: iwlwifi: mvm: add LSIG info to radio tap info in EHT
      wifi: iwlwifi: mvm: mark mac header with no data frames
      wifi: radiotap: separate vendor TLV into header/content
      wifi: iwlwifi: mvm: add an helper function radiotap TLVs
      wifi: iwlwifi: mvm: add EHT radiotap info based on rate_n_flags
      wifi: iwlwifi: mvm: add all EHT based on data0 info from HW
      wifi: iwlwifi: mvm: rename define to generic name
      wifi: iwlwifi: mvm: decode USIG_B1_B7 RU to nl80211 RU width
      wifi: iwlwifi: mvm: parse FW frame metadata for EHT sniffer mode
      wifi: iwlwifi: mvm: add primary 80 known for EHT radiotap
      wifi: iwlwifi: rs-fw: break out for unsupported bandwidth
      wifi: iwlwifi: mvm: clean up duplicated defines
      wifi: iwlwifi: mvm: add EHT RU allocation to radiotap

Mukesh Sisodiya (2):
      wifi: iwlwifi: Adding the code to get RF name for MsP device
      wifi: iwlwifi: Update logs for yoyo reset sw changes

Ping-Ke Shih (2):
      wifi: rtl8xxxu: 8188e: parse single one element of RA report for station mode
      wifi: rtw89: 8852b: enable hw_scan support

Po-Hao Huang (3):
      wifi: rtw89: add RNR support for 6 GHz scan
      wifi: rtw89: adjust channel encoding to common function
      wifi: rtw89: 8852b: add channel encoding for hw_scan

Ryder Lee (3):
      wifi: mac80211: introduce ieee80211_refresh_tx_agg_session_timer()
      wifi: mac80211: add EHT MU-MIMO related flags in ieee80211_bss_conf
      wifi: mac80211: add LDPC related flags in ieee80211_bss_conf

Veerendranath Jakkam (1):
      wifi: nl80211: Add support for randomizing TA of auth and deauth frames

Zong-Zhe Yang (2):
      wifi: rtw89: fw: configure CRASH_TRIGGER feature for 8852B
      wifi: rtw89: refine FW feature judgement on packet drop

 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/acpi.c    |  51 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 324 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  25 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 118 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  11 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  49 ++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   6 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 157 +++++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  61 ++-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  12 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |  27 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  84 ++-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 601 ++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   5 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   5 +-
 drivers/net/wireless/mac80211_hwsim.c              |  52 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |  12 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |  25 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   6 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   9 -
 drivers/net/wireless/realtek/rtw88/mac.c           |  17 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   9 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |   6 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   9 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   8 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   9 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   8 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  35 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            | 145 ++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |   7 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   2 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  72 +++
 drivers/net/wireless/realtek/rtw89/phy.h           |   3 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |  12 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  74 +--
 drivers/net/wireless/realtek/rtw89/ser.c           |   5 +
 drivers/net/wireless/silabs/wfx/main.c             |  10 +-
 include/net/cfg80211.h                             |  36 +-
 include/net/ieee80211_radiotap.h                   | 215 +++++++-
 include/net/mac80211.h                             |  92 ++--
 include/uapi/linux/nl80211.h                       |  37 +-
 net/mac80211/agg-tx.c                              |  17 +
 net/mac80211/cfg.c                                 |  46 +-
 net/mac80211/debugfs_netdev.c                      | 223 ++++++--
 net/mac80211/debugfs_netdev.h                      |  16 +
 net/mac80211/driver-ops.c                          |  25 +-
 net/mac80211/driver-ops.h                          |  16 +
 net/mac80211/ieee80211_i.h                         |   4 +
 net/mac80211/link.c                                |   5 +
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/rx.c                                  |  93 ++--
 net/mac80211/scan.c                                |   8 +-
 net/mac80211/tx.c                                  |  10 +
 net/wireless/mlme.c                                |  55 +-
 net/wireless/nl80211.c                             |  78 ++-
 net/wireless/rdev-ops.h                            |  17 +
 net/wireless/scan.c                                |  38 +-
 net/wireless/trace.h                               |  36 +-
 77 files changed, 2645 insertions(+), 643 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c

