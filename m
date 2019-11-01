Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE53FEC53E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfKAPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:01:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47912 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbfKAPBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:01:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D76860A96; Fri,  1 Nov 2019 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572620476;
        bh=Qs7if4hclkBg3s6p7V3S3H32XfO7ZKfvxRkH9xWkjM4=;
        h=From:Subject:To:Cc:Date:From;
        b=WRPUIOjF53DlsFsb6G9t6bTY0OtCVuu7Ob5vcmIxkWsBGIBctqPnGQ5cg1zL5Ll/E
         MPTmAFhyCGJVNrsTZHM4IrTpqe0Ry7YsTKHHM8GzoVUukuElLxYtX+D8eIhFNSIjaO
         qel2vt6oUH1JhlcCInYrpVVHyW0Awn48FyKi/ha0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D4106092F;
        Fri,  1 Nov 2019 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572620475;
        bh=Qs7if4hclkBg3s6p7V3S3H32XfO7ZKfvxRkH9xWkjM4=;
        h=From:Subject:To:Cc:From;
        b=kwFbv3YPUq0brwHK7B0II217OGNJjC7DoGzvDHWBHYPUYJ46SJYdMZE3fUw2i+rjj
         Oaprp8LbbVb6oLFrEmwdN+FSzhYJ2Cxsn9ihOvQqduwi4EMBOo6NDI7Es1sySYiKHp
         0lZBzXKgtgbJqhAY1tIgNdn/TfDAUsFSrA9cUgvQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D4106092F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2019-11-01
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191101150116.2D76860A96@smtp.codeaurora.org>
Date:   Fri,  1 Nov 2019 15:01:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit d79749f7716d9dc32fa2d5075f6ec29aac63c76d:

  ath10k: fix latency issue for QCA988x (2019-10-14 11:43:36 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2019-11-01

for you to fetch changes up to 3d206e6899a07fe853f703f7e68f84b48b919129:

  iwlwifi: fw api: support new API for scan config cmd (2019-10-30 17:00:26 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 5.4

Third set of fixes for 5.4. Most of them are for iwlwifi but important
fixes also for rtlwifi and mt76, the overflow fix for rtlwifi being
most important.

iwlwifi

* fix merge damage on earlier patch

* various fixes to device id handling

* fix scan config command handling which caused firmware asserts

rtlwifi

* fix overflow on P2P IE handling

* don't deliver too small frames to mac80211

mt76

* disable PCIE_ASPM

* fix buffer DMA unmap on certain cases

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: fw api: support new API for scan config cmd

Johannes Berg (1):
      iwlwifi: mvm: handle iwl_mvm_tvqm_enable_txq() error return

Larry Finger (1):
      rtlwifi: rtl_pci: Fix problem of too small skb->len

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Lorenzo Bianconi (2):
      mt76: mt76x2e: disable pcie_aspm by default
      mt76: dma: fix buffer unmap with non-linear skbs

Luca Coelho (5):
      iwlwifi: pcie: fix merge damage on making QnJ exclusive
      iwlwifi: pcie: fix PCI ID 0x2720 configs that should be soc
      iwlwifi: pcie: fix all 9460 entries for qnj
      iwlwifi: pcie: add workaround for power gating in integrated 22000
      iwlwifi: pcie: 0x2720 is qu and 0x30DC is not

 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  22 +++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  40 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 140 ++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 131 ++++++++++---------
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  25 ++++
 drivers/net/wireless/mediatek/mt76/Makefile        |   2 +
 drivers/net/wireless/mediatek/mt76/dma.c           |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   2 +
 drivers/net/wireless/mediatek/mt76/pci.c           |  46 +++++++
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   3 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   6 +
 16 files changed, 305 insertions(+), 139 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/pci.c
