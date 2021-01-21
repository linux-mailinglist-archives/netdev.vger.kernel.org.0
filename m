Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8FF2FE8E8
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbhAULfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbhAULf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:35:26 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4C1C061757
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:34:45 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y19so3319365iov.2
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AOfcfp/MhGMtT1440C10QG9fDR6wkqPv5o4JL4EA7co=;
        b=wSrkzHPbhhTDQdj9vvmzKkYBxOKlad62tbZD1hjt4DnQzceyvJE1xkZsYNhYItAhII
         0+QKJy4xWp0Fe+ff2w/p3CgFoDz0rX0Fs9rA3jji+TFAIP7t1DKrrZRUCcdhDOi6eJFf
         kRIwFenuMYVQiT//r2yNhrg4tmaUyltF4zHbm5yVuAB0P9xNTPg5GlnkGywYGjlrcsl2
         NcNLpHSGfZG6tMtOzLNUwHgkQ9InyQfzW9yWmPOo4r76bZzFOBOCwIWapFr674ZhuHuB
         +te8jOoL+KP0b1/C2m62tZiDKrYUuTmxuOF4P6aUpTYVBFeFfX4logJNU6+Y7wXVfxWo
         LKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AOfcfp/MhGMtT1440C10QG9fDR6wkqPv5o4JL4EA7co=;
        b=NMDlVC8Nzlz2dCuvNk7Q44nEwqT+lVoCWJlqf8YPK57tS40OaPwt9oHMQFgVevjJqI
         mv1ecHoMgXBuabWkw7PHSLm0tQwqnURXHBm2vOssOwHOWrqFlNiLhfehE/ezU+AP/R0s
         hn7g6+AjnYrj4XZ/wEU+FN80sQX7Vx60zqw0DtmkuKrlQgRrhujaCHgjrJrJTEnh0HvC
         BK8b5fCGXdAyo+T1tLQNGP8jJyMyc/aUFzKoeb0QRY0729PKkseV3MTIfMis3mQU55SW
         ZHU3RZkV6wF6jwSEODt7m6/uOhTYc/CQZMqvB6hjlNCc9f15yhAIMTfzevFB7HniceqI
         hNBQ==
X-Gm-Message-State: AOAM5309jqI7wTP90sBeNrD412FmZm7IOcei3Vf0LDM/XnGnuk/xwm12
        KkNunyWucWggVqnEeE11oWy0ig51tq1Tew==
X-Google-Smtp-Source: ABdhPJwaXyJg7Jg6GECx87VVw8d8MQqZF0XkKhvwzoH/EZiVQh7tYkcQ+7UTAPtp8XnbRpqM4Qq9ig==
X-Received: by 2002:a6b:fa13:: with SMTP id p19mr10168117ioh.119.1611228884514;
        Thu, 21 Jan 2021 03:34:44 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l20sm2344182ioh.49.2021.01.21.03.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 03:34:43 -0800 (PST)
Subject: Re: [PATCH net-next 3/5] net: ipa: have gsi_channel_update() return a
 value
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210120220401.10713-1-elder@linaro.org>
 <20210120220401.10713-4-elder@linaro.org>
 <20210120213522.4042c051@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <ebc067ba-224c-6d3e-822a-2e578f0c7d25@linaro.org>
Date:   Thu, 21 Jan 2021 05:34:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210120213522.4042c051@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/21 11:35 PM, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 16:03:59 -0600 Alex Elder wrote:
>> Have gsi_channel_update() return the first transaction in the
>> updated completed transaction list, or NULL if no new transactions
>> have been added.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
>> @@ -1452,7 +1452,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
>>   }
>>   
>>   /* Consult hardware, move any newly completed transactions to completed list */
>> -static void gsi_channel_update(struct gsi_channel *channel)
>> +struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
> 
> Why did it lose the 'static'?

It should not have.

My aarch64 build environment did not flag that, but I now built
for x86 and it does.  I guess I should make a habit of checking
with that, though it's a bit time-consuming.

I'll send v2 out shortly.  Thank you.

					-Alex

> drivers/net/ipa/gsi.c:1455:19: warning: no previous prototype for ‘gsi_channel_update’ [-Wmissing-prototypes]
>   1455 | struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
>        |                   ^~~~~~~~~~~~~~~~~~
> 

