Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8C92D60A2
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391146AbgLJOiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:38:21 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:31791 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391139AbgLJOiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:38:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607611077; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=2UENAvr3UnfyT7Yes7BqMsH/lz30eJAtHLCVlaAJ4LM=; b=ExXaNhU4Fm7GbJB4GFa4KJb8xOAq/c3gzFtA3sGE+5mdyQBMs+UfLiKrhTHMXRVPhX60MWr+
 iZ1OAbBo4NKLWGD3/dLcML0axdDRZlbiJTN2psOIw01Qnl4Hhg6tFogRK0h6DeUzDrkohqQV
 KKU+5bYtxloH1xP8Yv++V+7W3es=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fd232a36752249c543cba34 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 14:37:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D03F6C43466; Thu, 10 Dec 2020 14:37:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C4A5C433CA;
        Thu, 10 Dec 2020 14:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C4A5C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless -next] wireless/ath10k: simplify the return expression of ath10k_ahb_chip_reset()
References: <20201210140204.1774-1-zhengyongjun3@huawei.com>
Date:   Thu, 10 Dec 2020 16:37:18 +0200
In-Reply-To: <20201210140204.1774-1-zhengyongjun3@huawei.com> (Zheng Yongjun's
        message of "Thu, 10 Dec 2020 22:02:04 +0800")
Message-ID: <87mtyl4ti9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> writes:

> Simplify the return expression.
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/wireless/ath/ath10k/ahb.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
> index 05a61975c83f..0ba31c0bbd24 100644
> --- a/drivers/net/wireless/ath/ath10k/ahb.c
> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
> @@ -598,16 +598,10 @@ static int ath10k_ahb_prepare_device(struct ath10k *ar)
>  
>  static int ath10k_ahb_chip_reset(struct ath10k *ar)
>  {
> -	int ret;
> -
>  	ath10k_ahb_halt_chip(ar);
>  	ath10k_ahb_clock_disable(ar);
>  
> -	ret = ath10k_ahb_prepare_device(ar);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> +	return ath10k_ahb_prepare_device(ar);
>  }
>  
>  static int ath10k_ahb_wake_target_cpu(struct ath10k *ar)

I prefer the original style, easier to add new code to the function.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
