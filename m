Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E043DC17
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJ1Hf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:35:59 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:20812 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJ1Hfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:35:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635406409; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=F+z+0dB7BGOziQgInGvVCwFNwMPov/p7cow2cb6xehI=;
 b=q1NAeaHJoODnndvln2JqpHTs/5gFfyJFk+S6Pu5RjxoGBdFcOfXeU5hrQQbdvvAHX/b7fFIu
 pMDpUNQxKpMDUMuvTYyP+im4f2gbwH2C5+atmeL2y6YH+3T5PE9o2rTwONnawMpoDrwiVsUL
 IM06CyFvNWxvN/vfJr2LyUKC1UI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 617a523a545d7d365f99cad0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 07:33:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 95E73C43460; Thu, 28 Oct 2021 07:33:13 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4C7E0C4338F;
        Thu, 28 Oct 2021 07:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4C7E0C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] ath10k: fix control-message timeout
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211025120522.6045-2-johan@kernel.org>
References: <20211025120522.6045-2-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163540638853.24978.12157539503424520256.kvalo@codeaurora.org>
Date:   Thu, 28 Oct 2021 07:33:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> wrote:

> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.
> 
> Fixes: 4db66499df91 ("ath10k: add initial USB support")
> Cc: stable@vger.kernel.org      # 4.14
> Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

528613232423 ath10k: fix control-message timeout
a066d28a7e72 ath6kl: fix control-message timeout

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211025120522.6045-2-johan@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

