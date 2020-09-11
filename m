Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F749265D23
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 11:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgIKJ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 05:59:26 -0400
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:47052
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgIKJ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599818359;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=U0meEUz4aGuUw+kGbyj6MMa66pIP6tpJxlVsPbQ3jvQ=;
        b=U0RZCo8PH2fWGCET0rglrRu/nrGrud8rNNfjVqY4l7ZDUNBsZ7kJ2DUzFYRVbwJQ
        GMVk7qdmW84hIzFCl7/MWDdgxLX0RyIJzGs0g86PPgVhoetO/myQJh5s1ocL/dzUBeJ
        UNpOS0YKRwnnX298DFHh6S0WFyGA/+y0uuX/bzcE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599818359;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=U0meEUz4aGuUw+kGbyj6MMa66pIP6tpJxlVsPbQ3jvQ=;
        b=TVTlS3B/xbNZw1CwU8+fsf/P3djUnJkgdxREWK7Tpg7dFwgroPIkGHIEYTFactBr
        y0mbqACnqJU2N0dxXNm0Y63gRF+op1lLBZslGnpi6QwZ7bdDY/4OMVKRtUUaoSZZpM4
        utM6WOxd3+EFS6jYTkJa/F/qbh2Pql7jZnb5o40I=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5867BC433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909135834.38448-1-yuehaibing@huawei.com>
References: <20200909135834.38448-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <010101747c9ae0e8-fd3a6153-8f8f-4b94-9368-96729d6a71a6-000000@us-west-2.amazonses.com>
Date:   Fri, 11 Sep 2020 09:59:19 +0000
X-SES-Outgoing: 2020.09.11-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> There is no caller in tree, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

42a08ff79ff5 ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ

-- 
https://patchwork.kernel.org/patch/11765703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

