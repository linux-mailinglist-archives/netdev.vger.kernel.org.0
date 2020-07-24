Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BB522C741
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGXODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:03:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13847 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgGXODt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 10:03:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595599428; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=Tu15BLUwKvHQDTbj5GU8pQlCzoGF12QBNrYYHMnPAuQ=; b=pd+tFesJeVPrRpJ/uBMMltFVYQSuw5LLWA4ce2Udr+yZ6+gTQziS7S7HN/DsvKwF7nqg+IAD
 fyohjUtPd5xsmkjmzKRfCsXWmos0eYN0qrQi0kdXRp61aGkPqgH/WuAPoaAzHsydF2NSf20j
 ZCF6TNLRfeLm48tLrJTRA9bHFrE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f1aea17845c4d05a3d01c3b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Jul 2020 14:03:03
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D143AC433CB; Fri, 24 Jul 2020 14:03:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0296CC433C6;
        Fri, 24 Jul 2020 14:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0296CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-07-24
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200724140302.D143AC433CB@smtp.codeaurora.org>
Date:   Fri, 24 Jul 2020 14:03:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit dc7bd30b97aac8a97eccef0ffe31f6cefb6e2c3e:

  mt76: mt7615: fix EEPROM buffer size (2020-06-23 11:43:41 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-07-24

for you to fetch changes up to 1cfd3426ef989b83fa6176490a38777057e57f6c:

  ath10k: Fix NULL pointer dereference in AHB device probe (2020-07-20 20:23:48 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.8

Second set of fixes for v5.8, and hopefully also the last. Three
important regressions fixed.

ath9k

* fix a regression which broke support for all ath9k usb devices

ath10k

* fix a regression which broke support for all QCA4019 AHB devices

iwlwifi

* fix a regression which broke support for some Killer Wireless-AC 1550 cards

----------------------------------------------------------------
Alessio Bonfiglio (1):
      iwlwifi: Make some Killer Wireless-AC 1550 cards work again

Hauke Mehrtens (1):
      ath10k: Fix NULL pointer dereference in AHB device probe

Mark O'Donovan (1):
      ath9k: Fix regression with Atheros 9271

 drivers/net/wireless/ath/ath10k/ahb.c         |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c         | 78 +++++++++++++--------------
 drivers/net/wireless/ath/ath9k/hif_usb.c      |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 +
 4 files changed, 43 insertions(+), 43 deletions(-)
