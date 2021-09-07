Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D81402284
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 05:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhIGDju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 23:39:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22732 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhIGDjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 23:39:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630985924; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=URFQ2d5yfgfV4Tw0297JNt9EKh8NGekV8HtcCAp2kZ4=; b=AnUb9TJ+aIpNN+JGMTowcOpxSgtqEdHILa9ICAdd6WPt5ZvOcnIZC4Me3yEVveamZvtWtiOy
 JPF2gjqt70z+RqrhWI9gVHkDu/J6CRppcXne5gQnl+6Q0qjYy/pnCeKETCagTM+MkEAJc4uR
 NJ9DaVVxN07N4uxG0qKU5++aEtI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6136dec36fc2cf7ad9f033b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 07 Sep 2021 03:38:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE38EC43460; Tue,  7 Sep 2021 03:38:42 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD07CC4338F;
        Tue,  7 Sep 2021 03:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org AD07CC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-09-07
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210907033842.CE38EC43460@smtp.codeaurora.org>
Date:   Tue,  7 Sep 2021 03:38:42 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 205b95fe658ddba25236c60da777f67b4eec3fd3:

  net/ncsi: add get MAC address command to get Intel i210 MAC address (2021-09-01 17:18:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-09-07

for you to fetch changes up to e4457a45b41c1c2ec7fb392dc60f4e2386b48a90:

  iwlwifi: fix printk format warnings in uefi.c (2021-09-06 13:03:06 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.15

First set of fixes for v5.15 and only iwlwifi patches this time. Most
important being support for new hardware and new firmware API.

I had already earlier applied a fix which also Linus applied to this
tree as commit 1476ff21abb4 ("iwl: fix debug printf format strings"),
but this doesn't seem to cause any conflicts so I left it there.

iwlwifi

* add support for firmware API 66

* add support for Samsung Galaxy Book Flex2 Alpha

* fix a leak happening every time module is loaded

* fix a printk compiler warning

----------------------------------------------------------------
Christophe JAILLET (1):
      iwlwifi: pnvm: Fix a memory leak in 'iwl_pnvm_get_from_fs()'

Justin M. Forbes (1):
      iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha

Luca Coelho (1):
      iwlwifi: bump FW API to 66 for AX devices

Randy Dunlap (1):
      iwlwifi: fix printk format warnings in uefi.c

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c   | 6 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c   | 4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c  | 1 +
 4 files changed, 9 insertions(+), 4 deletions(-)
