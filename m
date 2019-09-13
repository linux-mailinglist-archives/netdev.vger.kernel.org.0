Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8056B21CB
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbfIMOU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:20:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfIMOU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:20:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E297360767; Fri, 13 Sep 2019 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384424;
        bh=SAShVU3cg4kjywNYAt7pKciptCpXufeKkrQJMy1mPa8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Iogji4XO3mbNTK32q4D4/esmb6Vhsxq5yp5+u396vfkSihudz8gJtquOfmM7XopVD
         fiYLp2Rx17FWwjrgY7oM/5Km3ehIW8cbXLugTEYoPxvdsEPnVm4vTdwob5qNmYdgHK
         K98RFjKmpLfjZ9bzOvbCikv5VpeTdDSzJcTBrGtc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 102C1602EE;
        Fri, 13 Sep 2019 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384424;
        bh=SAShVU3cg4kjywNYAt7pKciptCpXufeKkrQJMy1mPa8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ifV51aP/DalYVwZ0paErOcsj7IYtPXIvU6ZTf9vg8ODEwcgGIckgdqurkwHsbt+95
         5//khtFQ2FmdHPBZ6H7dhxiAFBa9cJKJuplZ3apPRCSbu+1XQH0ibuhkhxRoaCr3iX
         GOlgjVHs13GFHKWOtruhnO4iQDd185PxxpajncNo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 102C1602EE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: Use DIV_ROUND_CLOSEST directly to make it
 readable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567700648-28162-1-git-send-email-zhongjiang@huawei.com>
References: <1567700648-28162-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913142024.E297360767@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 14:20:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

3dfb22003f98 brcmsmac: Use DIV_ROUND_CLOSEST directly to make it readable

-- 
https://patchwork.kernel.org/patch/11133663/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

