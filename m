Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0883FF19D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346410AbhIBQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:40:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:53687 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346141AbhIBQkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 12:40:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630600767; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GYe1aMF26JSP65TkQBq2Y9QUE9uB3YBwVw+6lFUmJLo=;
 b=sKwtIk0Pus/nPQtfv5FzIhV00TmN4T+QpfvXhORoF7Fagb3BNs5xpIxH6vzRqwXuzUHjGFSE
 UCVS3INb6AbIU+psvmYprrllmi5Gv7StvGNcYKWbtozwiYnBMtgAwSMCrd7rgffhxBEQqYHE
 RrZL5L/S/kEszdvGXxN9ePyzxZA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6130fe35d15f4d68a23f52a1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Sep 2021 16:39:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 063BFC4338F; Thu,  2 Sep 2021 16:39:17 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3ED7CC43460;
        Thu,  2 Sep 2021 16:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3ED7CC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2
 Alpha
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210702223155.1981510-1-jforbes@fedoraproject.org>
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
To:     "Justin M. Forbes" <jforbes@fedoraproject.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        ybaruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jforbes@fedoraproject.org,
        jmforbes@linuxtx.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210902163917.063BFC4338F@smtp.codeaurora.org>
Date:   Thu,  2 Sep 2021 16:39:17 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Justin M. Forbes" <jforbes@fedoraproject.org> wrote:

> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
> This works fine with the existing driver once it knows to claim it.
> Simple patch to add the device.
> 
> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>

Patch applied to wireless-drivers.git, thanks.

2f32c147a381 iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210702223155.1981510-1-jforbes@fedoraproject.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

