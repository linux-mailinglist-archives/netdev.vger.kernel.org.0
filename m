Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC681B6DA2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgDXF5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:57:14 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:46692 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgDXF5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:57:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587707833; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=BYWybFeLs0RDp+yRY77K5lQIYAn/o9xP3hvYFCE3Pgc=; b=F8ANsKy2Hep4L40Y7BZPpSq2ohPynv4/MFkQYF/b5BFetI/wd8unTi6G9Y0cLPf5PUcY/EA8
 gZ5efWWyQ540YZFP8AhG28Pmj3Ig6I/2prBWS5lfceqJvou/3R4dwSqm+HPPb2igcgtTe+5x
 P1X10GZI2AqTR7KHJvY0qUA4JbU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea27fb0.7f882596fca8-smtp-out-n03;
 Fri, 24 Apr 2020 05:57:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 805C0C433F2; Fri, 24 Apr 2020 05:57:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E5CEC433CB;
        Fri, 24 Apr 2020 05:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9E5CEC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-04-24
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200424055703.805C0C433F2@smtp.codeaurora.org>
Date:   Fri, 24 Apr 2020 05:57:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 2fcd80144b93ff90836a44f2054b4d82133d3a85:

  Merge tag 'tag-chrome-platform-fixes-for-v5.7-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux (2020-04-16 15:00:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-04-24

for you to fetch changes up to 10e41f34a019b1e4487de2c2941fbc212404c3fe:

  MAINTAINERS: update mt76 reviewers (2020-04-21 15:40:55 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.7

Second set of fixes for v5.7. Quite a few iwlwifi fixes and some
maintainers file updates.

iwlwifi

* fix a bug with kmemdup() error handling

* fix a DMA pool warning about unfreed memory

* fix beacon statistics

* fix a theoritical bug in device initialisation

* fix queue limit handling and inactive TID removal

* disable ACK Enabled Aggregation which was enabled by accident

* fix transmit power setting reading from BIOS with certain versions

----------------------------------------------------------------
Chris Rorvick (1):
      iwlwifi: actually check allocated conf_tlv pointer

Ilan Peer (1):
      iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation

Johannes Berg (4):
      iwlwifi: pcie: actually release queue memory in TVQM
      iwlwifi: pcie: indicate correct RB size to device
      iwlwifi: mvm: limit maximum queue appropriately
      iwlwifi: mvm: fix inactive TID removal return value usage

Luca Coelho (1):
      iwlwifi: fix WGDS check when WRDS is disabled

Mordechay Goodstein (1):
      iwlwifi: mvm: beacon statistics shouldn't go backwards

Nils ANDRÉ-CHANG (1):
      MAINTAINERS: Update URL for wireless drivers

Ryder Lee (1):
      MAINTAINERS: update mt76 reviewers

Sergey Matyukevich (1):
      MAINTAINERS: update list of qtnfmac maintainers

 MAINTAINERS                                        | 44 +++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  9 ++++-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  6 +--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  6 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 25 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 13 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  9 ++++-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 18 +++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  3 ++
 10 files changed, 80 insertions(+), 55 deletions(-)
