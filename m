Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F02627D58F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgI2SNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI2SNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:13:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB062C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 11:13:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m34so4499782pgl.9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 11:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nOAeSaRSdSEzpwSwaA/83yr7kkGU4AIMhmNtQfehNPQ=;
        b=GuccpI1OZOL82pM57HquMw1PsYF+Ak7iqWjmxBbX9ZCGtOa3dVbbTEk7aK5bxRuydE
         DaMdxSEKyVOxNxCjSkOGAx4I7q9MMXvKB62c6QLj7yWYPMRK+FDSklH9C/U/Gqp1fbsc
         bThyGr7lXmwwjoaPAGYSfW/FkMjn8ZL3kZEJOWYTZK974wBfLNlF9r4ZhOX96HQNQJUP
         UFXjWjOiFwio9ddGnEJRhRNNGqKIqigxe3vDSf4LEmo6iILA2+HQkd3B9pfk80WJdP32
         HG9Yce72DPYBeccxehTjknzcaV3ozjALKwZuJ1nDgMFMQn0KV2zEORnlmPDEPr92J4SE
         TKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nOAeSaRSdSEzpwSwaA/83yr7kkGU4AIMhmNtQfehNPQ=;
        b=nrrR/k4Y9BebHp8GNDCUUshytcXNtXWMAxctmWnw1Lq6xmBg7FWOCgsj0/H80rDcvV
         Jt3Bo4cNFKMhUXQ4Rn19vlswHT0Yza9QtpOrVWXWjtGITz7/Tyhb5LbR4MZ0v0iSK4ig
         ZryIrdnO9ReTvGsCFrv3DIV6cELX4JUviJS+XETqhCVpWhexymPvJavSOT2w8dw2vUI+
         16v46UodlR4B5XQJJxsNknmU1jjPWQDVjWFANCQ4Wbs25ISeERkXnzsxoClGZQlnhay7
         OxTHaXWAhqrufS7Y0X9qtLEeKxeWnf3TPrm3JLVbvAWkOpkXvSIXJdvljazEPdXWXKDI
         S9zg==
X-Gm-Message-State: AOAM53342aONOlaVFdsgF+GjVKqTrv15Xm9OwRtDm9Y5z10Qb8psQYO4
        5qxzek5C791wyyumFWZ/y9rUNCE09lKmbQ==
X-Google-Smtp-Source: ABdhPJwBN1UbKcnkVXw7m13sHfuYH4aYyBm7Z3+XTeX9e0z4PIOzsyAAYgnsWV0/6RTvmQ93ffue6w==
X-Received: by 2002:aa7:8bd4:0:b029:13c:1611:6538 with SMTP id s20-20020aa78bd40000b029013c16116538mr5494004pfd.10.1601403214866;
        Tue, 29 Sep 2020 11:13:34 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id o20sm5830613pgh.63.2020.09.29.11.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 11:13:34 -0700 (PDT)
Subject: Re: [RFC iproute2-next] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org
References: <20200928234945.3417905-1-jacob.e.keller@intel.com>
 <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a4250983-4520-1390-3a7c-b6bc794f04eb@pensando.io>
Date:   Tue, 29 Sep 2020 11:13:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 10:56 AM, Jacob Keller wrote:
> On 9/29/2020 10:18 AM, Jakub Kicinski wrote:
>> On Mon, 28 Sep 2020 16:49:45 -0700 Jacob Keller wrote:
>>> For some devices, updating the flash can take significant time during
>>> operations where no status can meaningfully be reported. This can be
>>> somewhat confusing to a user who sees devlink appear to hang on the
>>> terminal waiting for the device to update.
>>>
>>> Provide a ticking counter of the time elapsed since the previous status
>>> message in order to make it clear that the program is not simply stuck.
>>>
>>> Do not display this message unless a few seconds have passed since the
>>> last status update. Additionally, if the previous status notification
>>> included a timeout, display this as part of the message. If we do not
>>> receive an error or a new status without that time out, replace it with
>>> the text "timeout reached".
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> ---
>>> Sending this as an RFC because I doubt this is the best implementation. For
>>> one, I get a weird display issue where the cursor doesn't always end up on
>>> the end of line in my shell.. The % display works properly, so I'm not sure
>>> what's wrong here.
>>>
>>> Second, even though select should be timing out every 1/10th of a second for
>>> screen updates, I don't seem to get that behavior in my test. It takes about
>>> 8 to 10 seconds for the first elapsed time message to be displayed, and it
>>> updates really slowly. Is select just not that precise? I even tried using a
>>> timeout of zero, but this means we refresh way too often and it looks bad. I
>>> am not sure what is wrong here...
>> Strange. Did you strace it? Perhaps it's some form of output buffering?
>>
> Haven't yet, just noticed the weird output behavior and timing
> inconsistency.

Add a fflush(stdout) at the end of pr_out_tty()?  Or maybe simply 
disable stdout buffering with setvbuf().

>>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>>> index 0374175eda3d..7fb4b5ef1ebe 100644
>>> --- a/devlink/devlink.c
>>> +++ b/devlink/devlink.c
>>> @@ -33,6 +33,7 @@
>>>   #include <sys/select.h>
>>>   #include <sys/socket.h>
>>>   #include <sys/types.h>
>>> +#include <sys/time.h>
>>>   #include <rt_names.h>
>>>   
>>>   #include "version.h"
>>> @@ -3066,6 +3067,9 @@ static int cmd_dev_info(struct dl *dl)
>>>   
>>>   struct cmd_dev_flash_status_ctx {
>>>   	struct dl *dl;
>>> +	struct timeval last_status_msg;

Having some 'time' concept in this name will make it less likely for the 
reader to confuse it with something that holds a text message - 't_', or 
'_secs' or something.

sln


