Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1AED768F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfJOMbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:31:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfJOMbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 08:31:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A7FD60779; Tue, 15 Oct 2019 12:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571142663;
        bh=TnUctFmJdgiG2TefwmFK0I39R2+MxLcs+91vSZwCffg=;
        h=From:To:Cc:Subject:Date:From;
        b=OppXpEm0hs6r7XYWoHIQcgDNtWF317ZS27liX3lvkdLLkVHm5sNgcwwnDd/HVxE5g
         jKGzumqGXp6GvC+I250D68Y9Jt/jbYlgIU5rNwBX67RlVuEIFIrlrXUpY6J40X5UpE
         Q2V13yPpCrpqNk3Dd+7Lmh+BsI9YELVRPNj3/G0M=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6A7360588;
        Tue, 15 Oct 2019 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571142663;
        bh=TnUctFmJdgiG2TefwmFK0I39R2+MxLcs+91vSZwCffg=;
        h=From:To:Cc:Subject:Date:From;
        b=OppXpEm0hs6r7XYWoHIQcgDNtWF317ZS27liX3lvkdLLkVHm5sNgcwwnDd/HVxE5g
         jKGzumqGXp6GvC+I250D68Y9Jt/jbYlgIU5rNwBX67RlVuEIFIrlrXUpY6J40X5UpE
         Q2V13yPpCrpqNk3Dd+7Lmh+BsI9YELVRPNj3/G0M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6A7360588
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-10-15
Date:   Tue, 15 Oct 2019 15:30:59 +0300
Message-ID: <87eezexkak.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net tree for v5.4, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-10-15

for you to fetch changes up to d79749f7716d9dc32fa2d5075f6ec29aac63c76d:

  ath10k: fix latency issue for QCA988x (2019-10-14 11:43:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.4

Second set of fixes for 5.4. ath10k regression and iwlwifi BAD_COMMAND
bug are the ones getting most reports at the moment.

ath10k

* fix throughput regression on QCA98XX

iwlwifi

* fix initialization of 3168 devices (the infamous BAD_COMMAND bug)

* other smaller fixes

rt2x00

* don't include input-polldev.h header

* fix hw reset to work during first 5 minutes of system run

----------------------------------------------------------------
Dmitry Torokhov (1):
      rt2x00: remove input-polldev.h header

Haim Dreyfuss (1):
      iwlwifi: mvm: force single phy init

Johannes Berg (2):
      iwlwifi: pcie: fix indexing in command dump for new HW
      iwlwifi: pcie: fix rb_allocator workqueue allocation

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2019-10-09' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Luca Coelho (4):
      iwlwifi: don't access trans_cfg via cfg
      iwlwifi: fix ACPI table revision checks
      iwlwifi: exclude GEO SAR support for 3168
      iwlwifi: pcie: change qu with jf devices to use qu configuration

Miaoqing Pan (1):
      ath10k: fix latency issue for QCA988x

Naftali Goldstein (1):
      iwlwifi: mvm: fix race in sync rx queue notification

Navid Emamdoost (2):
      iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
      iwlwifi: pcie: fix memory leaks in iwl_pcie_ctxt_info_gen3_init

Stanislaw Gruszka (1):
      rt2x00: initialize last_reset

 drivers/net/wireless/ath/ath10k/core.c             |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  43 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  36 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 274 ++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  25 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |   2 +-
 11 files changed, 239 insertions(+), 189 deletions(-)
