Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A37EBF391
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfIZM5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:57:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfIZM5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:57:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2FB196013C; Thu, 26 Sep 2019 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569502657;
        bh=XWJZ29qmhxdNsiEDSm4SmSSi0jFoSNnwAiHHPXLLh2Y=;
        h=From:To:Cc:Subject:Date:From;
        b=mLB6ESXn5HOGoQJpWnkUNKljeiPsPpPl3NccJNM/AzT+s3HiWv6rLKb6SW7bOkS/y
         7phhZGnQTWOBIDMnfZuEch3ctdHzjkquzSpvpdujKdKjt/CuXYEIMSlJgftGWOaDa7
         UUiH3QeRFAppqn+8sfcWE8ua3k+aWHv7XFpSYwEA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BCEA6016D;
        Thu, 26 Sep 2019 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569502656;
        bh=XWJZ29qmhxdNsiEDSm4SmSSi0jFoSNnwAiHHPXLLh2Y=;
        h=From:To:Cc:Subject:Date:From;
        b=D9NbvxsSKCAUttzEPFtiHP/pDAp13i96vTF4YoqbpiefOXmOlUVy5B2N8GFsnbtG3
         8QxL3fDQ99lzgCCNEcVdZCFHVen9+bWeslAV53BKLcD44oz6bNSdtxq24yP9JmdEEM
         wC7YiqglQ+nktugLTWVmPWcerDsEqTnAW3sWj0LA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BCEA6016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-09-26
Date:   Thu, 26 Sep 2019 15:57:33 +0300
Message-ID: <8736gj5i6a.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net tree for v5.4. Please let me know if there
are any problems.

Kalle


The following changes since commit 280ceaed79f18db930c0cc8bb21f6493490bf29c:

  usbnet: sanity checking of packet sizes and device mtu (2019-09-19 13:27:11 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-09-26

for you to fetch changes up to 2b481835cf4e7384b80d7762074b32a45b792d99:

  wil6210: use after free in wil_netif_rx_any() (2019-09-25 09:12:20 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.4

First set of fixes for 5.4 sent during the merge window. Most are
regressions fixes but the mt7615 problem has been since it was merged.

iwlwifi

* fix a build regression related CONFIG_THERMAL

* avoid using GEO_TX_POWER_LIMIT command on certain firmware versions

rtw88

* fixes for skb leaks

zd1211rw

* fix a compiler warning on 32 bit

mt76

* fix the firmware paths for mt7615 to match with linux-firmware

wil6210

* fix use of skb after free

----------------------------------------------------------------
Dan Carpenter (1):
      wil6210: use after free in wil_netif_rx_any()

Geert Uytterhoeven (1):
      zd1211rw: zd_usb: Use "%zu" to format size_t

Johannes Berg (1):
      iwlwifi: mvm: fix build w/o CONFIG_THERMAL

Lorenzo Bianconi (1):
      mt76: mt7615: fix mt7615 firmware path definitions

Luca Coelho (1):
      iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36

Yan-Hsuan Chuang (3):
      rtw88: pci: extract skbs free routine for trx rings
      rtw88: pci: release tx skbs DMAed when stop
      rtw88: configure firmware after HCI started

 drivers/net/wireless/ath/wil6210/txrx.c            |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  9 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 11 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  6 +--
 drivers/net/wireless/realtek/rtw88/mac.c           |  3 --
 drivers/net/wireless/realtek/rtw88/main.c          |  4 ++
 drivers/net/wireless/realtek/rtw88/pci.c           | 48 +++++++++++++++++-----
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |  2 +-
 9 files changed, 63 insertions(+), 30 deletions(-)
