Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32DF36677D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhDUJEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:04:39 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:23703 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhDUJEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:04:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618995845; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=lTP6Ar4M52/MkscA1rcfyBrCFnV994Cq/bPhLE8x9G8=; b=wkQik6fCo/l9j5DbMb2rw1RsFRTIFxwMPUqBq3rlsm7I/jJVlOJ/dRO1+nU9zrb0aq/PVmkp
 shOV40LId6cxl976JltiJLzXWglF2erujX5SDA1Ftw949GhndKXBwWVC/Ep0PpbwyrdixmFY
 Ij6o24Lpy/O7FqV5fcoYVRP3W4g=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 607fea67215b831afbbea61e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Apr 2021 09:03:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7A50CC4338A; Wed, 21 Apr 2021 09:03:35 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E9CCC433D3;
        Wed, 21 Apr 2021 09:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E9CCC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-04-21
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
Date:   Wed, 21 Apr 2021 09:03:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:

  Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-04-21

for you to fetch changes up to e7020bb068d8be50a92f48e36b236a1a1ef9282e:

  iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd() (2021-04-19 20:35:10 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.12

As there was -rc8 release, one more important fix for v5.12.

iwlwifi

* fix spinlock warning in gen2 devices

----------------------------------------------------------------
Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
