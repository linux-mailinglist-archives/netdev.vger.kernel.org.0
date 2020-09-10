Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303B22649DF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIJQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:33:39 -0400
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:37226
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbgIJQdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599755603;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=0uMJG9e6h21fAZ3s9X90mzgstSnrwci4MGxsgDvub+s=;
        b=M20rj6rglcDW/Moh8YOh9A2b2gok/gbDl9SXHzxY6JUFk5jTq85r5yIQ+vR1uz/z
        0XE0C2z8e315LvQday2iUMpONC/x0NyMGDRoBczP3GvMVw5MxJCKw9ES3ihmK5FIeHZ
        ixVIERbT9gggdnKLXZ7N0xYd9B7yE4qzlub4Zhe8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599755603;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=0uMJG9e6h21fAZ3s9X90mzgstSnrwci4MGxsgDvub+s=;
        b=kBtCzZ7UETMz9Xs1Ea+cjP5yDlcPR+5xyg9Sc0MazEehDH7bdiAEoMEdqp7TvJeP
        auNCjuFrNE0jNaG9thmBh98sgVxrbZh1szoNVgoUsH66nKeF8uxD+2xJ4BS4W1qPxHu
        oTst8DCSAhlnsWn0Q2yJeL0LJlwRUORH9InE3FEk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86204C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 26/29] ath9k: ar5008_initvals: Remove unused table
 entirely
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-27-lee.jones@linaro.org>
References: <20200910065431.657636-27-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017478dd4f78-f501b609-2b74-4eb8-9913-7d783adccdb9-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 16:33:23 +0000
X-SES-Outgoing: 2020.09.10-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:553:18: warning: ‘ar5416Bank6’ defined but not used [-Wunused-const-variable=]
> 
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Already fixed in ath.git.

error: patch failed: drivers/net/wireless/ath/ath9k/ar5008_initvals.h:550
error: drivers/net/wireless/ath/ath9k/ar5008_initvals.h: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766807/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

