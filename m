Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5847832C48F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441988AbhCDAPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:08 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:45101 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237589AbhCCRkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 12:40:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614793139; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=bB2rbwSDV6ozmbOs+QKeUgClF6zwQgkDjskWDJ/kKp4=; b=olJJx13U/XOcr9EkzBmBGbdcFDqFMlx/RVylfIc+6hQwSGZLmzXKSaRgnlb51m2SQbd8Lj5B
 jZQYkyWQ6WiqcdiwiW7wL4YfvyyEJybqs63IPVVsgkacbi8FeDPJAU8VqwhDyEAtpTyQG0y9
 5gb8Kq181MkI3Hn06KsK0sNuG80=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 603fc6c8c862e1b9fd99d7b2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 17:26:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8B86DC433ED; Wed,  3 Mar 2021 17:26:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D724C433C6;
        Wed,  3 Mar 2021 17:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D724C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-03-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210303172632.8B86DC433ED@smtp.codeaurora.org>
Date:   Wed,  3 Mar 2021 17:26:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit c490492f15f656340b35cb9e36b9bfdea3539e19:

  mt76: mt7915: fix unused 'mode' variable (2021-02-26 17:35:15 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-03-03

for you to fetch changes up to 295d4cd82b0181dd36b145fd535c13d623d7a335:

  iwlwifi: don't call netif_napi_add() with rxq->lock held (was Re: Lockdep warning in iwl_pcie_rx_handle()) (2021-03-03 17:59:16 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.12

Second set of fixes for v5.12. Only three iwlwifi fixes this time, the
crash with MVM being the most important one and reported by multiple
people.

iwlwifi

* fix kernel crash regression when using LTO with MVM devices

* fix printk format warnings

* fix potential deadlock found by lockdep

----------------------------------------------------------------
Jiri Kosina (1):
      iwlwifi: don't call netif_napi_add() with rxq->lock held (was Re: Lockdep warning in iwl_pcie_rx_handle())

Pierre-Louis Bossart (1):
      iwlwifi: fix ARCH=i386 compilation warnings

Wei Yongjun (1):
      iwlwifi: mvm: add terminate entry for dmi_system_id tables

 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)
