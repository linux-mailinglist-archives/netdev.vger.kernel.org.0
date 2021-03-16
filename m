Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A868E33D888
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhCPQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238338AbhCPQAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:00:48 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BEFC0613D8
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:00:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a7so37689142iok.12
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVy1i3oJwcI1/KH1Kh17qeuVz7si7JTF7Jumd8bjlz0=;
        b=PqZBoIM4deh7CCbhnF3C7X9aKO/3ivWr8/mhZhCuBDh6oawhchHtT5PdOXhUgDH6u6
         TqPUO4th0kMVt7snGzqymgpogBSsuuwqpJZAo3PAOSBv18GTYJdOjBpPgY2gHB+EMquL
         GIe3A023T3yfnSyJ2IotXoIWqH1p52KVPop33XegRfkqOgGJIwGg6GvG8Hg6Um/sszOi
         i9FmeH+iP6L0AUOPB4GUyaAeDz9XdbLwFyf9Y1UGJRMia0ZzPXPVE/tzG/ZJ1nXbuhMI
         hd7zX3LefUW9Zh2sqHHgrBDvFFjDbqOkWhefmi9dKU8BmjS7NydDkB2T/jlyhAQ2tQ5u
         9zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVy1i3oJwcI1/KH1Kh17qeuVz7si7JTF7Jumd8bjlz0=;
        b=AnEsh5HP/TqbvrTfdSYkZ3mPzYx5NBYsnztTMuD83BjzGbdVNKKcQ/wFQ/u+UbiH+F
         7xtwqNamhmmmWsjRalpnHoGiFGDPM3211gkAz52hCK5fIduUkl2IyrWNK+lbVkaEZw/+
         ypH2oUeFeFeCnOPliG9Bs0ynemBWVlqp8c/Rhcpoo0IUiWbhFxQtjqSwjU718Z4WuVSv
         aoxCfNiAIxAXU9OM36LgjycvO9NdbOXAuZ0f42Yb8P99Ci3INs7XOTDRPVDaggbUECJ2
         uTufzRbvZYV1MlL5el+g1EKnhwDh21IUPPrXk+QQs0psHo72JRBra2VEFMrwPtM/bn6h
         sR3A==
X-Gm-Message-State: AOAM533ul4/KW/NjSKCFs6FTLefvXvYIwl/OQw1ZllUxXNkeyzFG8LUZ
        hBHztNU71cAbt2J1gl7iX1mwmA==
X-Google-Smtp-Source: ABdhPJxN3vPbvS3WWhuKpN0Lv5nOuTPD1xAs6+/+2Bbmuf/uhiF27eE0WxC3PB+gwOHHWjcrjTQbfg==
X-Received: by 2002:a6b:d318:: with SMTP id s24mr3965310iob.89.1615910439645;
        Tue, 16 Mar 2021 09:00:39 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k125sm8870996iof.14.2021.03.16.09.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 09:00:39 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: ipa: QMI fixes
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315152112.1907968-1-elder@linaro.org>
 <20210315163807.GA29414@work>
 <3e01bc57-8667-4c56-2806-2ba009887bd4@linaro.org>
 <20210316032557.GB29414@work>
From:   Alex Elder <elder@linaro.org>
Message-ID: <54f8962c-6503-8d92-2a6c-875c112441a4@linaro.org>
Date:   Tue, 16 Mar 2021 11:00:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210316032557.GB29414@work>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 10:25 PM, Manivannan Sadhasivam wrote:
> On Mon, Mar 15, 2021 at 11:50:15AM -0500, Alex Elder wrote:
>> On 3/15/21 11:38 AM, Manivannan Sadhasivam wrote:
>>> Hi Alex,
>>>
>>> On Mon, Mar 15, 2021 at 10:21:09AM -0500, Alex Elder wrote:
>>>> Mani Sadhasivam discovered some errors in the definitions of some
>>>> QMI messages used for IPA.  This series addresses those errors,
>>>> and extends the definition of one message type to include some
>>>> newly-defined fields.
>>>>
>>>
>>> Thanks for the patches. I guess you need to add Fixes tag for patches 1,2 and
>>> they should be backported to stable.
>>
>> I did not do that, intentionally.  The reason is that the
>> existing code only supports IPA v3.5.1 and IPAv4.2.  And
>> these bugs seem to cause no problems there.
>>
>> There are some patches coming very soon that will add
>> more formal support for IPA v4.5 (where I know you
>> found these issues).  Those will not be back-ported.
>>
>> So these fixes don't appear to be necessary for existing
>> supported platforms.
>>
> 
> Hmm, okay. Then please mention this information in the commit description(s)
> that the fix is only needed for IPA4.5.

Mani, you ACKed all three patches after you sent this.

Are you expecting me to send a new version of the code,
or are you willing to accept the series as-is?

Thanks.

					-Alex

> 
> Thanks,
> Mani
> 
>> If you still believe I should have these back-ported,
>> I have no objection to re-posting for that.  But I
>> wanted to explain my reasoning before doing it.
>>
>> --> Do you still think I should have these back-ported?
>>
>> Thanks.
>>
>> 					-Alex
>>
>>>
>>> Thanks,
>>> Mani
>>>
>>>> 					-Alex
>>>>
>>>> Alex Elder (3):
>>>>     net: ipa: fix a duplicated tlv_type value
>>>>     net: ipa: fix another QMI message definition
>>>>     net: ipa: extend the INDICATION_REGISTER request
>>>>
>>>>    drivers/net/ipa/ipa_qmi_msg.c | 78 +++++++++++++++++++++++++++++++----
>>>>    drivers/net/ipa/ipa_qmi_msg.h |  6 ++-
>>>>    2 files changed, 74 insertions(+), 10 deletions(-)
>>>>
>>>> -- 
>>>> 2.27.0
>>>>
>>

