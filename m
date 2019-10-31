Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEDEAB6D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfJaIPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:15:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfJaIPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:15:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBB8C60540; Thu, 31 Oct 2019 08:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509739;
        bh=sp/YuXqKxRq6BSEULbjzuuxJCs1WunIjmlNVKfVpHes=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ijtel4EshkgBpjFvlxbBWbrsq99aKVFA9ocGJUpdzSAELVKxJ18sE7KH4Q+7aV/1b
         M1jK+pCdu/Mj7APEE21LMra4oiJ43nL0fqIMKb/k/1ubyb3muaMokN7m4GzQalxkwU
         D+pp5Sp1Y4jvQQeFWQTJ2u69BQADe37ENL9utD/U=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BEB8860540;
        Thu, 31 Oct 2019 08:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509739;
        bh=sp/YuXqKxRq6BSEULbjzuuxJCs1WunIjmlNVKfVpHes=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KFKcnpd4XBYxIcUmwPGE6RZ1tg+eZBxF6Dtqgwrmo7hQePpVg+sIndWrFmx6Zdq4l
         2dt/+9m/mJS53yskmVY1pk84HKYXeINz9KW8cRDwflQkvx9vuepmLpWnTKukZlau7R
         BMjCc4KC6cpdfXyCZaP7KxuVAIZcJ9MJ3PMfY+o0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BEB8860540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove unneeded semicolon
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191025091041.34056-1-yuehaibing@huawei.com>
References: <20191025091041.34056-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031081539.EBB8C60540@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:15:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> remove unneeded semicolon.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0dc269314a25 ath10k: remove unneeded semicolon

-- 
https://patchwork.kernel.org/patch/11211787/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

