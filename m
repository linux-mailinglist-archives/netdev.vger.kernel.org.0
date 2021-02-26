Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A613265CF
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhBZQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:44:47 -0500
Received: from z11.mailgun.us ([104.130.96.11]:54224 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhBZQoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 11:44:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614357857; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=sql488y/qu9t/oHUz8BmsXLbW0bUGtT0YMWwo5A+/D4=; b=Av6LjqTk447VFzxExQt8D4KzYEuhN9nCv9XaSOAc272gM8bCmHuNJVVlHii0Qmk5XzW2cHmH
 yhj3YIOmaGBrT1ZLrkOr3Ye04e5w020F1ZzVOXDfEYjWI8O4vbQVv7ObsFVERNkvFCQGU7Vl
 FRJgixFUxcUt3iXC/demPvKeG3A=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6039255c75e4458f08fdce02 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Feb 2021 16:44:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CDD03C433CA; Fri, 26 Feb 2021 16:44:11 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7633AC433C6;
        Fri, 26 Feb 2021 16:44:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7633AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-02-26
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210226164411.CDD03C433CA@smtp.codeaurora.org>
Date:   Fri, 26 Feb 2021 16:44:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 773dc50d71690202afd7b5017c060c6ca8c75dd9:

  Merge branch 'Xilinx-axienet-updates' (2021-02-12 17:38:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-02-26

for you to fetch changes up to c490492f15f656340b35cb9e36b9bfdea3539e19:

  mt76: mt7915: fix unused 'mode' variable (2021-02-26 17:35:15 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.12

First set of fixes for v5.12. One iwlwifi kernel crash fix and smaller
fixes to multiple drivers.

ath9k

* fix Spatial Multiplexing Power Save (SMPS) handling to improve thoughtput

mt76

* error handling fixes

* memory leax fixes

iwlwifi

* don't crash during debug collection on DVM devices

MAINTAINERS

* email address update

ath11k

* fix GCC warning about DMA address debug messages

* fix regression which broke QCA6390 AP mode

----------------------------------------------------------------
Arnd Bergmann (2):
      mt76: mt7921: remove incorrect error handling
      mt76: mt7915: fix unused 'mode' variable

Felix Fietkau (3):
      ath9k: fix transmitting to stations in dynamic SMPS mode
      mt76: fix tx skb error handling in mt76_dma_tx_queue_skb
      mt76: mt7915: only modify tx buffer list after allocating tx token id

Geert Uytterhoeven (1):
      ath11k: qmi: use %pad to format dma_addr_t

Johannes Berg (1):
      iwlwifi: avoid crash on unsupported debug collection

Kalle Valo (2):
      ath11k: fix AP mode for QCA6390
      iwlwifi: pcie: fix iwl_so_trans_cfg link error when CONFIG_IWLMVM is disabled

Lorenzo Bianconi (1):
      mt76: dma: do not report truncated frames to mac80211

Sharvari Harisangam (1):
      MAINTAINERS: update for mwifiex driver maintainers

 MAINTAINERS                                        |  3 ++-
 drivers/net/wireless/ath/ath11k/mac.c              |  4 ++--
 drivers/net/wireless/ath/ath11k/qmi.c              |  4 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h             |  3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c              |  6 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  3 ++-
 drivers/net/wireless/mediatek/mt76/dma.c           | 26 +++++++++++-----------
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 10 ++++-----
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  4 +---
 11 files changed, 39 insertions(+), 30 deletions(-)
