Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A882C2AE5
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgKXPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:08:51 -0500
Received: from z5.mailgun.us ([104.130.96.5]:57952 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389459AbgKXPIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:08:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606230530; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=+JQsvyb2icbWmCQhERdftrZs+Pl9Bj+IJAJ1JKr1yN8=;
 b=f0OSFNwLFEn/M2ijl0ilziCcelyORcZxm1o7Thfq53ymsmzUqcxr/dNc9gwHZO51Kl5Qa6te
 co+YTdsCZWHbY6SoplZ4o1CrRvzPaW4jc4Fk4AjHokA4+BaQbgh1U0Dm1Ac/0DFbViYA1rCg
 n/fnXmyl4hfuprcCnqlY25xC5Zk=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fbd21fffa67d9becf801678 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:08:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 08B8EC43460; Tue, 24 Nov 2020 15:08:47 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3AF7EC433ED;
        Tue, 24 Nov 2020 15:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3AF7EC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: cw1200: fix missing destroy_workqueue() on error in
 cw1200_init_common
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201119070842.1011-1-miaoqinglang@huawei.com>
References: <20201119070842.1011-1-miaoqinglang@huawei.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124150847.08B8EC43460@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 15:08:47 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qinglang Miao <miaoqinglang@huawei.com> wrote:

> Add the missing destroy_workqueue() before return from
> cw1200_init_common in the error handling case.
> 
> Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

7ec8a926188e cw1200: fix missing destroy_workqueue() on error in cw1200_init_common

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201119070842.1011-1-miaoqinglang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

