Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F338186A
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhEOLiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:38:50 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:19495 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhEOLit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 07:38:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621078657; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=r7fFoM1yXg8qcpIc9QUga1h4UJi7QkVRRGKul8DaLIo=; b=rFkBPsKHtJHoEyipw5FZTDLU/t/t2ZKPgWUpicaXEenbsCnqGT3FXMniUHBvFwf5Si6PtLDJ
 z8QgkxCmBpOO9G3+yD2J9gwslkVeMTc0J0Q+YTH6y0cQmrj+XVdXjhegsMS0HXRgR27VbWqU
 cxFBebcDZpKN/iLFZenGJKOeuOY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 609fb27bb15734c8f9fddfb9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 15 May 2021 11:37:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFD4CC43460; Sat, 15 May 2021 11:37:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8C9CC433D3;
        Sat, 15 May 2021 11:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8C9CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 24/34] net: ath: ath5k: Fix wrong function name in comments
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
        <1621076039-53986-25-git-send-email-shenyang39@huawei.com>
        <87h7j4i5zy.fsf@codeaurora.org>
Date:   Sat, 15 May 2021 14:37:25 +0300
In-Reply-To: <87h7j4i5zy.fsf@codeaurora.org> (Kalle Valo's message of "Sat, 15
        May 2021 14:36:01 +0300")
Message-ID: <87cztsi5xm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Yang Shen <shenyang39@huawei.com> writes:
>
>> Fixes the following W=1 kernel build warning(s):
>>
>>  drivers/net/wireless/ath/ath5k/pcu.c:865: warning: expecting
>> prototype for at5k_hw_stop_rx_pcu(). Prototype was for
>> ath5k_hw_stop_rx_pcu() instead
>>
>> Cc: Jiri Slaby <jirislaby@kernel.org>
>> Cc: Nick Kossifidis <mickflemm@gmail.com>
>> Cc: Luis Chamberlain <mcgrof@kernel.org>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Yang Shen <shenyang39@huawei.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/pcu.c | 2 +-
>
> Patches for drivers/net/wireless should be sent to linux-wireless, I
> recommend submitting those patches separately from rest of the series.
> (Patches 24, 25, 29, 30 and 34)

Oh, and patch 33 should be also sent to linux-wireless.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
