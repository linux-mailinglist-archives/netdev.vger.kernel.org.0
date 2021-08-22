Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D03F3DF8
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 07:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhHVFJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 01:09:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:40296 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhHVFJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 01:09:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629608921; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fCW+fuhpLtJtoS0Vq35xVvfhFpaYBTJcy038J0U+ubM=; b=VnnSYEiAIrzDpiRliVLy9vX44H6+gfFiPAWesTtk9yTbcJ7GStZpOobgamI/BiOeefRAe8RU
 naKLOLSOP7EU71gRlPScGIN2w2b5C4bQtDPwfZaJaGpSfqD6Rfdx9VbcRYFrvHUl5uyHa0Tx
 REfL9dDePFRrsTH04TCzgJ4J+hE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6121dbd089fbdf3ffe6a26a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 22 Aug 2021 05:08:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9394AC43460; Sun, 22 Aug 2021 05:08:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90B6AC4338F;
        Sun, 22 Aug 2021 05:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 90B6AC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Joe Perches <joe@perches.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] ray_cs: use %*ph to print small buffer
References: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
        <20210821171432.B996DC4360C@smtp.codeaurora.org>
        <293b9231af8b36bb9a24a11c689d33c7e89c3c4e.camel@perches.com>
Date:   Sun, 22 Aug 2021 08:08:23 +0300
In-Reply-To: <293b9231af8b36bb9a24a11c689d33c7e89c3c4e.camel@perches.com> (Joe
        Perches's message of "Sat, 21 Aug 2021 12:38:49 -0700")
Message-ID: <877dgerrqw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sat, 2021-08-21 at 17:14 +0000, Kalle Valo wrote:
>> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>> 
>> > Use %*ph format to print small buffer as hex string.
>> > 
>> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> 
>> Patch applied to wireless-drivers-next.git, thanks.
>> 
>> 502213fd8fca ray_cs: use %*ph to print small buffer
>> 
>
> There's one more of these in the same file but it's in an #ifdef 0 block...

I would rather remove the whole ifdef 0 block, patches welcome.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
