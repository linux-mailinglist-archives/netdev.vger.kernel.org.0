Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F31A2724CB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgIUNLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:11:33 -0400
Received: from z5.mailgun.us ([104.130.96.5]:18156 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgIUNLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:11:31 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 09:11:29 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600693891; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=dvQ8g8G8ZMC0OoVSWlQmLxd3GM1eXbe/mOTaf9do3QU=;
 b=YYW/fxR8B5LXk8DbYr2iowL7qvLPpSzMMGBs3KmIOoGTt8SWP3HtBbOI7V55QeO00V1OeFP3
 6QuWnDi98tZ5qIedVOYbgRGWnkOIPupbr3paCZyIY13PRJBd+8Zs9nNdLSTzvGM21XuFwmzI
 jBu4M+khIYrZIcB734xrygfb3VM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f68a4650915d303570f5e3c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Sep 2020 13:02:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7C1E1C433CB; Mon, 21 Sep 2020 13:02:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5804BC433F1;
        Mon, 21 Sep 2020 13:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5804BC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] net: wilc1000: clean up resource in error path of
 init
 mon interface
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200917123019.206382-1-huangguobin4@huawei.com>
References: <20200917123019.206382-1-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200921130228.7C1E1C433CB@smtp.codeaurora.org>
Date:   Mon, 21 Sep 2020 13:02:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huang Guobin <huangguobin4@huawei.com> wrote:

> The wilc_wfi_init_mon_int() forgets to clean up resource when
> register_netdevice() failed. Add the missed call to fix it.
> And the return value of netdev_priv can't be NULL, so remove
> the unnecessary error handling.
> 
> Fixes: 588713006ea4 ("staging: wilc1000: avoid the use of 'wilc_wfi_mon' static variable")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

55bd14997867 net: wilc1000: clean up resource in error path of init mon interface

-- 
https://patchwork.kernel.org/patch/11782369/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

