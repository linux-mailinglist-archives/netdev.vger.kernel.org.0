Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB03F3BE4
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 19:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhHURrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 13:47:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60803 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhHURrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 13:47:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629567999; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zh7M6tGCFqM6IEeHN75gJSGLSSseSGTK6cPWrEZFAiY=;
 b=t0OhQx3vmARVujEX/v6+mHxz1DTZb09s7HgKGHmWDyKqZKCF/+3Sa4BZcstK32ktrmWiU4Re
 57BE2JKpAZ8jJtL6Q6Oh8HiK3lFZ2Em1+96nWO7CFL3BOmQiRVdem1/Izh9dUAw0074pkbor
 pB0+7WLZXBd1i9WSzCn+1m4Gh1I=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 61213bff0f9b337f11e29891 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 17:46:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE9B2C43617; Sat, 21 Aug 2021 17:46:38 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D8B9DC43460;
        Sat, 21 Aug 2021 17:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D8B9DC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: remove redundant code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210705023731.31496-1-samirweng1979@163.com>
References: <20210705023731.31496-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821174638.DE9B2C43617@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 17:46:38 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Some of the code is redundant, so goto statements are used to remove them
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

8f86342872e2 wilc1000: remove redundant code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210705023731.31496-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

