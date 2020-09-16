Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F386926BC2F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIPGI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:08:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48380 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgIPGIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:08:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236500; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sACAp3XOdkGTgtb5Bx1apDUtcLqnVpEZFqB5s5mEvLQ=;
 b=rzFUWUgKc3tF7dggk/OOt+lXlkxI4CyeMExPhNc9qOFXz2GaD86Qm8CXTQkgC4bNCLXJGjdh
 EXVf3JpirmlqllhfwV1chvNz6GfekpTJyv9s7EUUvy8lKC4e8xerNnwN7lPIPj1a8LGR8qtL
 Av8zwuPjXgcrD/0lHckOGvep8SY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f61abc8947f606f7e86de7f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:08:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D5CACC43382; Wed, 16 Sep 2020 06:08:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0F37C433F1;
        Wed, 16 Sep 2020 06:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0F37C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Remove unused macro WL1271_SUSPEND_SLEEP
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909135905.35728-1-yuehaibing@huawei.com>
References: <20200909135905.35728-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060807.D5CACC43382@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:08:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> commit 45aa7f071b06 ("wlcore: Use generic runtime pm calls for wowlan elp configuration")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d06e2f8b41b6 wlcore: Remove unused macro WL1271_SUSPEND_SLEEP

-- 
https://patchwork.kernel.org/patch/11765701/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

