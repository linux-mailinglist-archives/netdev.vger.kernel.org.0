Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB36594B4
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfF1HSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:18:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfF1HSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:18:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3D50602BD; Fri, 28 Jun 2019 07:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561706331;
        bh=IYO/t3gTfh1bUlPFkiShGeKg3UWdAkbwsUFApHvZh28=;
        h=From:To:Cc:Subject:Date:From;
        b=U0CPk1SG0iVhPH0YjahQcdA2xa6Dat6c18zBBnalFcOCGKXm9GZgm4t+T3hIxpwm8
         Dh6oqKDSgB8yobfPVY1O/3SlwqeD5Dut0S1O/fBZiZpeO1aHICh4T883ZuqpZcf2dl
         sFR+OXsSXBhH7cjEpCWCssJt+hdx539BFZdmC5mk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40ECE602BC;
        Fri, 28 Jun 2019 07:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561706331;
        bh=IYO/t3gTfh1bUlPFkiShGeKg3UWdAkbwsUFApHvZh28=;
        h=From:To:Cc:Subject:Date:From;
        b=U0CPk1SG0iVhPH0YjahQcdA2xa6Dat6c18zBBnalFcOCGKXm9GZgm4t+T3hIxpwm8
         Dh6oqKDSgB8yobfPVY1O/3SlwqeD5Dut0S1O/fBZiZpeO1aHICh4T883ZuqpZcf2dl
         sFR+OXsSXBhH7cjEpCWCssJt+hdx539BFZdmC5mk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40ECE602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-06-28
Date:   Fri, 28 Jun 2019 10:18:48 +0300
Message-ID: <87woh6fa93.fsf@kamboji.qca.qualcomm.com>
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

The following changes since commit c356dc4b540edd6c02b409dd8cf3208ba2804c38:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-06-21 22:23:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-06-28

for you to fetch changes up to 2a92b08b18553c101115423bd34963b1a59a45a3:

  mt76: usb: fix rx A-MSDU support (2019-06-27 19:48:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.2

Hopefully the last set of fixes for 5.2. Nothing special this around,
only small fixes and support for new cards.

iwlwifi

* add new cards for 22000 series and smaller fixes

wl18xx

* fix a clang warning about unused variables

mwifiex

* properly handle small vendor IEs (a regression from the recent
  security fix)

ath

* fix few SPDX tags

mt76

* fix A-MSDU aggregation which got broken in v5.2-rc1

----------------------------------------------------------------
Brian Norris (1):
      mwifiex: Don't abort on small, spec-compliant vendor IEs

Ihab Zhaika (3):
      iwlwifi: add new cards for 22000 and fix struct name
      iwlwifi: add new cards for 22000 and change wrong structs
      iwlwifi: change 0x02F0 fw from qu to quz

Kalle Valo (1):
      ath: fix SPDX tags

Lorenzo Bianconi (1):
      mt76: usb: fix rx A-MSDU support

Nathan Huckleberry (1):
      wl18xx: Fix Wunused-const-variable

Oren Givon (1):
      iwlwifi: add support for hr1 RF ID

 drivers/net/wireless/ath/Kconfig                 |   2 +-
 drivers/net/wireless/ath/Makefile                |   2 +-
 drivers/net/wireless/ath/ar5523/Kconfig          |   2 +-
 drivers/net/wireless/ath/ar5523/Makefile         |   2 +-
 drivers/net/wireless/ath/ath10k/Kconfig          |   2 +-
 drivers/net/wireless/ath/ath5k/Kconfig           |   2 +-
 drivers/net/wireless/ath/ath5k/Makefile          |   2 +-
 drivers/net/wireless/ath/ath6kl/Kconfig          |   2 +-
 drivers/net/wireless/ath/ath6kl/trace.h          |   2 +-
 drivers/net/wireless/ath/ath9k/Kconfig           |   2 +-
 drivers/net/wireless/ath/ath9k/Makefile          |   2 +-
 drivers/net/wireless/ath/wcn36xx/Kconfig         |   2 +-
 drivers/net/wireless/ath/wcn36xx/Makefile        |   2 +-
 drivers/net/wireless/ath/wil6210/Kconfig         |   2 +-
 drivers/net/wireless/ath/wil6210/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c   | 144 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h  |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c    | 241 ++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c  |  17 +-
 drivers/net/wireless/marvell/mwifiex/fw.h        |  12 +-
 drivers/net/wireless/marvell/mwifiex/scan.c      |  18 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |   4 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h        |   1 +
 drivers/net/wireless/mediatek/mt76/usb.c         |  46 ++++-
 drivers/net/wireless/ti/wl18xx/main.c            |  38 ----
 27 files changed, 364 insertions(+), 204 deletions(-)
