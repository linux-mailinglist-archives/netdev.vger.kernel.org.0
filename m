Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32E31BB994
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgD1JMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:12:10 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:32668 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgD1JMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:12:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588065128; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fn3H9mKpXT3A+/rYhDOKxcNKIcrs2URjyh96Pk02sMs=;
 b=F160waBxGd3PS4MIQqltmCmyABpffYan5ujZdK7mSUmxbVsUfs5HSZO478FVmpCs+yGRWUwj
 Mzz6egGLb8mM0UprTn5fRMbxhGRdug7gPut7YAkfYpNPGxT2yDo23KkkVvstu9tmy/udu60H
 LTmDiRvHIlkeQAdD7ZHTHHwdOt8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea7f363.7ff444887688-smtp-out-n02;
 Tue, 28 Apr 2020 09:12:03 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DF782C43636; Tue, 28 Apr 2020 09:12:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3552DC433D2;
        Tue, 28 Apr 2020 09:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3552DC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath5k: remove conversion to bool in
 ath5k_ani_calibration()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200426094037.23048-1-yanaijie@huawei.com>
References: <20200426094037.23048-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <jirislaby@gmail.com>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200428091201.DF782C43636@smtp.codeaurora.org>
Date:   Tue, 28 Apr 2020 09:12:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> The '>' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> drivers/net/wireless/ath/ath5k/ani.c:504:56-61: WARNING: conversion to
> bool not needed here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c26b01d5ec1a ath5k: remove conversion to bool in ath5k_ani_calibration()

-- 
https://patchwork.kernel.org/patch/11510327/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
