Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB14356C01
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244878AbhDGMWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:22:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:32127 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhDGMWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 08:22:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617798150; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=3xrR6pj/LJRG5r8YIa1esRdi1VVbicbs9OqcSxwRLwQ=; b=LqScHeh5M9r1QnR0GWwCiDo/5vO+ERTkQIfgYDvtEKDc7+CVlRXjGNx2gkCBe+ig3P2VoVT9
 og7jVjdkTY98tFV9d42+6EcFRdYUIByRcGOT+gwh8Lylvbx8saKg+ajio42KbxytqLlVAAf8
 /T5K4eilpJzfSR/i6DHB3INnAN4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 606da3ed9a9ff96d95692b99 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 07 Apr 2021 12:22:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E507BC433ED; Wed,  7 Apr 2021 12:22:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD349C433C6;
        Wed,  7 Apr 2021 12:22:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD349C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-04-07
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210407122204.E507BC433ED@smtp.codeaurora.org>
Date:   Wed,  7 Apr 2021 12:22:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 05a59d79793d482f628a31753c671f2e92178a21:

  Merge git://git.kernel.org:/pub/scm/linux/kernel/git/netdev/net (2021-03-09 17:15:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-04-07

for you to fetch changes up to 65db391dd874db42279713405f29f4ac93682d13:

  iwlwifi: mvm: fix beacon protection checks (2021-04-06 13:26:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.12

Third, and last, set of fixes for v5.12. Small fixes, iwlwifi having
most of them. brcmfmac regression caused by cfg80211 changes is the
most important here.

iwlwifi

* fix a lockdep warning

* fix regulatory feature detection in certain firmware versions

* new hardware support

* fix lockdep warning

* mvm: fix beacon protection checks

mt76

* mt7921: fix airtime reporting

brcmfmac

* fix a deadlock regression

----------------------------------------------------------------
Gregory Greenman (1):
      iwlwifi: mvm: rfi: don't lock mvm->mutex when sending config command

Hans de Goede (1):
      brcmfmac: p2p: Fix recently introduced deadlock issue

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Johannes Berg (3):
      iwlwifi: pcie: properly set LTR workarounds on 22000 devices
      iwlwifi: fw: fix notification wait locking
      iwlwifi: mvm: fix beacon protection checks

Lorenzo Bianconi (1):
      mt76: mt7921: fix airtime reporting

Luca Coelho (2):
      iwlwifi: fix 11ax disabled bit in the regulatory capability flags
      iwlwifi: pcie: add support for So-F devices

Matt Chen (1):
      iwlwifi: add support for Qu with AX201 device

 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c | 10 +++----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  7 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |  6 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 17 +++++++----
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 31 +------------------
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 27 ++++++++++++++++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 35 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  7 +++--
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  4 +--
 13 files changed, 97 insertions(+), 55 deletions(-)
