Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC47363177
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhDQR3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:29:18 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27042 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236754AbhDQR3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:29:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680529; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9B+ed2yAfZin/NRh+oXK+G5hMMOlh8rs7J2pliWucTg=;
 b=CaPI8mlb1pPyT9/af64e2NDKTrsPulWiJaZmXqj+bPplbKa7BMoLyxLeex54RGjqQ425+M5U
 8+9l7XDDd+fqb06/jeQg/AE28zWuVq8j3KsY3NBSD45hYFOIeE6MnI41+kJcT6vf5ifPI74/
 1hLWPzFJBJD8G7EwWYTiQyKZJYw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 607b1ad1e0e9c9a6b6b932f5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:28:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 06F80C433F1; Sat, 17 Apr 2021 17:28:49 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2714C433D3;
        Sat, 17 Apr 2021 17:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2714C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Few mundane typo fixes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210320194426.21621-1-unixbhaskar@gmail.com>
References: <20210320194426.21621-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417172849.06F80C433F1@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:28:49 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/resovle/resolve/
> s/broadcase/broadcast/
> s/sytem/system/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-drivers-next.git, thanks.

2377b1c49d48 rtlwifi: Few mundane typo fixes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210320194426.21621-1-unixbhaskar@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

