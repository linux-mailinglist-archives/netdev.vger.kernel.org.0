Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD0A24675B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgHQN2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:28:05 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:25565 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728585AbgHQN16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:27:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597670877; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=INTxAt5lNz/SJ0qOc87ualrdr+KyL5wjMAo0+q1t93w=; b=Nt0S/5o8jraMJ3Fvvg5HC+2dPCkOKZ+6a+dAEFABCamf1iZdiv21hT0M0VHFFXr+v8d8LELK
 DqsuR2CkhMokmoP0W3+9DNDhAEeYmZvUjUPOwofUst2UTb4hBC9JCz8QgVx5rpyyeJp5ncqq
 altH/gSZgc9YLwSaa7jkuAin3GA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5f3a85acf2b697637a049002 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 Aug 2020 13:27:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 17D74C433AD; Mon, 17 Aug 2020 13:27:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 259DAC433CA;
        Mon, 17 Aug 2020 13:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 259DAC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        Fabrice Bellet <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-13-lee.jones@linaro.org>
        <87r1s9l0mc.fsf@codeaurora.org> <20200814163831.GN4354@dell>
Date:   Mon, 17 Aug 2020 16:27:01 +0300
In-Reply-To: <20200814163831.GN4354@dell> (Lee Jones's message of "Fri, 14 Aug
        2020 17:38:31 +0100")
Message-ID: <87a6ytmmhm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Fri, 14 Aug 2020, Kalle Valo wrote:
>
>> Lee Jones <lee.jones@linaro.org> writes:
>> 
>> >  - Ensure spaces appear after {for, if, while, etc}
>> >  - Ensure spaces to not appear after '('
>> >  - Ensure spaces to not appear before ')'
>> >  - Ensure spaces appear between ')' and '{'
>> >  - Ensure spaces appear after ','
>> >  - Ensure spaces do not appear before ','
>> >  - Ensure spaces appear either side of '='
>> >  - Ensure '{'s which open functions are on a new line
>> >  - Remove trailing whitespace
>> >
>> > There are still a whole host of issues with this file, but this
>> > patch certainly breaks the back of them.
>> >
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: Benjamin Reed <breed@users.sourceforge.net>
>> > Cc: Javier Achirica <achirica@users.sourceforge.net>
>> > Cc: Jean Tourrilhes <jt@hpl.hp.com>
>> > Cc: Fabrice Bellet <fabrice@bellet.info>
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > ---
>> >  drivers/net/wireless/cisco/airo.c | 897 ++++++++++++++++--------------
>> >  1 file changed, 467 insertions(+), 430 deletions(-)
>> 
>> This is a driver for ancient hardware, I'm not sure if it's worth trying
>> to fix any style issues. Is anyone even using it? Should we instead just
>> remove the driver?
>
> Sounds like a reasonable solution to me.
>
> I'm also happy to do it, if there are no objections.
>
> As it stands, it's polluting the code-base and the build-log, so
> something should be done.

I tried to find some comments about the driver and here's one successful
report from 2013:

https://martybugs.net/wireless/aironet4800.cgi

And here's one commit from 2015 where Ondrej (CCed) was also testing the
driver:

----------------------------------------------------------------------
commit dae0412d0caa4948da07fe4ad91352b5b61a70ec
Author:     Ondrej Zary <linux@rainbow-software.org>
AuthorDate: Fri Oct 16 21:04:14 2015 +0200
Commit:     Kalle Valo <kvalo@codeaurora.org>
CommitDate: Wed Oct 28 20:54:39 2015 +0200

    airo: fix scan after SIOCSIWAP (airo_set_wap)
    
    SIOCSIWAP (airo_set_wap) affects scan: only the AP specified by
    SIOCSIWAP is present in scan results.
    
    This makes NetworkManager work for the first time but then unable to
    find any other APs.
    
    Clear APList before starting scan and set it back after scan completes
    to work-around the problem.
    
    To avoid losing packets during scan, modify disable_MAC() to omit
    netif_carrier_off() call when lock == 2.
    
    Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
----------------------------------------------------------------------

I was surprised to see that someone was using this driver in 2015, so
I'm not sure anymore what to do. Of course we could still just remove it
and later revert if someone steps up and claims the driver is still
usable. Hmm. Does anyone any users of this driver?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
