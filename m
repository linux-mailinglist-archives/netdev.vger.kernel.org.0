Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEB9193177
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCYT6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:58:00 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:13306 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727328AbgCYT6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:58:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585166279; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=Eda64Po8xAs/zU1+KGY6e+WVIq4HnyJVSaxAH1EYzeE=; b=unfDhAsIxpz6q9JKqznCmQp05smy52eEpaEzrd/QfRCOcqsfIaaXr39UcdS6rDTNXxs1iGHj
 ztloEpY8V6EtRRFFihkvG9wXqvE08Iu9ESRSw/dMNgsRM/3OmTgsT6o9SQ14aMwvFkE1CFTj
 /THx6UriHCYNchq1ATcnKQRQBTw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7bb7c3.7f4e8020d340-smtp-out-n05;
 Wed, 25 Mar 2020 19:57:55 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 92C97C433D2; Wed, 25 Mar 2020 19:57:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8420C433F2;
        Wed, 25 Mar 2020 19:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8420C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-03-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200325195754.92C97C433D2@smtp.codeaurora.org>
Date:   Wed, 25 Mar 2020 19:57:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit e2e57291097b289f84e05fa58ab5e6c6f30cc6e2:

  wlcore: remove stray plus sign (2020-03-12 18:48:14 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-03-25

for you to fetch changes up to 0433ae556ec8fb588a0735ddb09d3eb9806df479:

  iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table (2020-03-23 18:38:03 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.6

Fourth, and last, set of fixes for v5.6. Just two important fixes to
iwlwifi regressions.

iwlwifi

* fix GEO_TX_POWER_LIMIT command on certain devices which caused
  firmware to crash during initialisation

* add back device ids for three devices which were accidentally
  removed

----------------------------------------------------------------
Golan Ben Ami (1):
      iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table

Luca Coelho (1):
      iwlwifi: pcie: add 0x2526/0x401* devices back to cfg detection

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  | 14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  9 ++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  3 +++
 4 files changed, 27 insertions(+), 13 deletions(-)
