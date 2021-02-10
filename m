Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8794D31602C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhBJHlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:41:12 -0500
Received: from so15.mailgun.net ([198.61.254.15]:32628 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232663AbhBJHlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 02:41:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612942843; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=TBoQmkGR+QC+EUva87HXVja6pfE3GqjGdJUjql6FO9g=;
 b=xAlFyNG7zZT0NDZ5UDFUigs2dBfNgSnlBelFEnL7wnHy1CLejmyXmV/fACtf8lD2spDYf+GV
 ak8bCOHNjimkpzf+dUUQT4tGcjkdaGskxYipAa/LPHRY+ZCQo2sq24YhCLNnVoMMdScFTWIq
 464qqdKrQ2cSkSge6+urRSoVVP4=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60238dd534db06ef79d7506b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 07:40:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37AF6C43466; Wed, 10 Feb 2021 07:40:05 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E936CC43462;
        Wed, 10 Feb 2021 07:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E936CC43462
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: phy: Simplify bool comparison
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1612840381-109714-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1612840381-109714-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210210074005.37AF6C43466@smtp.codeaurora.org>
Date:   Wed, 10 Feb 2021 07:40:05 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3853:7-17:
> WARNING: Comparison of 0/1 to bool variable.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Patch applied to wireless-drivers-next.git, thanks.

8e79106a7dbb rtlwifi: rtl8821ae: phy: Simplify bool comparison

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1612840381-109714-1-git-send-email-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

