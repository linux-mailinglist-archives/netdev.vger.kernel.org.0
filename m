Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F336A2F67A5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbhANR2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:28:35 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:14664 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhANR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:28:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645294; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=bHHR9zvk8PibWeZhwAITGVuvtMDjsIYQN1khDTB4p34=;
 b=jy9FHEHV6wv8ZVCO4Hr+HEGU6M5PsrIzwtq57rt7jqeXreNTl4XeJyPTU5BMX4X0b5V1Tb//
 v9gR0ExX6OXVzwrvbFnHKXyiGCr3S2XeMD3PpGQWOr8UhmQGqiISWVoDsONA4/HXoT0qsOu3
 Wqf6YIZAwD+qSLzAKKwIAJ0/GSc=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60007f12c88af06107f4adbb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:27:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B0F1C43463; Thu, 14 Jan 2021 17:27:46 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8ADDCC433C6;
        Thu, 14 Jan 2021 17:27:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8ADDCC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: Simplify bool comparison
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1610445040-23599-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610445040-23599-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pkshih@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114172746.0B0F1C43463@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:27:46 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YANG LI <abaci-bugfix@linux.alibaba.com> wrote:

> Fix the following coccicheck warning:
>  ./drivers/net/wireless/realtek/rtw88/debug.c:800:17-23: WARNING:
> Comparison of 0/1 to bool variable
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>

Patch applied to wireless-drivers-next.git, thanks.

d3a78c7a9daa rtw88: Simplify bool comparison

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1610445040-23599-1-git-send-email-abaci-bugfix@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

