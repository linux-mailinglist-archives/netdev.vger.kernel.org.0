Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A393A48F1
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhFKTBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhFKTBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:01:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11B0C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:59:14 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v11so3289721ply.6
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+g/jRO9YwjHrtzLwxVZI9j41m/vkdBwa6eMe+3C5+tQ=;
        b=gfN8S/JFRfj7Fn18j64SLXXW3YIpjWEIJE0Hrp5JYsFPigBySyLvvMYFqSXBw2aPMK
         f0QUi2ZOdgdgkjqMVEwA2SlPqtJVrEkVBc9Sm9iTDOzESbPdx6mKSE92fRAhE76fvu+Y
         WeGc/ZTfq55jjggZV86C1cEmmenlPY60T18u3EAHrHqpBPTHxzWAbn1oPa5Ox314Fo9h
         OU4bM6OMBL84ZfsoVJ9TCz6ydHmcjsdg4vPeoEtslUExr4ZYezWWuZHef67GPPJ+I76j
         QfI+p81DUM/HqN3nity5Zx4hQppKauddwqYt7A0i+A9FQW8ly4bnJH5aqgSeK4Sx5dqe
         i+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+g/jRO9YwjHrtzLwxVZI9j41m/vkdBwa6eMe+3C5+tQ=;
        b=WfmwXkUosyAsWuJYFGiV7vIxJVRkxSf3E6qXEmG6ZcVo+leabyFjgpTZoSp+a8qVjQ
         Mt2p6WomO6y3SdNFfN4LVoi5P/T9aPoGOY2iW1ztaVBArljNPLhXTRjfqhH9dBpMOPMs
         xOiMK7aMiSa8jcE54eDazd+zNfBOi7P+6ZlQ2GeZ1RbPOqflDzcHyEpvR65y/tqgcbcA
         fY9qXtAQnzDpS26vAkGdqTWQcZX1TFwmrZJbgeqq6rZ0Bh7Sz2uPrzYUDS8V/zx8IEuS
         JzERKVMYq3MfYenpYsmzeSMAn3+1pziLJXgbvQvoQmO/+b+DOy8eEKxDs07W+3qhcCRy
         zwJA==
X-Gm-Message-State: AOAM5320wDiZcSKbE9FjOUyONk5NjHQ9wcUr3QWEzHztg46tgecT2DnP
        keUyJvOLHS53+n54c9v/UvtYwe4k7GF9PQ==
X-Google-Smtp-Source: ABdhPJwd3jrLrlO9q6b9BEBCUsbEaBRnIV46bmrhyXz7qyDQ6o4q8rERSCuWhM0rAIGnXcfiOdBC9w==
X-Received: by 2002:a17:902:ed95:b029:ee:aa46:547a with SMTP id e21-20020a170902ed95b02900eeaa46547amr5183811plj.27.1623437954059;
        Fri, 11 Jun 2021 11:59:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d23sm10856415pjz.15.2021.06.11.11.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 11:59:13 -0700 (PDT)
Subject: Re: [PATCH net-next] ibmvnic: fix kernel build warning in strncpy
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>
References: <20210611160529.88936-1-lijunp213@gmail.com>
 <e53a2d46-fd6d-d0cc-8b78-205c5bd6784b@pensando.io>
 <CAOhMmr4Kumw7XCUG1RaN9U+nYR_a6NcY6Z28FnhswV2+ceQuhw@mail.gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bf41b970-d2bd-9e44-aaaa-0820cf54867b@pensando.io>
Date:   Fri, 11 Jun 2021 11:59:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAOhMmr4Kumw7XCUG1RaN9U+nYR_a6NcY6Z28FnhswV2+ceQuhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/21 11:36 AM, Lijun Pan wrote:
> On Fri, Jun 11, 2021 at 11:28 AM Shannon Nelson <snelson@pensando.io> wrote:
>> On 6/11/21 9:05 AM, Lijun Pan wrote:
>>> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_vpd_rsp’:
>>> drivers/net/ethernet/ibm/ibmvnic.c:4393:3: warning: ‘strncpy’ output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>>>    4393 |   strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>>>         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>
>>> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
>>> ---
>>>    drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
>>> index 497f1a7da70b..2675b2301ed7 100644
>>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>>> @@ -4390,7 +4390,7 @@ static void handle_vpd_rsp(union ibmvnic_crq *crq,
>>>
>>>    complete:
>>>        if (adapter->fw_version[0] == '\0')
>>> -             strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>>> +             memcpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>>>        complete(&adapter->fw_done);
>>>    }
>>>
>> This doesn't fix the real problem.  The error message is saying that
>> there is no string terminating '\0' byte getting set after the "N/A"
>> string, meaning that there could be garbage in the buffer after the
>> string that could allow for surprising and bad things to happen when
>> that string is used later, including buffer overruns that can cause
>> stack smash or other memory munging.
>>
>> Better would be to use strlcpy() with a limiter of
>> sizeof(adapter->fw_version).
>>
>> sln
> Thanks for the tip. I looked up both strscpy and strlcpy. It seems nowadays
> strscpy is preferred.

Sure, that works too.
sln

