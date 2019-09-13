Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C76B212E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388733AbfIMNhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:37:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387584AbfIMNhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:37:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BDA7760767; Fri, 13 Sep 2019 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568381872;
        bh=IISeWQxNAdCObwP9mJjaExic+PQ/4Av37VV7Ya2x/YM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FN6AbRaoI/KGMGj0HLNzg2KWAdrlZOGMbfVpz8oxQ+rXbglOwuksxtXfoEv0q6Nhc
         7rpPE3QyP2y2weTMI5/8at9+VonrFn0IFFVEL21C+K9kpg2S4HDvPymfYVR7xesGqr
         iH8JNxNG8L8ZFcu/yBcDvXnBStU2sXHu0a/lMIX8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8686601C3;
        Fri, 13 Sep 2019 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568381872;
        bh=IISeWQxNAdCObwP9mJjaExic+PQ/4Av37VV7Ya2x/YM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Kf384DT0b91WwyV904MdaAgk3pq8OvtjEOKdoLdqIf/olHRzwCjgaZBUlJKimrrD5
         rucfghzCrEjencpdiisW0jbMVZpumk+kwmoNl/YUIPrni3J5n77r9Rtm4lm3cKoH+T
         sh/Evla47IOLKBw1t1+ocXNjpnhUMQ1z6rIN+CNQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8686601C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] brcmsmac: Remove unneeded variable and make function
 to be void
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1568306492-42998-2-git-send-email-zhongjiang@huawei.com>
References: <1568306492-42998-2-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913133752.BDA7760767@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 13:37:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> brcms_c_set_mac  do not need return value to cope with different
> cases. And change functon return type to void.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

I just don't see the benefit from changing the function to return void.
And if we ever add error handling to the function we need to change it
back to return int again, which is extra work.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11143403/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

