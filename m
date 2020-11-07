Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB94C2AA4AB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgKGLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:32:26 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:41417 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgKGLc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:32:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604748745; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3OaIpUUxN0+eoHMI2OrY6Na1JgZTiFUtOu3vTjDOwBA=;
 b=UTL7Iy5+62oV23NnkV4Eu5jcQf7lyubJ2LI0QMoAUUvWhnGWP/lNfLuDVPaW9SsmoexGspuQ
 C4yvk8rjR9WlYURcQhbXTJTfCxL/MUJ4CncyFQxZS/MmsXVHve+eui4uLIHbNMkD8NxefT9f
 8CwcW1gkv9GoQq/EmLzVPfwQh/M=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fa6857f7e36360900add950 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:31:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 615AEC433C8; Sat,  7 Nov 2020 11:31:11 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3276BC433C8;
        Sat,  7 Nov 2020 11:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3276BC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wlcore: Use fallthrough pseudo-keyword
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201008220905.GA8040@embeddedor>
References: <20201008220905.GA8040@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107113111.615AEC433C8@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:31:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> In order to enable -Wimplicit-fallthrough for Clang[1], replace the
> existing /* fall-through */ comments with the new pseudo-keyword
> macro fallthrough[2].
> 
> [1] https://git.kernel.org/linus/e2079e93f562c7f7a030eb7642017ee5eabaaa10
> [2] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

a821e3858e4d wlcore: Use fallthrough pseudo-keyword

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201008220905.GA8040@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

