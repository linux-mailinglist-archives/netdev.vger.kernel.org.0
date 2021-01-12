Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE32F3498
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405736AbhALPsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:48:09 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:59291 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404932AbhALPsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:48:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610466469; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Npsm5bOJjjcIuADdoI2VTocPa/2BU7I+DV9Z9yFCxjA=; b=lqg7NvuShMEOhrnwlERdqBrQ8MWAVrgesbFxyUVos5De+lD0X+kImbBcRV7n/6ajarvU0Ooq
 sAuu9Jar5RHBln45j/ktK1g2sV3m3irJm8EYmdnPGUJK/i0/wdfmV7hfNXOa15ZtGKQkzro+
 hs3Y+jMgzCFZKhLIug8J6/qKfGc=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5ffdc4858fb3cda82feebb07 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 15:47:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39015C43462; Tue, 12 Jan 2021 15:47:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4861C433CA;
        Tue, 12 Jan 2021 15:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C4861C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "abaci-bugfix\@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: style: Simplify bool comparison
References: <1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        <1610457587.2793.2.camel@realtek.com>
Date:   Tue, 12 Jan 2021 17:47:12 +0200
In-Reply-To: <1610457587.2793.2.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 12 Jan 2021 13:20:21 +0000")
Message-ID: <87y2gyrwcf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

> On Tue, 2021-01-12 at 16:33 +0800, YANG LI wrote:
>> Fix the following coccicheck warning:
>> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3853:7-17:
>> WARNING: Comparison of 0/1 to bool variable
>> 
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
>> 
>
> I think your name of Signed-off-by should be "Yang Li".
>
> And, the subject prefix "rtlwifi: " is preferred.

I can fix those during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
