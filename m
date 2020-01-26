Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04240149B97
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAZPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:47:01 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:58800 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727278AbgAZPrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:47:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053620; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6K6q92AgwnobPlKSJlllc58m97iM/A4gY8+1vc3QOBQ=;
 b=p90wxP54fBJVtmuMyvM+zYT5HWXfn70MLMTkLJEUV2AxyhdAYDnSTEtdssPpvssRDLd5YwLv
 XgdFsfrLTe5fQ7HLXdVJt1pBtAjMrBF6EmwElSGiUIWrT1+dRtPtxR6jPntuN5acX5s6LmR0
 tYjZVJsAopJNUQNsdghkjF980nY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db473.7fed1e955c00-smtp-out-n03;
 Sun, 26 Jan 2020 15:46:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50D55C433A2; Sun, 26 Jan 2020 15:46:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35AB7C43383;
        Sun, 26 Jan 2020 15:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35AB7C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192ee: remove unused variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200121021924.18792-1-yuehaibing@huawei.com>
References: <20200121021924.18792-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154659.50D55C433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:46:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:15:18:
>  warning: ofdmswing_table defined but not used [-Wunused-const-variable=]
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:61:17:
>  warning: cckswing_table_ch1ch13 defined but not used [-Wunused-const-variable=]
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:97:17:
>  warning: cckswing_table_ch14 defined but not used [-Wunused-const-variable=]
> 
> These variable is never used, so remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

253e5aba9379 rtlwifi: rtl8192ee: remove unused variables

-- 
https://patchwork.kernel.org/patch/11343039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
