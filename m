Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA553356B76
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351887AbhDGLnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:43:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:24750 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbhDGLnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 07:43:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617795789; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=6cE0lXvR26TFWenvq0+ejblQkOsFdPGRTeYd7qIvVUw=; b=kSV354WqJk7G7szj9bZbb5/Zbh7DeR1SfhCnVx7GmgJipxFDnNh5uSpxoi3neFYceWfli5uI
 +17YlM+cvYlfUwViTriYLNXqE6gaLVkKaG2YWH4TucrzeZacR+G9lCQltPG2GMZtCW5PU1nc
 lir5SswPP5nhZ3ObHkmmix64FgE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 606d9acb8166b7eff7f6e451 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 07 Apr 2021 11:43:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25F39C433CA; Wed,  7 Apr 2021 11:43:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6AA2FC433ED;
        Wed,  7 Apr 2021 11:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6AA2FC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] drivers: net: wireless: struct lbs_private is declared duplicately
References: <20210325064154.854245-1-wanjiabing@vivo.com>
Date:   Wed, 07 Apr 2021 14:43:02 +0300
In-Reply-To: <20210325064154.854245-1-wanjiabing@vivo.com> (Wan Jiabing's
        message of "Thu, 25 Mar 2021 14:41:51 +0800")
Message-ID: <87y2dumibd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wan Jiabing <wanjiabing@vivo.com> writes:

> struct lbs_private has been declared at 22nd line.
> Remove the duplicate.
>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/wireless/marvell/libertas/decl.h | 1 -
>  1 file changed, 1 deletion(-)

The prefix should be "libertas:", I can fix that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
