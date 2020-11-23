Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421FB2C0FDB
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbgKWQKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:10:52 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:53902 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732780AbgKWQKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 11:10:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606147851; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=fc8laKaoEr7Csjp8CblzuZCLLx1ArM75U7ItDuizqvU=; b=xMltsP45Ou5FrPq9T3pYIBJKAvUWd5Xl8OeKM9pEJZv8DFq0OoUSjNor/qwn9bKuWpkssgPD
 wfnpkgwHbFYH9wJUJCso7w670wy6zufIAXPrezapy1+ILm0HOwhR2ygL1wJ6skSdw5+YgVGc
 k+LGapdXKlfzttKv//lCqrjcvT0=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5fbbdefed64ea0b7030b2a9e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 23 Nov 2020 16:10:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C11D1C43460; Mon, 23 Nov 2020 16:10:37 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB6E0C433C6;
        Mon, 23 Nov 2020 16:10:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB6E0C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-11-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201123161037.C11D1C43460@smtp.codeaurora.org>
Date:   Mon, 23 Nov 2020 16:10:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-11-23

for you to fetch changes up to fe56d05ee6c87f6a1a8c7267affd92c9438249cc:

  iwlwifi: mvm: fix kernel panic in case of assert during CSA (2020-11-10 20:45:36 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.10

First set of fixes for v5.10. One fix for iwlwifi kernel panic, others
less notable.

rtw88

* fix a bogus test found by clang

iwlwifi

* fix long memory reads causing soft lockup warnings

* fix kernel panic during Channel Switch Announcement (CSA)

* other smaller fixes

MAINTAINERS

* email address updates

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: write queue_sync_state only for sync

Chi-Hsien Lin (1):
      MAINTAINERS: update maintainers list for Cypress

Emmanuel Grumbach (2):
      iwlwifi: mvm: use the HOT_SPOT_CMD to cancel an AUX ROC
      iwlwifi: mvm: properly cancel a session protection for P2P

Johannes Berg (2):
      iwlwifi: pcie: limit memory read spin time
      iwlwifi: pcie: set LTR to avoid completion timeout

Mordechay Goodstein (1):
      iwlwifi: sta: set max HE max A-MPDU according to HE capa

Sara Sharon (1):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA

Tom Rix (1):
      rtw88: fix fw_fifo_addr check

Yan-Hsuan Chuang (1):
      MAINTAINERS: update Yan-Hsuan's email address

 MAINTAINERS                                        |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  18 ++++
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 103 ++++++++++++++-------
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  20 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  36 +++++--
 drivers/net/wireless/realtek/rtw88/fw.c            |   2 +-
 10 files changed, 164 insertions(+), 57 deletions(-)
