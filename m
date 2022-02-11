Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682AB4B2208
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiBKJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:33:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348633AbiBKJdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:33:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964621037;
        Fri, 11 Feb 2022 01:33:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49DBDB828C7;
        Fri, 11 Feb 2022 09:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D5EC340ED;
        Fri, 11 Feb 2022 09:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644572023;
        bh=+/5QDUNlAsKho9DimSVX8XCScnCTH4giraesqnlAgxI=;
        h=From:Subject:To:Cc:Date:From;
        b=YaWZJBTSGEb2CwHRzXMkBiBmR/4HAk6hSPfCI3iRvXQ041NGiu54GpDSqAMK7DSTZ
         KKm++PIbTXuzyd2L1uT8r3u9d0XO6/aMOTHdAfluUxkkSB1YRt11TNTq5BKEa+kctJ
         ELriQ+wUf/dOB5r3iui5+fFl86K+YCSo6d63dlyyH+C0mL5ThvVDMrydJcFBpMy72X
         t/cDcSifz+ga/Pd1fMGqza3PfskAlZVnve/iUuJ8VX9t+gUKjk4H4Movx4DhQlRXtl
         lsywcdf8+fodLQk0rPTvaAmw7U0kaKHCePLw/SBw7P7FYSjQWn+W/7h64N1oG64Pgr
         c5agNrTzTsQEw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-02-11
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220211093342.79D5EC340ED@smtp.kernel.org>
Date:   Fri, 11 Feb 2022 09:33:42 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 7674b7b559b683478c3832527c59bceb169e701d:

  net: amd-xgbe: ensure to reset the tx_timer_active flag (2022-01-27 19:15:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-02-11

for you to fetch changes up to bea2662e7818e15d7607d17d57912ac984275d94:

  iwlwifi: fix use-after-free (2022-02-10 10:16:27 +0200)

----------------------------------------------------------------
wireless fixes for v5.17

Second set of fixes for v5.17. This is the first pull request with
both driver and stack patches.

Most important here are a regression fix for brcmfmac USB devices and
an iwlwifi fix for use after free when the firmware was missing. We
have new maintainers for ath9k and wcn36xx as well as ath6kl is now
orphaned. Also smaller fixes to iwlwifi and stack.

----------------------------------------------------------------
Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Emmanuel Grumbach (4):
      iwlwifi: mei: fix the pskb_may_pull check in ipv4
      iwlwifi: mei: retry mapping the shared area
      iwlwifi: mvm: don't feed the hardware RFKILL into iwlmei
      iwlwifi: mei: report RFKILL upon register when needed

JaeMan Park (1):
      mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Jiasheng Jiang (1):
      mac80211: mlme: check for null after calling kmemdup

Johannes Berg (4):
      iwlwifi: pcie: fix locking when "HW not ready"
      iwlwifi: pcie: gen2: fix locking when "HW not ready"
      cfg80211: fix race in netlink owner interface destruction
      iwlwifi: fix use-after-free

Kalle Valo (4):
      MAINTAINERS: mark ath6kl as orphan
      MAINTAINERS: change Loic as wcn36xx maintainer
      MAINTAINERS: hand over ath9k maintainership to Toke
      MAINTAINERS: add DT bindings files for ath10k and ath11k

Luca Coelho (2):
      iwlwifi: remove deprecated broadcast filtering feature
      iwlwifi: mvm: don't send SAR GEO command for 3160 devices

Miri Korenblit (2):
      iwlwifi: mvm: fix condition which checks the version of rate_n_flags
      iwlwifi: fix iwl_legacy_rate_to_fw_idx

Phil Elwell (1):
      brcmfmac: firmware: Fix crash in brcm_alt_fw_path

 MAINTAINERS                                        |  13 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   6 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  13 --
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  11 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |  88 --------
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |  33 +--
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  45 +++-
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 203 -----------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 240 ---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  13 ++
 net/mac80211/mlme.c                                |  29 ++-
 net/wireless/core.c                                |  17 +-
 24 files changed, 116 insertions(+), 637 deletions(-)
