Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238C1C4F46
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgEEHhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:37:54 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:15974 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgEEHhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 03:37:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588664273; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2McI1FWD3m/wAj6AQH+spz3g8qwMFFHS2qFeMmUi/PU=;
 b=gHgNBKuM6UXn0T9khrAzF9ytiShDuhSgSJyI3vXtXTdJVn+5evbc49BBdp3WEVl6SDUo91SA
 6oP/b6NdOT+AYDyFWNMeu8uobrIyQyUdXw43Ig5BCOZmi0cnNBCE6yYSxZ06/BR1lN7dQ1NX
 jeqoMx/Q5s4MFeo8Ue1LxCXUnSA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb117cb.7f0d1f0ca1b8-smtp-out-n03;
 Tue, 05 May 2020 07:37:47 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A4006C433BA; Tue,  5 May 2020 07:37:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBD08C433D2;
        Tue,  5 May 2020 07:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBD08C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: use true,false for bool variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200504113336.41249-1-yanaijie@huawei.com>
References: <20200504113336.41249-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <srirrama@codeaurora.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200505073746.A4006C433BA@smtp.codeaurora.org>
Date:   Tue,  5 May 2020 07:37:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/ath/ath11k/dp_rx.c:2964:1-39: WARNING: Assignment
> of 0/1 to bool variable
> drivers/net/wireless/ath/ath11k/dp_rx.c:2965:1-38: WARNING: Assignment
> of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b7b527b9c7c8 ath11k: use true,false for bool variables

-- 
https://patchwork.kernel.org/patch/11525535/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
