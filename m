Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155BD399D79
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFCJLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:11:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52200 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229754AbhFCJLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 05:11:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622711396; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: To: From: Sender;
 bh=w/uBArqcYzdvIcjLuSE7by2MocnAfbheaiDs8sW6/Nk=; b=R54r4LNAviJBnKViw4D56/p77z6xbcfS0hZp6UjOc5ecVhI9AZ9WqWbe+StMhnXAoexLAjx9
 qtPJvvzaXhhFP89pqdh+8j1FosMnHTr/q2Ja3x/1FNwRkssoZUEfHJAaunyNnIQlN/Nubpfo
 cBQ/BrctEWT7oGD4qU6mwkCNVT0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60b89c64e570c05619760349 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Jun 2021 09:09:56
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF418C433D3; Thu,  3 Jun 2021 09:09:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D1BB5C4338A;
        Thu,  3 Jun 2021 09:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D1BB5C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2021-06-03
References: <20210603090042.A5823C433F1@smtp.codeaurora.org>
Date:   Thu, 03 Jun 2021 12:09:52 +0300
In-Reply-To: <20210603090042.A5823C433F1@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 3 Jun 2021 09:00:42 +0000 (UTC)")
Message-ID: <87czt3z53z.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
>
> Kalle
>
> The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
>
>   Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-06-03
>
> for you to fetch changes up to d4826d17b3931cf0d8351d8f614332dd4b71efc4:
>
>   mt76: mt7921: remove leftover 80+80 HE capability (2021-05-30 22:11:24 +0300)
>
> ----------------------------------------------------------------
> wireless-drivers fixes for v5.13
>
> We have only mt76 fixes this time, most important being the fix for
> A-MSDU injection attacks.
>
> mt76
>
> * mitigate A-MSDU injection attacks (CVE-2020-24588)
>
> * fix possible array out of bound access in mt7921_mcu_tx_rate_report
>
> * various aggregation and HE setting fixes
>
> * suspend/resume fix for pci devices
>
> * mt7615: fix crash when runtime-pm is not supported
>
> ----------------------------------------------------------------

Dave & Jakub, just be aware that this is the first pull request from my
new workstation. Everything looks to be ok but please do let me know if
something has changed in my pull requests.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
