Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7169C254376
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgH0KRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:17:16 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35170 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgH0KRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:17:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598523433; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=c80iHXheaT4Iih1lDtWh1pQvvx2GTk94KRLwRisbnos=;
 b=wpUtxaohTDXPH1UYAn8PxmrCJ9gvlAU49ihvG2xYTWqutl3CLdzvz9CnRyQ/tfqx0oLH0psS
 U3smkzggMosIQv32HRHtQdCockuBW/ouScnmPSzSMDz/hROgMz5wz7XccxO0Xnda6SUCWMoV
 mtDmv/CdaxD2q4yYp/p2LKw+sHM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f478828d6f74c6f9c6f22c2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:17:12
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8072AC43395; Thu, 27 Aug 2020 10:17:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78506C433C6;
        Thu, 27 Aug 2020 10:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78506C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k_htc: Do not select MAC80211_LEDS by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200820120444.8809-1-krzk@kernel.org>
References: <20200820120444.8809-1-krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827101712.8072AC43395@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:17:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzk@kernel.org> wrote:

> The ath9k_htc driver hides all LEDs related code behind
> CONFIG_MAC80211_LEDS ifdefs so it does not really require the
> MAC80211_LEDS.  The code builds and works just fine.  Convert the
> "select" into "imply" to allow disabling LED trigger when not needed.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

197f466e93f5 ath9k_htc: Do not select MAC80211_LEDS by default

-- 
https://patchwork.kernel.org/patch/11726211/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

