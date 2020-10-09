Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03309288DC7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389634AbgJIQIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:08:19 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:18623 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389492AbgJIQIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 12:08:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602259698; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=To+Rv0CRRDAUHp+L0TSexKH6+wTf8SVcJjKCiBhmNCQ=; b=wdjYE0tCCNr11GhKCO/1PNIUkb7Qdaz4lLKEHoBBqTbEtnNvbBee9f2UiZySVfp+joRgz4F7
 nB9FhaCEfeDaTUIOoE/bUfeW/2O7wZvrjzuplHR9dyL/j7yKDvif6Tc+xVyordnySipYPaGB
 B9G5RNJAPu1ZnAsrOZy4vqLhdZs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f808adf83370fa1c129e759 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Oct 2020 16:07:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A44E1C433FE; Fri,  9 Oct 2020 16:07:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A398C433C9;
        Fri,  9 Oct 2020 16:07:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A398C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-10-09
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201009160759.A44E1C433FE@smtp.codeaurora.org>
Date:   Fri,  9 Oct 2020 16:07:59 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit c2568c8c9e636a56abf31da4b28b65d3ded02524:

  Merge branch 'net-Constify-struct-genl_small_ops' (2020-10-04 21:13:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-10-09

for you to fetch changes up to b7d96bca1f004b5f26ee51ea9c9749a28dac8316:

  Revert "iwlwifi: remove wide_cmd_header field" (2020-10-09 18:04:50 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.10

Fourth and last set of patches for v5.10. Most of these are iwlwifi
patches, but few small fixes to other drivers as well.

Major changes:

iwlwifi

* PNVM support (platform-specific phy config data)

* bump the FW API support to 59

----------------------------------------------------------------
Alex Dewar (1):
      ath11k: Fix memory leak on error path

Avraham Stern (1):
      iwlwifi: mvm: avoid possible NULL pointer dereference

Chris Chiu (1):
      rtlwifi: rtl8192se: remove duplicated legacy_httxpowerdiff

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't send a CSA command the firmware doesn't know

Golan Ben Ami (1):
      iwlwifi: support an additional Qu subsystem id

Johannes Berg (1):
      iwlwifi: mvm: stop claiming NL80211_EXT_FEATURE_SET_SCAN_DWELL

Lee Jones (14):
      iwlwifi: dvm: Demote non-compliant kernel-doc headers
      iwlwifi: rs: Demote non-compliant kernel-doc headers
      iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
      iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
      iwlwifi: calib: Demote seemingly unintentional kerneldoc header
      iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
      iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
      iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
      iwlwifi: mvm: utils: Fix some doc-rot
      iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
      iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
      iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
      iwlwifi: dvm: devices: Fix function documentation formatting issues
      iwlwifi: iwl-drv: Provide descriptions debugfs dentries

Luca Coelho (13):
      iwlwifi: mvm: read and parse SKU ID if available
      iwlwifi: update prph scratch structure to include PNVM data
      iwlwifi: mvm: ring the doorbell and wait for PNVM load completion
      iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues
      iwlwifi: pcie: fix 0x271B and 0x271C trans cfg struct
      iwlwifi: pcie: fix xtal latency for 9560 devices
      iwlwifi: pcie: fix the xtal latency value for a few qu devices
      iwlwifi: move PNVM implementation to common code
      iwlwifi: add trans op to set PNVM
      iwlwifi: pcie: implement set_pnvm op
      iwlwifi: read and parse PNVM file
      iwlwifi: bump FW API to 59 for AX devices
      Revert "iwlwifi: remove wide_cmd_header field"

Mordechay Goodstein (2):
      iwlwifi: stats: add new api fields for statistics cmd/ntfy
      iwlwifi: rs: align to new TLC config command API

Naftali Goldstein (1):
      iwlwifi: fix sar geo table initialization

Nathan Errera (4):
      iwlwifi: mvm: get number of stations from TLV
      iwlwifi: mvm: prepare roc_done_wk to work sync
      iwlwifi: mvm: add a get lmac id function
      iwlwifi: mvm: support ADD_STA_CMD_API_S ver 12

Sara Sharon (3):
      iwlwifi: mvm: re-enable TX after channel switch
      iwlwifi: mvm: remove memset of kek_kck command
      iwlwifi: mvm: fix suspicious rcu usage warnings

Tom Rix (1):
      mwifiex: fix double free

 drivers/net/wireless/ath/ath11k/mac.c              |   4 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  17 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |  22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  20 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   1 -
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |  16 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  13 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  | 471 ++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       | 274 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |  18 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |  21 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  23 +
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 123 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  54 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 197 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  37 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |  12 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  49 ++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   7 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  27 ++
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  21 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   7 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   5 +
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |   2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 -
 66 files changed, 1434 insertions(+), 314 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
