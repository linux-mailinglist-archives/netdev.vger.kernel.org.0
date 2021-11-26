Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C893345F16A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378468AbhKZQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:16:47 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:43058 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378278AbhKZQOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:14:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637943088; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3NYCBWqAiK5Hots5hqmVzfRCq8EGSaOWThntRtiTkQE=;
 b=cKQyF7Q3isrTMT9gKsadKtyXwymb5RdHIRoVJHHsNNI6/w7hqWkowdTYWAJGhrdFdvlttjoz
 /dYp7TuB1PwqbOW+BEaGHYUZsBxBtjuJbM5MnY1IQhYxc/Y4x2QFnw8VuInG2b82mZa6JIiU
 A6Mn/wsrgoENIm3JexeigqgXvm4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 61a10723e7d68470afbe628f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Nov 2021 16:11:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 474C3C43617; Fri, 26 Nov 2021 16:11:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 555E5C4360D;
        Fri, 26 Nov 2021 16:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 555E5C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: remove unnecessary conditional operators
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211104061119.1685-1-ye.guojin@zte.com.cn>
References: <20211104061119.1685-1-ye.guojin@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163794306932.10370.10037406606556203153.kvalo@codeaurora.org>
Date:   Fri, 26 Nov 2021 16:11:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> The conditional operator is unnecessary while assigning values to the
> bool variables.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

1646ce8f83b9 rtw89: remove unnecessary conditional operators

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211104061119.1685-1-ye.guojin@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

