Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B428C3EF0A1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhHQRLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:11:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30725 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhHQRLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 13:11:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629220257; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=j4CvZGuYP14rkmjA9Lt+u0xDy49L6nJEIItpS1gWPR4=; b=qpxXDi6h6bSpVB2fusEVhCCGCvW3bvIrNl1EmrGNswmJnW84hj95Sq6fqxcaX7Gu2jfmQO1V
 lXZvaEoehzi1f/HwTb38ltOZBNAkBOXvgBw2yDSyDgRTHpv6M6XBKOJrdmS+YDAmr6036GKj
 2o0sb7UQBnwPQ35YWnJBnPy7+2Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 611bed84454b7a558f812e1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 17 Aug 2021 17:10:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EC1E6C43460; Tue, 17 Aug 2021 17:10:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E3967C4338F;
        Tue, 17 Aug 2021 17:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E3967C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-08-17
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210817171027.EC1E6C43460@smtp.codeaurora.org>
Date:   Tue, 17 Aug 2021 17:10:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 09cfae9f13d51700b0fecf591dcd658fc5375428:

  ixgbe: Fix packet corruption due to missing DMA sync (2021-07-20 16:58:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-08-17

for you to fetch changes up to abf3d98dee7c4038152ce88833ddc2189f68cbd4:

  mt76: fix enum type mismatch (2021-08-06 10:56:53 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.14

First set of fixes for v5.14 and nothing major this time. New devices
for iwlwifi and one fix for a compiler warning.

iwlwifi

* support for new devices

mt76

* fix compiler warning about MT_CIPHER_NONE

----------------------------------------------------------------
Arnd Bergmann (1):
      mt76: fix enum type mismatch

Johannes Berg (1):
      iwlwifi: pnvm: accept multiple HW-type TLVs

Yaara Baruch (2):
      iwlwifi: add new SoF with JF devices
      iwlwifi: add new so-jf devices

 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c    | 25 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 70 ++++++++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h |  3 +-
 6 files changed, 91 insertions(+), 14 deletions(-)
