Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830CDFC7B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfD3PKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:10:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfD3PKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:10:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4FCDE60769; Tue, 30 Apr 2019 15:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556637005;
        bh=5i02ENM+LkQVWsU6F8eKfdNUZEvPEdwgC5KJQwd7jeA=;
        h=From:To:Cc:Subject:Date:From;
        b=KvjhZPSZb44AXN3NafmGh2zrbp92qbxSyoEI4HteG4Q7MPUuPzkIOHg1geltGTe/y
         ixhC4K4q8BWFFNR6seO+RgJt2oRfsr+OSusiJ9/CBrAIcFvTD+9TptwO7xtTWKZajB
         JR9eV2SLpr/LRd7T36CnpbxXcXpl8M4jveckdD7I=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 60A9D607DF;
        Tue, 30 Apr 2019 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556637004;
        bh=5i02ENM+LkQVWsU6F8eKfdNUZEvPEdwgC5KJQwd7jeA=;
        h=From:To:Cc:Subject:Date:From;
        b=Lb3wHWzO1WBuryn0cS0jdGu4wVtrb8wkpIVnBQuPgjttXYjofxMFj59BdvRXfj04Z
         OmacREf4ssl99DXIgrN7xvrM8oXX1+wWHSU7oCSgCGKFQ8dz3H8G4ISFTuI3dwjia/
         gO31G1q/uhyWQtExoRPQtYnfA2V5g1ZzC3oF5Kfw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 60A9D607DF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-04-30
Date:   Tue, 30 Apr 2019 18:10:01 +0300
Message-ID: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's one more pull request to net tree for 5.1, more info below.

Also note that this pull conflicts with net-next. And I want to emphasie
that it's really net-next, so when you pull this to net tree it should
go without conflicts. Stephen reported the conflict here:

https://lkml.kernel.org/r/20190429115338.5decb50b@canb.auug.org.au

In iwlwifi oddly commit 154d4899e411 adds the IS_ERR_OR_NULL() in
wireless-drivers but commit c9af7528c331 removes the whole check in
wireless-drivers-next. The fix is easy, just drop the whole check for
mvmvif->dbgfs_dir in iwlwifi/mvm/debugfs-vif.c, it's unneeded anyway.

As usual, please let me know if you have any problems.

Kalle

The following changes since commit 614c70f35cd77a9af8e2ca841dcdb121cec3068f:

  bnx2x: fix spelling mistake "dicline" -> "decline" (2019-04-15 17:23:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-04-30

for you to fetch changes up to 7a0f8ad5ff6323dd8badfeb01d338db146569976:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-04-29 19:33:33 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.1

Third set of fixes for 5.1.

iwlwifi

* fix an oops when creating debugfs entries

* fix bug when trying to capture debugging info while in rfkill

* prevent potential uninitialized memory dumps into debugging logs

* fix some initialization parameters for AX210 devices

* fix an oops with non-MSIX devices

* fix an oops when we receive a packet with bogus lengths

* fix a bug that prevented 5350 devices from working

* fix a small merge damage from the previous series

mwifiex

* fig regression with resume on SDIO

ath10k

* fix locking problem with crashdump

* fix warnings during suspend and resume

----------------------------------------------------------------
Brian Norris (1):
      ath10k: perform crash dump collection in workqueue

Douglas Anderson (1):
      mwifiex: Make resume actually do something useful again on SDIO cards

Emmanuel Grumbach (1):
      iwlwifi: fix driver operation for 5350

Greg Kroah-Hartman (1):
      iwlwifi: mvm: properly check debugfs dentry before using it

Johannes Berg (1):
      iwlwifi: mvm: don't attempt debug collection in rfkill

Kalle Valo (3):
      Merge tag 'iwlwifi-for-kalle-2019-04-19' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2019-04-28' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Luca Coelho (2):
      iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()
      iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register()

Rafael J. Wysocki (1):
      ath10k: Drop WARN_ON()s that always trigger during system resume

Shahar S Matityahu (2):
      iwlwifi: don't panic in error path on non-msix systems
      iwlwifi: dbg_ini: check debug TLV type explicitly

Shaul Triebitz (1):
      iwlwifi: cfg: use family 22560 based_params for AX210 family

 drivers/net/wireless/ath/ath10k/ce.c               |  2 +-
 drivers/net/wireless/ath/ath10k/core.c             |  1 +
 drivers/net/wireless/ath/ath10k/core.h             |  3 +++
 drivers/net/wireless/ath/ath10k/coredump.c         |  6 ++---
 drivers/net/wireless/ath/ath10k/mac.c              |  4 ++--
 drivers/net/wireless/ath/ath10k/pci.c              | 24 +++++++++++++++----
 drivers/net/wireless/ath/ath10k/pci.h              |  2 ++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |  3 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       | 15 +++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  3 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 28 ++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 19 ++++++++++-----
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  2 +-
 17 files changed, 88 insertions(+), 35 deletions(-)
