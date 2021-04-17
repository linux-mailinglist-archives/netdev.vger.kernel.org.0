Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56DD363168
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhDQR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:26:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:16427 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhDQR01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:26:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680360; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rdsVSi0Yg452Dis6l+Ovk5pDPR6mja7YfBEvMZBIArg=;
 b=LoXrmlMAAYnrxOJv7CIe/XApWurn0ihqlOderGPtDWMTJxpiiKESRozQ2Fa3GhAk221fHVKP
 brV5avW37o8TOxiRZAM8ZuzKxhZB4yBtCUKN6rVbgg940Exj+SmkrbYlfzuadIhVoUU0JjVo
 0OmLxO5h2tYg9fRbNOt7dFrUcKA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 607b1a19f34440a9d41dbd70 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:25:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E29B6C43217; Sat, 17 Apr 2021 17:25:45 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB6F6C433D3;
        Sat, 17 Apr 2021 17:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB6F6C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: Remove unused function pointer typedef
 cw1200_wsm_handler
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1613446918-4532-1-git-send-email-chen45464546@163.com>
References: <1613446918-4532-1-git-send-email-chen45464546@163.com>
To:     Chen Lin <chen45464546@163.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417172545.E29B6C43217@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:25:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chen Lin <chen45464546@163.com> wrote:

> From: Chen Lin <chen.lin5@zte.com.cn>
> 
> Remove the 'cw1200_wsm_handler' typedef as it is not used.
> 
> Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>

Patch applied to wireless-drivers-next.git, thanks.

1c22233a745e cw1200: Remove unused function pointer typedef cw1200_wsm_handler

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1613446918-4532-1-git-send-email-chen45464546@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

