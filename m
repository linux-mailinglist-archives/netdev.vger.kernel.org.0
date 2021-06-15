Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15D3A81BA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFOOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:06:32 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60310 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhFOOG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:06:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623765865; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6gTr9j1nBUFiHxj5nPNVd48BotsR10twO1JUZtyLItc=;
 b=d0O6XkOoGvwLZvJXGcgnE9k+oAOBXlpeXva0MlFOznGbJer8o2Pi9m01BlgbnM/Et5/blyPt
 NLIUkcjZq3JrhRUWOG5DUG+/ljOTOTv8N+sUR+3CGBVrg7TSTikFz4Xr57PKnTCR9sqO6PXz
 CA1UrGgpiUgGCCKhjRmD7D9gpxU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60c8b333e570c05619f746cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 14:03:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 14CBDC4338A; Tue, 15 Jun 2021 14:03:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2D690C4338A;
        Tue, 15 Jun 2021 14:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2D690C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix an error code in ath10k_add_interface()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615140331.14CBDC4338A@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 14:03:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> When the code execute this if statement, the value of ret is 0.
> However, we can see from the ath10k_warn() log that the value of
> ret should be -EINVAL.
> 
> Clean up smatch warning:
> 
> drivers/net/wireless/ath/ath10k/mac.c:5596 ath10k_add_interface() warn:
> missing error code 'ret'
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: ccec9038c721 ("ath10k: enable raw encap mode and software crypto engine")
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e9ca70c735ce ath10k: Fix an error code in ath10k_add_interface()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

