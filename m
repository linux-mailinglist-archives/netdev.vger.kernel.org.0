Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3513A3681A6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhDVNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:43:55 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12039 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236428AbhDVNny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:43:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619099000; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=dC0ZEqAmDS6CmHmLUxQbdaNlksibBx0m9qEKhioaIbE=;
 b=hszTbjz0dzDEP2aa0dUzLX9Rfh4ZS5QZdpqcymN3/ntsSCSQnyOOW0dEeUt3+1cn/kbEV1GC
 4wuqGDzyVc99TCE36e01UBXGw+i866QFUB2bOa+9XwWFmpKrxING4XFuauYf6+8HQEP0jl8l
 LyjcN0ZXaCC6qLSaODfD6B+fud4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60817d5c03cfff34528148ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 13:42:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30E07C4338A; Thu, 22 Apr 2021 13:42:51 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD15DC433D3;
        Thu, 22 Apr 2021 13:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD15DC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next v2] drivers: net: CONFIG_ATH9K select LEDS_CLASS and
 NEW_LEDS
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210330120533.102712-1-zhangjianhua18@huawei.com>
References: <20210330120533.102712-1-zhangjianhua18@huawei.com>
To:     Zhang Jianhua <zhangjianhua18@huawei.com>
Cc:     <ath9k-devel@qca.qualcomm.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <zhangjianhua18@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <johnny.chenyi@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422134251.30E07C4338A@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 13:42:51 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Jianhua <zhangjianhua18@huawei.com> wrote:

> If CONFIG_ATH9K=y, the following errors will be seen while compiling
> gpio.c
> 
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_deinit_leds':
> gpio.c:(.text+0x604): undefined reference to `led_classdev_unregister'
> gpio.c:(.text+0x604): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_unregister'
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_init_leds':
> gpio.c:(.text+0x708): undefined reference to `led_classdev_register_ext'
> gpio.c:(.text+0x708): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_register_ext'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Jianhua <zhangjianhua18@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Recently there was a related fix, I need more information about this problem.
What is exactly causing this? Is this a recent regression or an old problem?

Can someone review this?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210330120533.102712-1-zhangjianhua18@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

