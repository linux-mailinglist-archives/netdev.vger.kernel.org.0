Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C68B25438F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgH0KTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:19:00 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12001 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgH0KS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:18:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598523536; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=O1yb9CSKQrFoe2ODbA0e1W1uXo9WoLV9K1vJi4o+yTQ=;
 b=vyeYO4gt1rXPMyqm2yrpfPU3g0n+rJQFxA2TvH89ktauVsVsamb+g4wgdDAkCi8yyIjv8xUN
 nHUCUubFeE4qxGQes2P0S666Mpx0kIphlt3BOoBQyFkdBEhOmZm0Lxqdk3v8ZTCJ88r4rLb1
 WKSyb5S8jPi0qTo6m9i51y5p1yA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f478870c9ede11f5e78d9c9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:18:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E61BEC4339C; Thu, 27 Aug 2020 10:18:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDFC9C43387;
        Thu, 27 Aug 2020 10:18:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BDFC9C43387
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Do not select MAC80211_LEDS by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200820194049.28055-1-krzk@kernel.org>
References: <20200820194049.28055-1-krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827101823.E61BEC4339C@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:18:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzk@kernel.org> wrote:

> The ath9k driver hides all LEDs related code behind CONFIG_MAC80211_LEDS
> ifdefs so it does not really require the MAC80211_LEDS.  The code builds
> fine.  Convert the "select" into "imply" to allow disabling LED trigger
> when not needed.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

72cdab808714 ath9k: Do not select MAC80211_LEDS by default

-- 
https://patchwork.kernel.org/patch/11727077/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

