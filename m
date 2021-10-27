Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B2043C400
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbhJ0Hio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:38:44 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34768 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhJ0Hio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 03:38:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635320179; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DhgE9qd3mMClfnqgNcCoaossn7plN44yxoUK9BoXGJE=;
 b=aBlcULMUTp65Ch5+hGZkAgea42fuNO7mqsXogC7Agxeo9kweGdXcd7aNaDQb1fAr8Cw2V5oX
 G7sB+BkR0DgQvUklMlTiD+u/obbkGV+gGQ6IL9zMfpj0OShY2EFK3kCxD2oFGV572vbBjcxl
 5vJCt1g0V7KI8VsDzuJus2oaFYE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6179016b308e0dd33018f490 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:36:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A19C8C43616; Wed, 27 Oct 2021 07:36:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10675C43460;
        Wed, 27 Oct 2021 07:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 10675C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] rtw89: fix error function parameter
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211021042035.1042463-1-lv.ruyi@zte.com.cn>
References: <20211021042035.1042463-1-lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163532016426.30745.11685925568812414606.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:36:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> This patch fixes the following Coccinelle warning:
> drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
> WARNING  possible condition with no effect (if == else)
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

dea857700a75 rtw89: fix error function parameter

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211021042035.1042463-1-lv.ruyi@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

