Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694F1265D20
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 11:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgIKJ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 05:58:49 -0400
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:56022
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbgIKJ6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599818326;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=soMKq6DE1LqLA+c4mCcL7lf4QSRLtWRGs63cDp+71WQ=;
        b=DPO+AUZFr3Wzl/Cvue7wjt1LXr7bzR5jOvV5tLxCR+vQINfadifCclbIhaZjcmvP
        CnGkdFPlXJV2HYLDwnE7FI3zAqd6O84T2deUya8Ylm8kpDrGuGuZ0B1yET+PTOkhj5L
        2AXnUlmQUuWVyX224FmJnW+N7QDrYqQu70Tyl7xA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599818326;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=soMKq6DE1LqLA+c4mCcL7lf4QSRLtWRGs63cDp+71WQ=;
        b=gEY7SfwkPe+aYg/XLLXfN8U68f1VnkFhpj/NsfAw73ipulQKzPj8AKe2s8cfaH+y
        RRCnHY2We9A2R5ykK0YPF1PB7Nt4XC45frFtF8GD8SyrtWSIE3PSyR1ekgNhsSRMki0
        spYcwE46FftGqbj4mSit+Riz2R/W4pRxzjQqDPY8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42629C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Remove unused inline function
 htt_htt_stats_debug_dump()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909134533.19604-1-yuehaibing@huawei.com>
References: <20200909134533.19604-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <010101747c9a5fd4-d977d1ca-5416-433e-b897-bc3d423e6ce5-000000@us-west-2.amazonses.com>
Date:   Fri, 11 Sep 2020 09:58:46 +0000
X-SES-Outgoing: 2020.09.11-54.240.27.187
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

9bc260653a1d ath11k: Remove unused inline function htt_htt_stats_debug_dump()

-- 
https://patchwork.kernel.org/patch/11765693/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

