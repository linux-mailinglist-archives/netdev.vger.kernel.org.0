Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB92731143C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhBEWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:02:10 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:46352 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232921AbhBEO4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:56:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612542903; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=5DSTHrZK4wM2icaWTMo1JarJaPCtwqgT8lF+/L+De9U=; b=jk/n+znH6jfKyqfRDbS+kfu12vDl1y8X5uP3XhOkmyVC6oLmhbF5/bviXxDP+5sWyZ31KeI1
 UsK5C5BmwSV3BYQeQI8uq0g8RLEVqelF1x8XjGUvpTVlTgPcY1w6rG1zRHERURE2QNH19KXI
 Cs/qWrap64wi/CN0lQLlnLea0UQ=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 601d739a0bb8f50fb9948deb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Feb 2021 16:34:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 14D94C433ED; Fri,  5 Feb 2021 16:34:34 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19D29C433C6;
        Fri,  5 Feb 2021 16:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19D29C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-02-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210205163434.14D94C433ED@smtp.codeaurora.org>
Date:   Fri,  5 Feb 2021 16:34:34 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 0acb20a5438c36e0cf2b8bf255f314b59fcca6ef:

  mt7601u: fix kernel crash unplugging the device (2021-01-25 16:02:52 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-02-05

for you to fetch changes up to 93a1d4791c10d443bc67044def7efee2991d48b7:

  mt76: dma: fix a possible memory leak in mt76_add_fragment() (2021-01-28 09:30:37 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.11

Third, and most likely the last, set of fixes for v5.11. Two very
small fixes.

ath9k

* fix build regression related to LEDS_CLASS

mt76

* fix a memory leak

----------------------------------------------------------------
Arnd Bergmann (1):
      ath9k: fix build error with LEDS_CLASS=m

Lorenzo Bianconi (1):
      mt76: dma: fix a possible memory leak in mt76_add_fragment()

 drivers/net/wireless/ath/ath9k/Kconfig   | 8 ++------
 drivers/net/wireless/mediatek/mt76/dma.c | 8 +++++---
 net/mac80211/Kconfig                     | 2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)
