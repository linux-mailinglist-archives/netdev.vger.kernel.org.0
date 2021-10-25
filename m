Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36B04391A9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJYIqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:46:33 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49329 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhJYIqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:46:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635151451; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=jW00js9lQVp/ry056QHRrwvOuRESTWyc4LDSdFjHa4g=; b=iZNJSXaQfeWYXCmkXK1mJoGd6P41qM0M11FI69YbFVqkZRNC+YDfZ9CfnDnYn4+5VD/vgQ3V
 2DGarkV7zzArPS09wkvUqYG6MPP4qlineV+V5U65au/r482TWhiaxIyJ1FOvzLdVakiS2TjG
 JGFM4Oa1viApeGEk7wV+7HxbsZ8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61766e5a67f107c61127b461 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 08:44:10
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB75DC4360D; Mon, 25 Oct 2021 08:44:10 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C28E8C4338F;
        Mon, 25 Oct 2021 08:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C28E8C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-10-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211025084410.BB75DC4360D@smtp.codeaurora.org>
Date:   Mon, 25 Oct 2021 08:44:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 47b068247aa7d76bb7abea796b72e18a4c6e35c3:

  net: liquidio: Make use of the helper macro kthread_run() (2021-10-22 11:10:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-10-25

for you to fetch changes up to 753453afacc0243bd45de45e34218a8d17493e8f:

  mt76: mt7615: mt7622: fix ibss and meshpoint (2021-10-23 10:29:39 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.16

Third set of patches for v5.16. This time we have a small one to
quickly fix two mt76 build failures I had missed in my previous pull
request.

Major changes:

mt76

* fix linking when CONFIG_MMC is disabled

* fix dev_err() format warning

* mt7615: mt7622: fix ibss and meshpoint

----------------------------------------------------------------
Lorenzo Bianconi (1):
      mt76: mt7921: fix mt7921s Kconfig

Nick Hainke (1):
      mt76: mt7615: mt7622: fix ibss and meshpoint

Randy Dunlap (1):
      mt76: mt7921: fix Wformat build warning

 drivers/net/wireless/mediatek/mt76/mt7615/main.c  | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c  | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)
