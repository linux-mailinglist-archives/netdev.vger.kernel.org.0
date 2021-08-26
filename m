Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6419B3F8C49
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbhHZQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:35:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21777 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhHZQfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 12:35:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629995683; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RUzgoB5Wzejq4UjttdL32gI6WODI4MFawRGmvOvlL7A=; b=s8ncQiMY+MgDRkAO8CUQ+cevbSsXDnzbJLa1zFdkJ8SZ7vk+7GNn/n2taU6c50VBW/y36NY5
 JHpYVREv2JtM0zWLDWb2cJPEva6+0mRF5hQV6NU34tc346xbJjqbz/NydW/cd6q6VqK59tt8
 j8McssgXB2Un0uZnVeU42Sa54J8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6127c2a2d6653df767c3ec4f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 26 Aug 2021 16:34:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D3CFCC4360C; Thu, 26 Aug 2021 16:34:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF4F2C43460;
        Thu, 26 Aug 2021 16:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CF4F2C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ath11k@lists.infradead.org, regressions@lists.linux.dev,
        hemantk@codeaurora.org, nschichan@freebox.fr,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH] qrtr: mhi: Fix duplicate channel start
References: <1629992163-6252-1-git-send-email-loic.poulain@linaro.org>
Date:   Thu, 26 Aug 2021 19:34:32 +0300
In-Reply-To: <1629992163-6252-1-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Thu, 26 Aug 2021 17:36:03 +0200")
Message-ID: <87a6l46u7b.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

> commit ce78ffa3ef16 ("net: really fix the build...") handling a merge
> conflict causes the mhi_prepare_for_transfer() function to be called
> twice (with different flags), leading to QRTR probing issues.
>
> Fixes: ce78ffa3ef16 ("net: really fix the build...")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Thanks for the patch, but with this patch the whole kernel crashes. I
tested on a NUC box with QCA6390 using v5.14-rc7. Unfortunately no
netconsole at the moment as I'm moving my workstations.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
