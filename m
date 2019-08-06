Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3057D830A4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfHFL22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:28:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53426 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfHFL21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:28:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 990AA60AD1; Tue,  6 Aug 2019 11:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565090906;
        bh=NCToKbuzXkhWhHuK/S79srEeYec4gCngVAfQo4VLI1I=;
        h=From:To:Cc:Subject:Date:From;
        b=ddm8ncEcXJtLm03CcusTGMnEWQyT9yH8ABFVL5Fc+rzFnNB3PMNN/I7G8a9uXWxl8
         lxi8IjrqRHx4RpRYo8qXYiVqbx54y6PKOVVchLryHMyjnbloMglkxyDpG6/R0le52n
         1lChwOX0i83iweCtw+u8a7WcEUMVwK8cwJygX0SE=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0697260A0A;
        Tue,  6 Aug 2019 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565090906;
        bh=NCToKbuzXkhWhHuK/S79srEeYec4gCngVAfQo4VLI1I=;
        h=From:To:Cc:Subject:Date:From;
        b=ddm8ncEcXJtLm03CcusTGMnEWQyT9yH8ABFVL5Fc+rzFnNB3PMNN/I7G8a9uXWxl8
         lxi8IjrqRHx4RpRYo8qXYiVqbx54y6PKOVVchLryHMyjnbloMglkxyDpG6/R0le52n
         1lChwOX0i83iweCtw+u8a7WcEUMVwK8cwJygX0SE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0697260A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-08-06
Date:   Tue, 06 Aug 2019 14:28:22 +0300
Message-ID: <87h86ufs89.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net tree for v5.3, more information below.
Please let me know if there are any problems.

Kalle

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-08-06

for you to fetch changes up to 1f66072503316134873060b24b7895dbbcccf00e:

  iwlwifi: dbg_ini: fix compile time assert build errors (2019-08-01 19:48:00 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.3

Second set of fixes for 5.3. Lots of iwlwifi fixes have accumulated
which consists most of patches in this pull request. Only most notable
iwlwifi fixes are listed below.

mwifiex

* fix a regression related to WPA1 networks since v5.3-rc1

iwlwifi

* fix use-after-free issues

* fix DMA mapping API usage errors

* fix frame drop occurring due to reorder buffer handling in
  RSS in certain conditions

* fix rate scale locking issues

* disable TX A-MSDU on older NICs as it causes problems and was
  never supposed to be supported

* new PCI IDs

* GEO_TX_POWER_LIMIT API issue that many people were hitting

----------------------------------------------------------------
Brian Norris (1):
      mwifiex: fix 802.11n/WPA detection

Colin Ian King (1):
      iwlwifi: mvm: fix comparison of u32 variable with less than zero

Emmanuel Grumbach (8):
      iwlwifi: mvm: prepare the ground for more RSS notifications
      iwlwifi: mvm: add a new RSS sync notification for NSSN sync
      iwlwiif: mvm: refactor iwl_mvm_notify_rx_queue
      iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
      iwlwifi: mvm: fix frame drop from the reordering buffer
      iwlwifi: don't unmap as page memory that was mapped as single
      iwlwifi: mvm: fix an out-of-bound access
      iwlwifi: mvm: fix a use-after-free bug in iwl_mvm_tx_tso_segment

Gregory Greenman (4):
      iwlwifi: mvm: add a wrapper around rs_tx_status to handle locks
      iwlwifi: mvm: send LQ command always ASYNC
      iwlwifi: mvm: replace RS mutex with a spin_lock
      iwlwifi: mvm: fix possible out-of-bounds read when accessing lq_info

Ihab Zhaika (1):
      iwlwifi: add 3 new IDs for the 9000 series (iwl9260_2ac_160_cfg)

Johannes Berg (2):
      iwlwifi: mvm: disable TX-AMSDU on older NICs
      iwlwifi: fix locking in delayed GTK setting

Kalle Valo (1):
      Merge tag 'iwlwifi-fixes-for-kvalo-2019-07-30' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Luca Coelho (2):
      iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41
      iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support

Mauro Rossi (1):
      iwlwifi: dbg_ini: fix compile time assert build errors

Mordechay Goodstein (1):
      iwlwifi: mvm: avoid races in rate init and rate perform

Shahar S Matityahu (2):
      iwlwifi: dbg_ini: move iwl_dbg_tlv_load_bin out of debug override ifdef
      iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h    |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c       |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  58 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 539 ++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 185 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |   2 +
 drivers/net/wireless/marvell/mwifiex/main.h       |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c       |   3 +-
 19 files changed, 538 insertions(+), 353 deletions(-)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
