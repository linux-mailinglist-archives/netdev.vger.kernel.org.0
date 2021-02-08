Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73739312E8F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhBHKHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:07:44 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:28542 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231846AbhBHKET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 05:04:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612778634; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Hm8GS0rOsCfvjICUAxi/K5Puq7MY8iUSmrsfVo7iuKE=; b=bgCe6JLj/xbXGTLztRs+vART8pjxRZDpbLylnqtAR5hSCO+TOUkGuk6AZiuakXAeR7zGmeQL
 EYI1ZUJHSn9C+yIzDJPBtagah990FDgtf2UxilzJlVtnUZh52T++MCHp4z/6jH7nMxBFn5af
 JamqG1CA3HerJV4Ug/5kkpWyI/8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60210c703919dfb45571aca3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:03:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2C2F4C433C6; Mon,  8 Feb 2021 10:03:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5AAE9C433CA;
        Mon,  8 Feb 2021 10:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5AAE9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RESEND net-next] cfg80211: remove unused callback
References: <20210206194747.11086-1-mcroce@linux.microsoft.com>
Date:   Mon, 08 Feb 2021 12:03:19 +0200
In-Reply-To: <20210206194747.11086-1-mcroce@linux.microsoft.com> (Matteo
        Croce's message of "Sat, 6 Feb 2021 20:47:47 +0100")
Message-ID: <87o8gukhaw.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matteo Croce <mcroce@linux.microsoft.com> writes:

> From: Matteo Croce <mcroce@microsoft.com>
>
> The ieee80211 class registers a callback which actually does nothing.
> Given that the callback is optional, and all its accesses are protected
> by a NULL check, remove it entirely.
>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  net/wireless/sysfs.c | 7 -------
>  1 file changed, 7 deletions(-)

Normally cfg80211 patches go to mac80211-next, not net-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
