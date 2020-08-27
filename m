Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0743C2547EE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgH0O4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:56:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15270 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgH0NHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 09:07:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598533655; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=YwItAccWmflQBD2PFZmmyjOg3acFRGH83XjRuhRAIw0=;
 b=NHinOWcVimACWtaCUwg9p+SzRGnlJqv1IXAh3SH3z3DY6NdW9KRGixyMBrGdF0+mqcGzilyr
 l/T8mdpuZCDKYRPsZQax3xFenz87mvqtrqQ7f6JlIqG8leQ/TalkHTLJ20AMOko5zo0FYJUO
 mLvarzPkZAoP7b7vCHgN/kAO8A0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f47afff91574590bf5cbec4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 13:07:11
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 41C96C433CB; Thu, 27 Aug 2020 13:07:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7DD87C433CA;
        Thu, 27 Aug 2020 13:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7DD87C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] orinoco: Use fallthrough pseudo-keyword
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200821063402.GA12500@embeddedor>
References: <20200821063402.GA12500@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827130711.41C96C433CB@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 13:07:11 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

07a297a9e619 orinoco: Use fallthrough pseudo-keyword

-- 
https://patchwork.kernel.org/patch/11728217/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

