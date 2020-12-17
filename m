Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A602DCCAC
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 07:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgLQGqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 01:46:48 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:36179 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgLQGqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 01:46:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608187582; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4R3W6tc73OQ6y5EIJtBFGS1g5BY1uxW8ec6ZCFvffH0=;
 b=N2f2vC9W9+lUCKMUy1N/gCJQzlE4GtMU/ZODILHv0xMtUfAIhbaBoGqGqeJ3q4Il/FJr5H6C
 qLNGEpFrwsHmB2Rze6CGFfWd+HlaaAjC3uqZzTxSO8/QbHyOx1uCWV5j+1ahUkeKjvLubBrU
 GLM2QDRYISHzVoomVjfg/Lf7NZI=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fdafe973d3433393d39d8e9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Dec 2020 06:45:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EEE98C433C6; Thu, 17 Dec 2020 06:45:42 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 27134C433C6;
        Thu, 17 Dec 2020 06:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 27134C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: add missing null check on allocated skb
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201214232417.84556-1-colin.king@canonical.com>
References: <20201214232417.84556-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201217064542.EEE98C433C6@smtp.codeaurora.org>
Date:   Thu, 17 Dec 2020 06:45:42 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Currently the null check on a newly allocated skb is missing and
> this can lead to a null pointer dereference is the allocation fails.
> Fix this by adding a null check and returning -ENOMEM.
> 
> Addresses-Coverity: ("Dereference null return")
> Fixes: 43ed15e1ee01 ("ath11k: put hw to DBS using WMI_PDEV_SET_HW_MODE_CMDID")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

292bff9480c8 ath11k: add missing null check on allocated skb

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201214232417.84556-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

