Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407AA3130B8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhBHLYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:24:12 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:16676 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233104AbhBHLUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:20:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612783221; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KkVyv41cBCzpOYIgOkQEHFQuRj7l7JQNAxJ8pqb+tcQ=;
 b=hirVtl+OSr8t3fAT8p9XxaA4+rYY2Zr9ZhNwfLzIhwmIuhxRhVJR/ZBK00DcYhEGHPGYnGGy
 PdIsEp65EOl3BGau8sVYqoPadibr8sLR/0A+CrOAK4NKu4uxupJqDWrFpVIdoepQOgDdDCUf
 LvIXqe441A+E2Xs8+szEvhXKrWk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60211e5a81f6c45dce8b19aa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 11:19:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2509FC43463; Mon,  8 Feb 2021 11:19:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 26F99C433CA;
        Mon,  8 Feb 2021 11:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 26F99C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: remove redundant assignment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210203062717.1228-1-samirweng1979@163.com>
References: <20210203062717.1228-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208111954.2509FC43463@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 11:19:54 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> INVALID_QUEUE has been used as a return value,it is not necessary to
> assign it to q_num,so just return INVALID_QUEUE.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

d48aea6054d0 rsi: remove redundant assignment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210203062717.1228-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

