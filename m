Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF59302657
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 15:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbhAYOdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:33:00 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:57996 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729469AbhAYObc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:31:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611585069; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=WIm37k0ByHb05TgsSjKkGlgy9s/AveqlMwkdHtOxQkE=;
 b=xIeUwjwqBkUB1u702Pzeu9GE/W2HHkLCIfusubeWfMpl4IeAHSX76OewWtpsuf91RnTzuWxG
 lCzJVxiO+XzCENn17/v+FWi/E1NsSM0+LoR49STsws+y/d+vdJ77tc0qhyWJGJPvonJgI1Z5
 hu3quoF1iBPe+qVXg3h2hQ5k3Dc=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 600ed606ad4c9e395bf69ead (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 14:30:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 10EA1C43464; Mon, 25 Jan 2021 14:30:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA8B0C433C6;
        Mon, 25 Jan 2021 14:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA8B0C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: style: Simplify bool comparison
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210125143030.10EA1C43464@smtp.codeaurora.org>
Date:   Mon, 25 Jan 2021 14:30:30 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YANG LI <abaci-bugfix@linux.alibaba.com> wrote:

> Fix the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3853:7-17:
> WARNING: Comparison of 0/1 to bool variable
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>

Patchwork gives me this From field:

From: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

I guess you are sharing the same email address with multiple persons? And patchwork stored the first person using that address?

I recommend using individual addresses for each person submitting patches. I
cannot apply this.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

