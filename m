Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5364B399DD3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFCJd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:33:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:15511 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhFCJd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:33:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622712702; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=04FY2EG0f7DDNMgCEhcMYX12ljjPnhGTWflAQQerQQw=;
 b=Uim6lMJOa8VuOl8QpJYhoqF8m3voYASnZiKy30xCAfB1HBiDC4QBceOJNXlQnzr0pF2VzEYq
 ooSyQZfu3ZzoJLyu9HMipEIxBpB93PynCjYD4a8TYjjVc8Rb4xr3FWhTa9mUxgohl9M8oM8K
 7LLR36FZHcgQLZwODpIDimQl2o4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60b8a174ed59bf69cc79a7be (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Jun 2021 09:31:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DAA68C4338A; Thu,  3 Jun 2021 09:31:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2272CC433F1;
        Thu,  3 Jun 2021 09:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2272CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43legacy: Remove unused inline function
 txring_to_priority()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210529115131.6028-1-yuehaibing@huawei.com>
References: <20210529115131.6028-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <Larry.Finger@lwfinger.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <gustavoars@kernel.org>,
        <yuehaibing@huawei.com>, <linux-wireless@vger.kernel.org>,
        <b43-dev@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210603093132.DAA68C4338A@smtp.codeaurora.org>
Date:   Thu,  3 Jun 2021 09:31:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> commit 5d07a3d62f63 ("b43legacy: Avoid packet losses in the dma worker code")
> left behind this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d1dbaa54191e b43legacy: Remove unused inline function txring_to_priority()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210529115131.6028-1-yuehaibing@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

