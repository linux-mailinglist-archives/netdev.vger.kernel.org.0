Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D52386EA
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfFGJTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 05:19:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFGJTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 05:19:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D2FD604D4; Fri,  7 Jun 2019 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559899163;
        bh=QBctI2mFEIpsc8FTsUaIRFrqjYlpJxAxchd4c9ax/dE=;
        h=From:To:Cc:Subject:Date:From;
        b=oEXWsRdKMlTHmy6l7fRe0TrEVyWZfPAu/B0b7F7GN9ztSFkvShlFNzD5KigjneoUo
         rKmlR/9cOYNLUZVC/OToCYAIQnR6JBWvBFHo1ESyNLEHZymlRuQnK/oxAuSlVWyRHS
         qvDKuxFgXXjJT76Xm/eAxjpAD2hpPeYoX0NEt16A=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0164604D4;
        Fri,  7 Jun 2019 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559899162;
        bh=QBctI2mFEIpsc8FTsUaIRFrqjYlpJxAxchd4c9ax/dE=;
        h=From:To:Cc:Subject:Date:From;
        b=FPEoA2/lj7X/5VOGLMHR2ofVFWYrye9B+X1UgV8+4Ff2Zodf48AVMcJX5KaE5OBVJ
         j7y3zLeFBwpZPJGDP750bWuukn2digyrtJYlKNkkQaWcYuODpeKmLCijsdEyGOTjGw
         LdekWcorY4prsayp50UKqQU9PrEJPLP/2ftMLlDg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0164604D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-06-07
Date:   Fri, 07 Jun 2019 12:19:19 +0300
Message-ID: <87a7etsqg8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net tree for 5.2, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 3e66b7cc50ef921121babc91487e1fb98af1ba6e:

  net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE() (2019-05-26 21:50:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-06-07

for you to fetch changes up to 69ae4f6aac1578575126319d3f55550e7e440449:

  mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies() (2019-06-01 08:06:24 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.2

First set of fixes for 5.2. Most important here are buffer overflow
fixes for mwifiex.

rtw88

* fix out of bounds compiler warning

* fix rssi handling to get 4x more throughput

* avoid circular locking

rsi

* fix unitilised data warning, these are hopefully the last ones so
  that the warning can be enabled by default

mwifiex

* fix buffer overflows

iwlwifi

* remove not used debugfs file

* various fixes

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: fix load in rfkill flow for unified firmware

Jia-Ju Bai (1):
      iwlwifi: Fix double-free problems in iwl_req_fw_callback()

Johannes Berg (1):
      iwlwifi: mvm: remove d3_sram debugfs file

Lior Cohen (1):
      iwlwifi: mvm: change TLC config cmd sent by rs to be async

Matt Chen (1):
      iwlwifi: fix AX201 killer sku loading firmware issue

Nathan Chancellor (1):
      rsi: Properly initialize data in rsi_sdio_ta_reset

Shahar S Matityahu (2):
      iwlwifi: clear persistence bit according to device family
      iwlwifi: print fseq info upon fw assert

Stanislaw Gruszka (2):
      rtw88: fix subscript above array bounds compiler warning
      rtw88: avoid circular locking between local->iflist_mtx and rtwdev->mutex

Takashi Iwai (3):
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Abort at too short BSS descriptor element
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()

Yan-Hsuan Chuang (1):
      rtw88: fix unassigned rssi_level in rtw_sta_info

YueHaibing (1):
      rtw88: Make some symbols static

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 39 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      | 22 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 22 ---------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 57 ----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 23 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 20 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 53 ++++++++++++++------
 drivers/net/wireless/marvell/mwifiex/ie.c          | 47 ++++++++++++------
 drivers/net/wireless/marvell/mwifiex/scan.c        | 19 ++++++++
 drivers/net/wireless/realtek/rtw88/fw.c            |  6 ++-
 drivers/net/wireless/realtek/rtw88/main.c          |  3 +-
 drivers/net/wireless/realtek/rtw88/phy.c           | 22 ++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c            | 21 +++++---
 20 files changed, 220 insertions(+), 150 deletions(-)
