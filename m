Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B22194763
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgCZTYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:24:15 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:33290 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbgCZTYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:24:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585250654; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=BMGoGHSXOZ233X67YkN/RH91FjPrQ4uEb9ABNdJUj+I=;
 b=N4P2EUYlLeCLHvNLoX6nMMrUHjVpr/puSt+q3D3Wv/TOGGNVeVRW0suSvOaG8XV4aFP/79tH
 piWuNiBeOf2Wfh0P7WkrIuX2Mv+kCLxVX2xazNeT9j8mMZq4JyBekSHPNu7jqZCIM3kTM2VG
 kVJ1zTWe2EJmJJQWL/NwEoz91EY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7d0150.7f7026ef9e68-smtp-out-n04;
 Thu, 26 Mar 2020 19:24:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 21025C433BA; Thu, 26 Mar 2020 19:24:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B7A75C433D2;
        Thu, 26 Mar 2020 19:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B7A75C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] hostap: convert to struct proc_ops
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200326032432.20384-1-yuehaibing@huawei.com>
References: <20200326032432.20384-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <j@w1.fi>, <davem@davemloft.net>, <yuehaibing@huawei.com>,
        <andriy.shevchenko@linux.intel.com>, <sfr@canb.auug.org.au>,
        <akpm@linux-foundation.org>, <adobriyan@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200326192400.21025C433BA@smtp.codeaurora.org>
Date:   Thu, 26 Mar 2020 19:24:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> commit 97a32539b956 ("proc: convert everything to "struct proc_ops"")
> forget do this convering for prism2_download_aux_dump_proc_fops.
> 
> Fixes: 97a32539b956 ("proc: convert everything to "struct proc_ops"")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

3af4da165f48 hostap: convert to struct proc_ops

-- 
https://patchwork.kernel.org/patch/11459139/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
