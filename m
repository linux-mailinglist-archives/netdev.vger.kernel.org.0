Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0718E33C279
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCOQum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhCOQuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:50:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A8BC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:50:17 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id u20so34063107iot.9
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdkvPlUQ3WJIwDb57XNHqEbjbn2hX+UZTDnLqhq+dlQ=;
        b=EFs8NSYIJQOkU7ePFaqgFJYZNPm4tcscR+8bQw8fhyj1+GskrsB2MN910WHckvf7Qs
         vjAqyl+vtxeM5SIogX5iuBD/m8ZuVo+JeFq+Y/g/FKJmXUsC1R2eHzw6XK+39emWZbBG
         oUgltYOCo5TKi6HvNKmzlBl6qMvroDKzKYl80P9n4e3YL4sNNkr83QNNw5+23H6xXk5T
         jIXX19HrubMYiUunZB+Vs3lG1nFAy0hgfYOUFv0WOqzRSCOeyucrIdfRZmH8jTq0U86J
         OQ4dyWPtmgVF/J2nWstdQBjxtp1i27JhyUaSKAWKtnm7sRa05ntPAZYP7cReNYHa2qBb
         T6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdkvPlUQ3WJIwDb57XNHqEbjbn2hX+UZTDnLqhq+dlQ=;
        b=UoKu/+VYpba7anFx9jnoG+xMC5ms3YUvbUUCFqPfl1RjjbdehlHv7HsTOTqG/15DtF
         3AiQ8TMY32fa9IMTsFue0h57X/D9R5ixULqqDTm6w3SIghoIs444Uste+I0aF43GLTXZ
         dtTnRebnVFnn7vffTWibWbYatuGNtVrJaJ11TW6bsptK2sxVJeKdUlmbSJWLnoM+/6Kh
         x4IJCSvbpf65fu4720B3zTWa4GTwWDhQNqSfOz0bwI9CUtgDpyC7t43MeeZeKYoHGa+b
         mVqQIbvw1Da8g9iL3oSjBbhEXTABPV2/nOQNw/Rdz1PdtEQMF3CQcyAhQ8W0k7Nv54CB
         oUrg==
X-Gm-Message-State: AOAM5310ydHL7XpBFkIHcrdspS5c35XbDiIOaqk4tc4VvFTE4Dv8oktN
        yfFCBHbIzO4aClVhcsCEcApO9HDCpnPMww==
X-Google-Smtp-Source: ABdhPJy0Ql0ByOArOEb5+TwNv4pBJKtLwgG47NlhxW7+QdwCLgHXCuLeuSdu/0FtPG8c8WLKdOGdrA==
X-Received: by 2002:a05:6638:11c2:: with SMTP id g2mr10146678jas.64.1615827016469;
        Mon, 15 Mar 2021 09:50:16 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o5sm7811010ila.69.2021.03.15.09.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 09:50:16 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: ipa: QMI fixes
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315152112.1907968-1-elder@linaro.org>
 <20210315163807.GA29414@work>
From:   Alex Elder <elder@linaro.org>
Message-ID: <3e01bc57-8667-4c56-2806-2ba009887bd4@linaro.org>
Date:   Mon, 15 Mar 2021 11:50:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210315163807.GA29414@work>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 11:38 AM, Manivannan Sadhasivam wrote:
> Hi Alex,
> 
> On Mon, Mar 15, 2021 at 10:21:09AM -0500, Alex Elder wrote:
>> Mani Sadhasivam discovered some errors in the definitions of some
>> QMI messages used for IPA.  This series addresses those errors,
>> and extends the definition of one message type to include some
>> newly-defined fields.
>>
> 
> Thanks for the patches. I guess you need to add Fixes tag for patches 1,2 and
> they should be backported to stable.

I did not do that, intentionally.  The reason is that the
existing code only supports IPA v3.5.1 and IPAv4.2.  And
these bugs seem to cause no problems there.

There are some patches coming very soon that will add
more formal support for IPA v4.5 (where I know you
found these issues).  Those will not be back-ported.

So these fixes don't appear to be necessary for existing
supported platforms.

If you still believe I should have these back-ported,
I have no objection to re-posting for that.  But I
wanted to explain my reasoning before doing it.

--> Do you still think I should have these back-ported?

Thanks.

					-Alex

> 
> Thanks,
> Mani
> 
>> 					-Alex
>>
>> Alex Elder (3):
>>    net: ipa: fix a duplicated tlv_type value
>>    net: ipa: fix another QMI message definition
>>    net: ipa: extend the INDICATION_REGISTER request
>>
>>   drivers/net/ipa/ipa_qmi_msg.c | 78 +++++++++++++++++++++++++++++++----
>>   drivers/net/ipa/ipa_qmi_msg.h |  6 ++-
>>   2 files changed, 74 insertions(+), 10 deletions(-)
>>
>> -- 
>> 2.27.0
>>

