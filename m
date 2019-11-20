Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53139103537
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKTHew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:34:52 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:57038
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfKTHev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574235291;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=1fK/XBGrQiimwhbG+LsnZu0FxS9Rvgom4tzk+Gd6qss=;
        b=myhRe1xxFnth52SxMupnr1LnYoFRNIF28331JKvJOMDY3RpajbOZiyBrRVSlrmMT
        BM0LnvmltNvk9MmFW4LbDNqwj32RHwL75tXlCjtgPXimPA5UybfsrPN4WrSPK/cvRBy
        YoNmwsc7rG12ax1/geZynpVQwp8pRiE1oswFjBRk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574235291;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=1fK/XBGrQiimwhbG+LsnZu0FxS9Rvgom4tzk+Gd6qss=;
        b=GHK7HXniS837zOW2L94fxzoOzqa7DULhsWXLe9pe3GFnQjOY49xzN7HkTgsn2b65
        y9VU/1OkZ5vRy7+03DhhsyLWeA0n0/P5avMNZ1KjmKT3sahXXGqIwoeLL5N2je4XaMK
        eHZoxF00Y8kPaZEVUje8bkkLH/HQuYSkQcws0bsg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E89BC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 1/2] ipw2x00: remove set but not used variable
 'reason'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1573890083-33761-2-git-send-email-zhengbin13@huawei.com>
References: <1573890083-33761-2-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <stas.yakovlev@gmail.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016e87bc3cd3-4a1d9abd-d833-4452-84b1-4b3a2335805a-000000@us-west-2.amazonses.com>
Date:   Wed, 20 Nov 2019 07:34:50 +0000
X-SES-Outgoing: 2019.11.20-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/intel/ipw2x00/ipw2200.c: In function ipw_wx_set_mlme:
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:6805:9: warning: variable reason set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

2 patches applied to wireless-drivers-next.git, thanks.

805a57acd7b5 ipw2x00: remove set but not used variable 'reason'
f89f1aefff5a ipw2x00: remove set but not used variable 'force_update'

-- 
https://patchwork.kernel.org/patch/11247481/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

