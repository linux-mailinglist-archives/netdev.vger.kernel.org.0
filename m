Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABF254506
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 14:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgH0Med (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 08:34:33 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:55353 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbgH0M2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 08:28:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598531279; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cO//0luWVCYAyHjVHMw1ITNwOBiEMsNJEDqCuv4b1+A=;
 b=KMqhlbcwRJAxKeKRH+X1KdWcHjHB+LUOVUkwt7ipyHI4u9NxMwB4ftgpbpyDZWs21s9x6ZWX
 aqIrAUgJrohCfxR6LNmjZr9PBPTlNmnFH6x9MMrunm+CQ+BnY/cf5MjkKmyl+emSnVUhZmAp
 ovN406/Cvuo+KDsTWgZLcDDeKYU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f47a422c598aced545ad7ca (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 12:16:34
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 47F55C43387; Thu, 27 Aug 2020 12:16:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05A78C433CA;
        Thu, 27 Aug 2020 12:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05A78C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/30] atmel: Demote non-kerneldoc
 header to standard comment block
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200814113933.1903438-6-lee.jones@linaro.org>
References: <20200814113933.1903438-6-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827121634.47F55C43387@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 12:16:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/atmel/atmel.c:4232: warning: Cannot understand     This file is part of net.russotto.AtmelMACFW, hereto referred to
> 
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

14 patches applied to wireless-drivers-next.git, thanks.

68fd3030ad67 atmel: Demote non-kerneldoc header to standard comment block
64847777d05a b43: main: Add braces around empty statements
0b6a4247dea7 airo: Place brackets around empty statement
ba4d65132922 airo: Fix a myriad of coding style issues
0171c6185c8f iwlegacy: common: Remove set but not used variable 'len'
9bafe8b82306 iwlegacy: common: Demote kerneldoc headers to standard comment blocks
b2e732081f19 ipw2200: Remove set but unused variables 'rc' and 'w'
6214ef8a532f b43legacy: main: Provide braces around empty 'if' body
10c3ba7dbe6e brcmfmac: fweh: Remove set but unused variable 'err'
4e124e1fee6d brcmfmac: fweh: Fix docrot related function documentation issues
7eae8c732977 brcmsmac: mac80211_if: Demote a few non-conformant kerneldoc headers
5f442fe435e1 ipw2200: Demote lots of nonconformant kerneldoc comments
c171304b42f9 b43: phy_common: Demote non-conformant kerneldoc header
5ae6c8a696cd b43: phy_n: Add empty braces around empty statements

-- 
https://patchwork.kernel.org/patch/11714411/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

