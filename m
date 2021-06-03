Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C3399D50
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhFCJDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:03:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:15800 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhFCJC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:02:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622710875; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=BpO9Uierd0hCNPcdVGEgKQE2/NyXFRjvWuOrwKQLmqQ=; b=umNoDAV/B7qP0pvm+bYzH0sqcz883iy1Vkk+EDtGMj6/1Gbu+i65ALldMqCACoThcKTLcU67
 bVTkarqNeztg1ipgYrH9EXh4svYot4EXO2zIJSQkiNfRCc5Z7dTzng++RA8KTVrFeFfnFIeY
 xs2WxiwYpX/ijnUZNoI8QiU5RsY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60b89a3be27c0cc77f3ae89e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Jun 2021 09:00:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A5823C433F1; Thu,  3 Jun 2021 09:00:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB2CAC433D3;
        Thu,  3 Jun 2021 09:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB2CAC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-06-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210603090042.A5823C433F1@smtp.codeaurora.org>
Date:   Thu,  3 Jun 2021 09:00:42 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-06-03

for you to fetch changes up to d4826d17b3931cf0d8351d8f614332dd4b71efc4:

  mt76: mt7921: remove leftover 80+80 HE capability (2021-05-30 22:11:24 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.13

We have only mt76 fixes this time, most important being the fix for
A-MSDU injection attacks.

mt76

* mitigate A-MSDU injection attacks (CVE-2020-24588)

* fix possible array out of bound access in mt7921_mcu_tx_rate_report

* various aggregation and HE setting fixes

* suspend/resume fix for pci devices

* mt7615: fix crash when runtime-pm is not supported

----------------------------------------------------------------
Felix Fietkau (4):
      mt76: connac: fix HT A-MPDU setting field in STA_REC_PHY
      mt76: mt7921: fix max aggregation subframes setting
      mt76: validate rx A-MSDU subframes
      mt76: mt7921: remove leftover 80+80 HE capability

Lorenzo Bianconi (4):
      mt76: mt7921: fix possible AOOB issue in mt7921_mcu_tx_rate_report
      mt76: connac: do not schedule mac_work if the device is not running
      mt76: mt76x0e: fix device hang during suspend/resume
      mt76: mt7615: do not set MT76_STATE_PM at bootstrap

 drivers/net/wireless/mediatek/mt76/mac80211.c      | 26 +++++++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  1 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  5 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   | 19 +++--
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |  3 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  4 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    | 81 ++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 17 +++--
 11 files changed, 138 insertions(+), 30 deletions(-)
