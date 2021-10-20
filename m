Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD74434755
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhJTIxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:53:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:25192 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhJTIxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:53:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719884; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Kh8K90NEk3HNRlFs+h3zNDOH25/j+3+fAnWVhyR1v1g=;
 b=Kg4eB+zIg7v5miaBuLVwO+YOL4y8KMm5TPdL6UUHf7+TYBqLOA7tCAFWCIn2EuhOlkpnWJof
 yqyE0iM6DO30R0lBOeRtXLzYe452Xsnk16u6w3rIQUf7hsLlzPG/ySZSLvYYAnhfp67Cy9/1
 zbxVY4JZz7gEY+Uh/wz8bbuQA54=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 616fd876308e0dd330b635e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:51:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F6AEC4360C; Wed, 20 Oct 2021 08:51:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 535C2C4338F;
        Wed, 20 Oct 2021 08:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 535C2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] rtw89: remove unneeded semicolon
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634630094-1156-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1634630094-1156-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pkshih@realtek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163471985733.1743.6821016810480036328.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:51:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtw89/pci.c:1348:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

e0e037b9fe5f rtw89: remove unneeded semicolon

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634630094-1156-1-git-send-email-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

