Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3817A6A1
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgCENqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:46:25 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:46764 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgCENqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:46:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583415984; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=6M8jWC6mGhWG7UiUmW7fOkC2U1o9pzyFGE7QTMdPJhE=; b=tYlpKYV6MIEF4WMlDkDnaKpXo/FttbuER4phzNPcTES/BKgmcu0+eue6LTxqDjjDJF7K2Hi5
 z4kbo/b0Q6RvxqsVBUXUdNXF1EQiCdgF3Gwcr8502r532kySIlJaIPQGCvSLSWRHSLr8KxuT
 Y/bH2wgzJ2f/t3m/sXKrKuHAm/Y=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e61029c.7f60ae435c70-smtp-out-n05;
 Thu, 05 Mar 2020 13:46:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 734F2C433A2; Thu,  5 Mar 2020 13:46:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99EF3C43383;
        Thu,  5 Mar 2020 13:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99EF3C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-03-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200305134603.734F2C433A2@smtp.codeaurora.org>
Date:   Thu,  5 Mar 2020 13:46:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-03-05

for you to fetch changes up to b102f0c522cf668c8382c56a4f771b37d011cda2:

  mt76: fix array overflow on receiving too many fragments for a packet (2020-03-03 17:30:25 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.6

Second set of fixes for v5.6. Only two small fixes this time.

iwlwifi

* fix another initialisation regression with 3168 devices

mt76

* fix memory corruption with too many rx fragments

----------------------------------------------------------------
Dan Moulding (1):
      iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Felix Fietkau (1):
      mt76: fix array overflow on receiving too many fragments for a packet

 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/dma.c     | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)
