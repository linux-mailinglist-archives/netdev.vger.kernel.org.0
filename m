Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9201A80A1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405551AbgDNPCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:02:19 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:41415 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405536AbgDNPCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:02:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586876536; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tPh/QCtMa2WlnlM0NOjI2Yah/uXiqwQYCnR8HqRarxA=;
 b=mz5r71gfhapLKHTeO9mNf+D1DFBApC4Y2EFf4XXveTO3z2ZoGlH6vG5uDONEwmdsHHtfUV1q
 5qWFCs8aQb2JFoh2qjrsPgML+79Ce961jt7gyusIMMn3cXaCMwGhHHEkVx0fNU3TqhO5mWG7
 eCZ4v7edRq4U/kULRs6bct8zlGY=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d063.7fd03b06cbc8-smtp-out-n03;
 Tue, 14 Apr 2020 15:01:55 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A6D6BC433BA; Tue, 14 Apr 2020 15:01:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FE80C433F2;
        Tue, 14 Apr 2020 15:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FE80C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: Make two functions static
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200328030524.16032-1-yuehaibing@huawei.com>
References: <20200328030524.16032-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <yhchuang@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414150154.A6D6BC433BA@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:01:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fix sparse warnings:
> 
> drivers/net/wireless/realtek/rtw88/fw.c:633:4: warning:
>  symbol 'rtw_get_rsvd_page_probe_req_location' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/fw.c:650:5: warning:
>  symbol 'rtw_get_rsvd_page_probe_req_size' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

ca2c6881dcca rtw88: Make two functions static

-- 
https://patchwork.kernel.org/patch/11463395/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
