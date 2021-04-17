Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC23631A3
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbhDQRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:52:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22332 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236759AbhDQRw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:52:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618681921; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ta9UOrBNX6nF/ayPWAdJWmH7jGA1eFoW7NL2pCPKvxc=;
 b=AGhiJt8q0Sq6nhO2pB5HEVJhLuH7OTGU2ykCOPwtDJZR6o03pXpuOH87W23GwELcALRp4BjW
 NmuGuLS0Hp458VZ+w9f6GbtXT0S51LtRIi8wfRjmboS2Cj1RwkHK1DsW6qlVqLMH+1KVdMQg
 QKcwBtM2wYfkRu3oOq7qNSJYUQM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 607b2041febcffa80f340dac (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:52:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D865C4338A; Sat, 17 Apr 2021 17:52:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1A1DC433D3;
        Sat, 17 Apr 2021 17:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1A1DC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210305094850.GA141221@embeddedor>
References: <20210305094850.GA141221@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417175201.4D865C4338A@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:52:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> multiple warnings by replacing /* fall through */ comments with
> the new pseudo-keyword macro fallthrough; instead of letting the
> code fall through to the next case.
> 
> Notice that Clang doesn't recognize /* fall through */ comments as
> implicit fall-through markings.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

bf3365a856a1 rtl8xxxu: Fix fall-through warnings for Clang

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210305094850.GA141221@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

