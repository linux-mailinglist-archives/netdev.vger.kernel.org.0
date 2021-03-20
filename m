Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C3342D44
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 15:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCTOXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 10:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhCTOXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 10:23:38 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F799C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:23:38 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r193so9190725ior.9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kQcbTGanAzrgBGCF/DKThsZjt/13iN1Rp0nICH3M9pk=;
        b=olTZRjhoRaI6B/JDy56MsvNTIlwMF27aPC5lL9ePvK033EmT21syW+tJhy4QUKIo+R
         vGiHj1e9xEGqU9fUhiyCzN5zPFPUzZNFndaEjiSLQhxHSrtEvMEoBGNd1dUWpo8kYhq0
         F34cThDXnkcumLUcCRgqM+qBIDt/RLg3gQlrVyX7OdCnq8zbnxNsXfi8lSfCq2bmK2IO
         eq/dxP9egxoyv/cs8gdiXamFKKzT59vLCqIbdlMOMM6Gj9wRi/M+PSKy27CCjfOsiH+X
         h5HOuEmNbPvg/Rppw5BzXl74pE23jtV2b+JHw+6QLwLOwOYki8PymWXgHBYZosPme19a
         HD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQcbTGanAzrgBGCF/DKThsZjt/13iN1Rp0nICH3M9pk=;
        b=e98BnZ0aTu1oOUt4TaYoIiaY9nFsHxgBMrD3eF+1Xz4JAy+hXfIKbZVKEwIzxQBPyp
         TY/oxjd/K03NU4EY2SzUlPVNN6wSujHKddLfe2eitxr8rxYqoVWrrC/vIghN+sDSN79T
         QKdIU7qpWkrZeTRHUj2qQnZppoNwhJKWSya8yiuwHH0idaAye7rcn7czr23hLN0GXenX
         Kinf7sh01zvJlcUG6eGScqqR5LpoPC324bgkkQ1D4sSk/JD//Rr2IgqDWPfhKnpPawBD
         DkkITcTDC2M3lPVH0OVqnczHvHF42q2FeMWxZdjHNYjmwZR60oFtyTv2ZuLfw6n6N2kQ
         7Zjg==
X-Gm-Message-State: AOAM531ZclPJihdfogXCjW5eDa0+DZ/dTpB076h1v0Y+TfYwS92cNBvV
        GtXRM+Wl+lvyTCx1QaEV1Q+7Jg==
X-Google-Smtp-Source: ABdhPJwW/D+7SEinGZQ3lVcOqHDEhRusbrR2WJ5tPjiuwwyGi3OG9W169lkEBLln9OG4O7Zvmvirkw==
X-Received: by 2002:a5d:9250:: with SMTP id e16mr6164893iol.27.1616250217388;
        Sat, 20 Mar 2021 07:23:37 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v19sm4234117iol.21.2021.03.20.07.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 07:23:36 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: ipa: fix validation
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210319042923.1584593-1-elder@linaro.org>
 <5c6fabcf-88c7-29db-431e-01818321e9e7@linaro.org>
Message-ID: <9ef8e593-d6be-a936-7a02-0a08e0be51be@linaro.org>
Date:   Sat, 20 Mar 2021 09:23:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <5c6fabcf-88c7-29db-431e-01818321e9e7@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/21 8:24 AM, Alex Elder wrote:
> On 3/18/21 11:29 PM, Alex Elder wrote:
>> There is sanity checking code in the IPA driver that's meant to be
>> enabled only during development.  This allows the driver to make
>> certain assumptions, but not have to verify those assumptions are
>> true at (operational) runtime.  This code is built conditional on
>> IPA_VALIDATION, set (if desired) inside the IPA makefile.
> 
> Given the pushback on the ipa_assert() patch I will send
> out version 2 of this series, omitting the two patches
> that involve assertions.

I posted version 2, but I think dropping two patches
without changing the subject might have messed up
the robots.  I don't know how to fix that and don't
want to make any more trouble by trying.

If there's something I can do, someone please tell me.

					-Alex

> I still think there's a case for my proposal, but I'm
> going to move on for now and try to find other ways
> to do what I want.  In some cases BUILD_BUG_ON() or
> WARN_ON_DEV() could be used.  In other spots, I might
> be able to use dev_dbg() for checking things only
> while developing.  But there remain a few cases where
> none of these options is quite right.
> 
> If I ever want to suggest an assertion again I'll do
> it as an RFC and will copy Leon and Andrew, to make
> sure they can provide input.
> 
> Thanks.
> 
>                      -Alex
> 
>> Unfortunately, this validation code has some errors.  First, there
>> are some mismatched arguments supplied to some dev_err() calls in
>> ipa_cmd_table_valid() and ipa_cmd_header_valid(), and these are
>> exposed if validation is enabled.  Second, the tag that enables
>> this conditional code isn't used consistently (it's IPA_VALIDATE
>> in some spots and IPA_VALIDATION in others).
>>
>> This series fixes those two problems with the conditional validation
>> code.
>>
>> In addition, this series introduces some new assertion macros.  I
>> have been meaning to add this for a long time.  There are comments
>> indicating places where assertions could be checked throughout the
>> code.
>>
>> The macros are designed so that any asserted condition will be
>> checked at compile time if possible.  Otherwise, the condition
>> will be checked at runtime *only* if IPA_VALIDATION is enabled,
>> and ignored otherwise.
>>
>> NOTE:  The third patch produces two bogus (but understandable)
>> warnings from checkpatch.pl.  It does not recognize that the "expr"
>> argument passed to those macros aren't actually evaluated more than
>> once.  In both cases, all but one reference is consumed by the
>> preprocessor or compiler.
>>
>> A final patch converts a handful of commented assertions into
>> "real" ones.  Some existing validation code can done more simply
>> with assertions, so over time such cases will be converted.  For
>> now though, this series adds this assertion capability.
>>
>>                     -Alex
>>
>> Alex Elder (4):
>>    net: ipa: fix init header command validation
>>    net: ipa: fix IPA validation
>>    net: ipa: introduce ipa_assert()
>>    net: ipa: activate some commented assertions
>>
>>   drivers/net/ipa/Makefile       |  2 +-
>>   drivers/net/ipa/gsi_trans.c    |  8 ++---
>>   drivers/net/ipa/ipa_assert.h   | 50 ++++++++++++++++++++++++++++++++
>>   drivers/net/ipa/ipa_cmd.c      | 53 ++++++++++++++++++++++------------
>>   drivers/net/ipa/ipa_cmd.h      |  6 ++--
>>   drivers/net/ipa/ipa_endpoint.c |  6 ++--
>>   drivers/net/ipa/ipa_main.c     |  6 ++--
>>   drivers/net/ipa/ipa_mem.c      |  6 ++--
>>   drivers/net/ipa/ipa_reg.h      |  7 +++--
>>   drivers/net/ipa/ipa_table.c    | 11 ++++---
>>   drivers/net/ipa/ipa_table.h    |  6 ++--
>>   11 files changed, 115 insertions(+), 46 deletions(-)
>>   create mode 100644 drivers/net/ipa/ipa_assert.h
>>
> 

