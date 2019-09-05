Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54131AA52A
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731892AbfIEN6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:58:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730739AbfIEN6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:58:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 408FB60850; Thu,  5 Sep 2019 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567691885;
        bh=R3Lq/DrwWReIEcqM4T50mbWX41qAYvrodDgOWCIoxFg=;
        h=From:To:Cc:Subject:Date:From;
        b=jdtOBQvRTNXPcR4PlwfJx1l7uXdEgjBNwpanBu2qTS/0qAxxB5foCpsDIZwZ3xjzO
         ymRmPOjSqGuK0DYtobLlP8cNZpnF7tJikls3g84iL56AU3JvTUu1qUDLMkim/lv2RG
         xWD3ALU1zH2oX10zt0dx12oQGmJFeREBHpwumycE=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD00360592;
        Thu,  5 Sep 2019 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567691884;
        bh=R3Lq/DrwWReIEcqM4T50mbWX41qAYvrodDgOWCIoxFg=;
        h=From:To:Cc:Subject:Date:From;
        b=MQsTBsCDw69fs+yhVcAxXMcwmYM6RR0wsOAXkIXtWprQHgVmxmw/nsnu2wKnRXw36
         5OF+fRLXRqL+/dV3F5ezFg6TUMN43lUHmI0bsIypiwaNXrW2wMqbc4V+yzTC/WccQp
         uUXfTaRfPJuXXjuyxva+haJsNfCMXKrgG3iCBPAs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD00360592
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-09-05
Date:   Thu, 05 Sep 2019 16:58:01 +0300
Message-ID: <87k1amluae.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net tree for v5.3, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 089cf7f6ecb266b6a4164919a2e69bd2f938374a:

  Linux 5.3-rc7 (2019-09-02 09:57:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-09-05

for you to fetch changes up to 8b51dc7291473093c821195c4b6af85fadedbc2f:

  rsi: fix a double free bug in rsi_91x_deinit() (2019-09-03 16:54:48 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.3

Fourth set of fixes for 5.3, and hopefully really the last one. Quite
a few CVE fixes this time but at least to my knowledge none of them
have a known exploit.

mt76

* workaround firmware hang by disabling hardware encryption on MT7630E

* disable 5GHz band for MT7630E as it's not working properly

mwifiex

* fix IE parsing to avoid a heap buffer overflow

iwlwifi

* fix for QuZ device initialisation

rt2x00

* another fix for rekeying

* revert a commit causing degradation in rx signal levels

rsi

* fix a double free

----------------------------------------------------------------
Hui Peng (1):
      rsi: fix a double free bug in rsi_91x_deinit()

Luca Coelho (1):
      iwlwifi: assign directly to iwl_trans->cfg in QuZ detection

Stanislaw Gruszka (4):
      mt76: mt76x0e: don't use hw encryption for MT7630E
      mt76: mt76x0e: disable 5GHz band for MT7630E
      rt2x00: clear up IV's on key removal
      Revert "rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band"

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 24 +++++++-------
 drivers/net/wireless/marvell/mwifiex/ie.c          |  3 ++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |  9 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  5 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    | 15 ++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     | 37 +++++++++++-----------
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  1 -
 7 files changed, 60 insertions(+), 34 deletions(-)
