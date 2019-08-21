Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7E971E4
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfHUGHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:07:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbfHUGHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 02:07:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9282B60ACF; Wed, 21 Aug 2019 06:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566367654;
        bh=pXIBqk4P+QePW7ibCGrnyuR0zHexMYLeI86KiWRpM0Y=;
        h=From:To:Cc:Subject:Date:From;
        b=JaVC9qTTK66W6xP3lSDunbODw1J9tS5SFbIFCUKIT/+Va2VCWRGWixZfR4wm0uw+E
         /ov9w6X91zUGfI1Ojw7KTugXe+VbJ1xwNcOiGmYbZM6+HMYs76oxTzv4GuELiyXGpc
         /lUJSNGC3t1Qb3V0rHnDdOQdSCBhPMP+XXQJ8Trs=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97F0E60741;
        Wed, 21 Aug 2019 06:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566367654;
        bh=pXIBqk4P+QePW7ibCGrnyuR0zHexMYLeI86KiWRpM0Y=;
        h=From:To:Cc:Subject:Date:From;
        b=JaVC9qTTK66W6xP3lSDunbODw1J9tS5SFbIFCUKIT/+Va2VCWRGWixZfR4wm0uw+E
         /ov9w6X91zUGfI1Ojw7KTugXe+VbJ1xwNcOiGmYbZM6+HMYs76oxTzv4GuELiyXGpc
         /lUJSNGC3t1Qb3V0rHnDdOQdSCBhPMP+XXQJ8Trs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97F0E60741
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: pull-request: wireless-drivers 2019-08-21
Date:   Wed, 21 Aug 2019 09:07:30 +0300
Message-ID: <87zhk359wd.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net for 5.3, more info below. I will be offline
the next week, but Johannes should be able to help if there are any
issues.

Kalle


The following changes since commit d1abaeb3be7b5fa6d7a1fbbd2e14e3310005c4c1:

  Linux 5.3-rc5 (2019-08-18 14:31:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-08-21

for you to fetch changes up to 5a8c31aa63578cb0ff390a57537f1cb4b312a1ed:

  iwlwifi: pcie: fix recognition of QuZ devices (2019-08-20 17:00:42 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.3

Third set of fixes for 5.3, and most likely the last one. The rt2x00
regression has been reported multiple times, others are of lower
priority.

mt76

* fix hang on resume on certain machines

rt2x00

* fix AP mode regression related to encryption

iwlwifi

* avoid unnecessary error messages due to multicast frames when not
  associated

* fix configuration for ax201 devices

* fix recognition of QuZ devices

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: fix the byte count table format for 22560 devices

Ilan Peer (1):
      iwlwifi: mvm: Allow multicast data frames only when associated

Luca Coelho (2):
      iwlwifi: pcie: don't switch FW to qnj when ax201 is detected
      iwlwifi: pcie: fix recognition of QuZ devices

Stanislaw Gruszka (2):
      mt76: mt76x0u: do not reset radio on resume
      rt2x00: clear IV's on start to fix AP mode regression

 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 33 ++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 17 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 20 +++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c   |  8 +++---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c    |  9 +++++++
 drivers/net/wireless/ralink/rt2x00/rt2x00.h       |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c    | 13 +++++----
 9 files changed, 93 insertions(+), 19 deletions(-)
