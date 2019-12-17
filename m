Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202DC1231B0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfLQQQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:42 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:21250 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728466AbfLQQQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:16:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576599400; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=6jO2/DBs2drSaSvfMzRwyVGM0ShHDVB4BxydtErh8Hc=; b=ws4wkU1plNuWiMf6LEyH9xp5EVPNKUa6qJRiw8SQ6All0TkZcXhDTljGHsq05gITIUN+R84u
 Sni3zVu9B6GrN3IaWK06n1n+KSzWaKMUfTJALSWfREQ7zFFmw9CCURw5lT+zHfOF883F1Nia
 jIiMoISQ8ZyjIu9duNVK7lOKvZ0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df8ff67.7efb07e70ce0-smtp-out-n01;
 Tue, 17 Dec 2019 16:16:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9AB01C4479D; Tue, 17 Dec 2019 16:16:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A8A65C433CB;
        Tue, 17 Dec 2019 16:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A8A65C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2019-12-17
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191217161638.9AB01C4479D@smtp.codeaurora.org>
Date:   Tue, 17 Dec 2019 16:16:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 6f3aeb1ba05d41320e6cf9a60f698d9c4e44348e:

  hv_netvsc: make recording RSS hash depend on feature flag (2019-11-23 18:42:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2019-12-17

for you to fetch changes up to 0df36b90c47d93295b7e393da2d961b2f3b6cde4:

  iwlwifi: pcie: move power gating workaround earlier in the flow (2019-12-10 10:39:39 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.5

First set of fixes for v5.5. Fixing security issues, some regressions
and few major bugs.

mwifiex

* security fix for handling country Information Elements (CVE-2019-14895)

* security fix for handling TDLS Information Elements

ath9k

* fix endian issue with ath9k_pci_owl_loader

mt76

* fix default mac address handling

iwlwifi

* fix merge damage which lead to firmware crashing during boot on some devices

* fix device initialisation regression on some devices

----------------------------------------------------------------
Anders Kaseorg (1):
      Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ detection"

Christian Lamparter (1):
      ath9k: use iowrite32 over __raw_writel

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Lorenzo Bianconi (1):
      mt76: mt76x0: fix default mac address overwrite

Luca Coelho (1):
      iwlwifi: pcie: move power gating workaround earlier in the flow

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 24 ++++----
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 25 --------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 30 ++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 13 +++-
 drivers/net/wireless/marvell/mwifiex/tdls.c        | 70 ++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  5 +-
 7 files changed, 122 insertions(+), 47 deletions(-)
