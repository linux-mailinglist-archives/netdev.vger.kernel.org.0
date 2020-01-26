Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189F51499FE
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAZKUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:20:10 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:44885 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgAZKUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:20:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580034008; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6412+BLhVSW8PNTq1taqVwzf9EM0Cg5Npbns+x+dIcA=;
 b=pEFF+q2l94itpCDb3fc9Nq6K7GeGA2xyLmdOTBvXrPylfswRZ6/6mfHTo5K1EUFs3OYW13cx
 Rr6R1IO80Dd6p6YQTIo67JxhFyQAeKKMWPSi1P1MtK4q6tdWiUD4nUJN82dJj4gTwveZLHeO
 G4hTV1evQCZWeSEX0dADkXZq8xk=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d67d6.7fd90a3ea180-smtp-out-n02;
 Sun, 26 Jan 2020 10:20:06 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5FDFEC43383; Sun, 26 Jan 2020 10:20:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 39BBFC43383;
        Sun, 26 Jan 2020 10:20:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 39BBFC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 3/6] ath9k: use true,false for bool variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1577196966-84926-4-git-send-email-zhengbin13@huawei.com>
References: <1577196966-84926-4-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <yhchuang@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126102006.5FDFEC43383@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:20:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes coccicheck warning:
> 
> drivers/net/wireless/ath/ath9k/ar9003_aic.c:409:2-12: WARNING: Assignment of 0/1 to bool variable
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

d27c768f3b61 ath9k: use true,false for bool variable
f89ee9927a49 wil6210: use true,false for bool variable

-- 
https://patchwork.kernel.org/patch/11309359/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
