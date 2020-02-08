Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70F1563EC
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBHLCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 06:02:22 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:57650 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726995AbgBHLCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 06:02:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581159741; h=Content-Type: MIME-Version: Message-ID: Date:
 Subject: Cc: To: From: Sender;
 bh=QnOjoTFexDpV1/TlXhTolGZnJCKEA2lEK8CFBB3jMxE=; b=E7nVVkzUuPNy/623K6jj7te7jHo30hixpLt0sAuMMrF7Ofsf+nyJHKAwDJY9JfRNs1waru/4
 sysRKt1EpA8K7XoJp2DLenw72ZPgjBuwucofZqBP2kHq3yA15SBLa8vI+O3cMN3WUPwIqjvK
 0lwZUIj0BpWKshL1PGri5R0pjb4=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3e9533.7f2e41d8af48-smtp-out-n03;
 Sat, 08 Feb 2020 11:02:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4B00AC43383; Sat,  8 Feb 2020 11:02:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EA573C433A2;
        Sat,  8 Feb 2020 11:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EA573C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-2020-02-08
Date:   Sat, 08 Feb 2020 13:02:06 +0200
Message-ID: <87sgjlxryp.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree for v5.6, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit c312840cd79061af37158cb42590931cfa364c1b:

  Revert "pktgen: Allow configuration of IPv6 source address range" (2020-01-27 13:49:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-02-08

for you to fetch changes up to d08f3010f4a32eec3c8aa771f03a1b342a1472fa:

  mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap (2020-02-08 11:59:03 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.6

First set of fixes for v5.6. Buffer overflow fixes to mwifiex, quite a
few functionality fixes to iwlwifi and smaller fixes to other drivers.

mwifiex

* fix an unlock from a previous security fix

* fix two buffer overflows

libertas

* fix two bugs from previous security fixes

iwlwifi

* fix module removal with multiple NICs

* don't treat IGTK removal failure as an error

* avoid FW crashes due to DTS measurement races

* fix a potential use after free in FTM code

* prevent a NULL pointer dereference in iwl_mvm_cfg_he_sta()

* fix TDLS discovery

* check all CPUs when trying to detect an error during resume

rtw88

* fix clang warning

mt76

* fix reading of max_nss value from a register

----------------------------------------------------------------
Andrei Otcheretianski (2):
      iwlwifi: mvm: Fix thermal zone registration
      iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()

Avraham Stern (1):
      iwlwifi: mvm: avoid use after free for pmsr request

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Chin-Yen Lee (1):
      rtw88: Fix return value of rtw_wow_check_fw_status

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix TDLS discovery with the new firmware API

Golan Ben Ami (1):
      iwlwifi: mvm: update the DTS measurement type

Lorenzo Bianconi (1):
      mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap

Luca Coelho (1):
      iwlwifi: don't throw error when trying to remove IGTK

Mordechay Goodstein (1):
      iwlwifi: d3: read all FW CPUs error info

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
      libertas: make lbs_ibss_join_existing() return error code on rates overflow

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 52 ++++++++++++----
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      | 10 ++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 71 ++++++++++++++++++----
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        | 10 +--
 drivers/net/wireless/marvell/libertas/cfg.c        |  2 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |  7 +++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c         |  4 ++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |  3 +-
 drivers/net/wireless/realtek/rtw88/wow.c           | 23 ++++---
 14 files changed, 159 insertions(+), 53 deletions(-)
