Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001622E0D75
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgLVQiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:38:24 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:42411 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgLVQiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:38:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608655083; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=biEYqYTnVQqSnV+uJzCSSa8IwuXnVIABUcOcJUfi1vU=; b=Ncfs6MZO7tM5ZTq0krmfMnoGMsrNuoMkQlqBWZqWkwJyrOw55P8dpbOU1NYLBS369uJs8341
 MKcVzzCvpgOw7rBYDaDY4jFeYgTWPSjtdFAkitY87L1CZGSJV4uQ5l/9LJO+CSvZgwfVN6+d
 SNccabBVcm0hdabGMxWDACMH47E=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fe220c87036173f4fd90526 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 16:37:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D4336C433C6; Tue, 22 Dec 2020 16:37:27 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA7A0C433CA;
        Tue, 22 Dec 2020 16:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA7A0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-12-22
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201222163727.D4336C433C6@smtp.codeaurora.org>
Date:   Tue, 22 Dec 2020 16:37:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 13458ffe0a953e17587f172a8e5059c243e6850a:

  net: x25: Remove unimplemented X.25-over-LLC code stubs (2020-12-12 17:15:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-12-22

for you to fetch changes up to bfe55584713b4d4d518ffe9cf2dab1129eba6321:

  MAINTAINERS: switch to different email address (2020-12-21 19:07:39 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.11

First set of fixes for v5.11, more fixes than usual this time. For
ath11k we have several fixes for QCA6390 PCI support and mt76 has
several. Also one build fix for mt76.

mt76

* fix two NULL pointer dereference

* fix build error when CONFIG_MAC80211_MESH is disabled

rtlwifi

* fix use-after-free in firmware handling code

ath11k

* error handling fixes

* fix crash found during connect and disconnect test

* handle HT disable better

* avoid printing qmi memory failure during firmware bootup

* disable ASPM during firmware bootup

----------------------------------------------------------------
Arend van Spriel (1):
      MAINTAINERS: switch to different email address

Carl Huang (4):
      ath11k: fix crash caused by NULL rx_channel
      ath11k: start vdev if a bss peer is already created
      ath11k: qmi: try to allocate a big block of DMA memory first
      ath11k: pci: disable ASPM L0sLs before downloading firmware

Colin Ian King (1):
      ath11k: add missing null check on allocated skb

Dan Carpenter (2):
      ath11k: Fix error code in ath11k_core_suspend()
      ath11k: Fix ath11k_pci_fix_l1ss()

Kalle Valo (1):
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Lorenzo Bianconi (4):
      mt76: mt76u: fix NULL pointer dereference in mt76u_status_worker
      mt76: usb: remove wake logic in mt76u_status_worker
      mt76: sdio: remove wake logic in mt76s_process_tx_queue
      mt76: mt76s: fix NULL pointer dereference in mt76s_process_tx_queue

Ping-Ke Shih (1):
      rtlwifi: rise completion at the last step of firmware callback

Randy Dunlap (1):
      mt76: mt7915: fix MESH ifdef block

 MAINTAINERS                                      |  2 +-
 drivers/net/wireless/ath/ath11k/core.c           |  2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c          | 10 ++++--
 drivers/net/wireless/ath/ath11k/mac.c            |  8 +++--
 drivers/net/wireless/ath/ath11k/pci.c            | 44 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/pci.h            |  2 ++
 drivers/net/wireless/ath/ath11k/peer.c           | 17 +++++++++
 drivers/net/wireless/ath/ath11k/peer.h           |  2 ++
 drivers/net/wireless/ath/ath11k/qmi.c            | 24 +++++++++++--
 drivers/net/wireless/ath/ath11k/qmi.h            |  1 +
 drivers/net/wireless/ath/ath11k/wmi.c            |  3 ++
 drivers/net/wireless/mediatek/mt76/mt7915/init.c |  4 +--
 drivers/net/wireless/mediatek/mt76/sdio.c        | 19 ++++------
 drivers/net/wireless/mediatek/mt76/usb.c         |  9 ++---
 drivers/net/wireless/realtek/rtlwifi/core.c      |  8 +++--
 15 files changed, 118 insertions(+), 37 deletions(-)
