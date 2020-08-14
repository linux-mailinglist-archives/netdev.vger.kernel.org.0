Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7913A244B90
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgHNPFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:05:14 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48930 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgHNPFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 11:05:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597417510; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3h/en/nwSu152PeS5ycUKm35wp0er9Vci4CuflOQWT4=;
 b=RTlXT+ozSE/liZhC/OXSsbiyoyi83OIpK8LCYVuJ8CMquKQ2dBLz5q7u5dJkZqZlNKAGnU9C
 m16GSZdlE4SjFD3dkmPD03kP23v6r8+211k/a8uT7PSuw7th4eufhRoBc1aCIz7t+RcFFX57
 r6fLxcsIACFZzajdg54/iaOHW/Q=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f36a7f4d48d4625cae4255f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 15:04:20
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 78DB9C433CA; Fri, 14 Aug 2020 15:04:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AB20C433C6;
        Fri, 14 Aug 2020 15:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AB20C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath9k: Use fallthrough pseudo-keyword
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200727193520.GA832@embeddedor>
References: <20200727193520.GA832@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200814150419.78DB9C433CA@smtp.codeaurora.org>
Date:   Fri, 14 Aug 2020 15:04:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

221af8135478 ath9k: Use fallthrough pseudo-keyword

-- 
https://patchwork.kernel.org/patch/11687449/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

