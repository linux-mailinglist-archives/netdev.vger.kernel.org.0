Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84402CDDD3
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbgLCSei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:34:38 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:18002 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731764AbgLCSeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:34:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607020458; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=oAKlBd7IimUZGI4W3KTW/dXfsjGBw+XjMlocJlC3viI=; b=pPRO0uACNh01uUVFIwurcp07AqRJqmrV1Fg9VsxEwssw1jc2rNOvoKsblAPEMssoBS/vYVhw
 eitLH55QUcVTTszVySaq4rhNlIVPbMbOx6mkRoK/CwjzCa+eaCF6Srz43KVclH5PTJpi9IxK
 T7v+wAZIUlkqa7TtMS+c85OQFR0=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fc92fa2fc7bcec118e8cfa8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 18:34:10
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE88AC43461; Thu,  3 Dec 2020 18:34:08 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E3C4EC433C6;
        Thu,  3 Dec 2020 18:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E3C4EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-12-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201203183408.EE88AC43461@smtp.codeaurora.org>
Date:   Thu,  3 Dec 2020 18:34:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit fe56d05ee6c87f6a1a8c7267affd92c9438249cc:

  iwlwifi: mvm: fix kernel panic in case of assert during CSA (2020-11-10 20:45:36 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-12-03

for you to fetch changes up to 74a8c816fa8fa7862df870660e9821abb56649fe:

  rtw88: debug: Fix uninitialized memory in debugfs code (2020-12-03 18:00:45 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.10

Second, and most likely final, set of fixes for v5.10. Small fixes and
PCI id addtions.

iwlwifi

* PCI id additions

mt76

* fix a kernel crash during device removal

rtw88

* fix uninitialized memory in debugfs code

----------------------------------------------------------------
Dan Carpenter (1):
      rtw88: debug: Fix uninitialized memory in debugfs code

Golan Ben Ami (1):
      iwlwifi: pcie: add some missing entries for AX210

Johannes Berg (1):
      iwlwifi: update MAINTAINERS entry

Luca Coelho (2):
      iwlwifi: pcie: add one missing entry for AX210
      iwlwifi: pcie: invert values of NO_160 device config entries

Stanislaw Gruszka (1):
      mt76: usb: fix crash on device removal

 MAINTAINERS                                     |  3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  6 ++++++
 drivers/net/wireless/mediatek/mt76/usb.c        | 17 +++++++++--------
 drivers/net/wireless/realtek/rtw88/debug.c      |  2 ++
 5 files changed, 19 insertions(+), 13 deletions(-)
