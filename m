Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F243DC0C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJ1Hep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:34:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49454 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJ1Heo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:34:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635406338; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=vDZFU7aNoLVPwXqLYBWvaxkPdbRXXeyxXXfWbZBdcJ8=;
 b=UgjT1h5OKqQZ1XwqqzDv9cpWqznPDJKhwe5m4QSnzjJuUJ8Jizr5bJXQWZhFuQHf9nLmGec4
 3kUre7rJdIS5/vwYoro3ECu+9qLF0XRskPEdV0D/Yy/tCf6KyECk+R1IEYYWdNgb0GIgtiwc
 sufgu8rT9RPzXaG9r1xnbLLUg64=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 617a5201900d71ea1ec9a357 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 07:32:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6209C43618; Thu, 28 Oct 2021 07:32:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BECDEC4338F;
        Thu, 28 Oct 2021 07:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org BECDEC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] wcn36xx: switch on antenna diversity feature bit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211025175359.3591048-2-benl@squareup.com>
References: <20211025175359.3591048-2-benl@squareup.com>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163540633052.24978.17040826925100086760.kvalo@codeaurora.org>
Date:   Thu, 28 Oct 2021 07:32:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> wrote:

> The official feature-complete WCN3680B driver (known as prima, open source
> but not upstream) sends this feature bit.
> 
> As we wish to support the antenna diversity feature in upstream, we need
> to set this bit as well.
> 
> Signed-off-by: Benjamin Li <benl@squareup.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

d8e12f315f81 wcn36xx: switch on antenna diversity feature bit
c9a4f2dd4cb2 wcn36xx: add missing 5GHz channels 136 and 144

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211025175359.3591048-2-benl@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

