Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943D3416D1D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbhIXHwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:52:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:31199 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbhIXHwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:52:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632469851; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=6zccmjdrHo+ekRUZS+8j7DEY4Vf+wTOSBKi2rSCaWBE=; b=kWAXZxqy28EJcOB4V+QHEGHHqolSdu3uUINrp80WPIihF+M4JdWNFUfxpOOk4vzVH4OcyAbQ
 4r3kZVvx9lfaGbOBRPTnWCJYypiRocmX/mD0Bq85gkYgYnERc8BVlqGLwsC56h3xbmdXHqIV
 ufIxeQzCvHpJuGL2eDiuitnh0tc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 614d8345096ba46b979ff0ea (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 07:50:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 499F4C4360C; Fri, 24 Sep 2021 07:50:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17429C4338F;
        Fri, 24 Sep 2021 07:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 17429C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] mac80211_hwsim: enable 6GHz channels
References: <20210922142803.192601-1-ramonreisfontes@gmail.com>
        <167f632eb19944b5711a584218e57b51da85df96.camel@sipsolutions.net>
Date:   Fri, 24 Sep 2021 10:50:24 +0300
In-Reply-To: <167f632eb19944b5711a584218e57b51da85df96.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 22 Sep 2021 16:29:37 +0200")
Message-ID: <87fstutnsv.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2021-09-22 at 11:28 -0300, Ramon Fontes wrote:
>> This adds 6 GHz capabilities and reject HT/VHT
>> 
>
> It'd be nice to add a version to the subject, with -vN on the git-send-
> email commandline :)

And don't forge the changelog either:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

One day I'll write a bot to send these wiki links :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
