Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D016BDC47
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjCPXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCPXAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:00:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8678CAE11E;
        Thu, 16 Mar 2023 15:59:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id le6so3383376plb.12;
        Thu, 16 Mar 2023 15:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pmY/NEnopeaIFWGckdd/CSFY1x3ucHlApyB60XIUlso=;
        b=N9d5gjLm1VKfn9cBbEkj8wITgwpXKGTQEOo3yZAyO0dPHUD7CSN7vXgC8FxmhfKrTe
         Y27ZW1PxlSeNXaBm20bZfWvfuD4mYS3R4YB4nHxMRoHxS40+vGB8vnIY0ZaJLpe3EZBT
         0SpfuT94HAU3k9OkxGQg0e8J2e2KaY7pI0SkY8DjdUX2zv026sC+ZpzDOV7qv3kV0yec
         lU76wA6DCGw2wipimJos8ajRCZxaXhYpFHiBzbMBMdT187zJSEdet5GuU7W9RcRvKCxH
         oG5DMhSoamhj+JphiSBniGRN6Teaw55Ha8v11IDaZFz6T7mUVjYy/3G36H8lJnTV/JGJ
         iiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmY/NEnopeaIFWGckdd/CSFY1x3ucHlApyB60XIUlso=;
        b=JRxcxBLhvE6ZAqlYhTeDXhkaSLoUm0NH7cBFRyCyov5jdA12oKKvKqohZz5N8qWdG0
         N+6B5oijggYWkihU2HXBPW/0hFXzdEdfWscBEo6x4IRxaFlsHoENNL3xcoOIxyzWk7GM
         I7lDmoHH+7IM0sdUIA7qHrNLhaJAXidnaE1KewZ4h8soFGMVIftZLJOdX1y3oFtk2S7g
         IT/K8VCdBraaUl4J3a5FdHgtUIQz5K9B5dRM/NL5Iu4gIJKCm3KwAF8GnOJYn4HRVRxc
         YsjihxhubSrUJWnYkrfkQa6nyhviY5ZbNKyA+fyK9xiY6dW2uAzDkDBVBozeHYwnZzS4
         5ynQ==
X-Gm-Message-State: AO0yUKWAL9MXeLiBrUe0roXBm7Nk7WpXLGosXdzBGQpFGYNkGQtZoH73
        5yVMRIRgXw4NCEbLiXMWTfYIJHMuQ6E=
X-Google-Smtp-Source: AK7set/5lAKWHQEk7DZk3RzgG8eOBUeBjLVmeLQdqd9lRTcQBIPDczfrOzE041ailcXKdH0h7NOmnQ==
X-Received: by 2002:a17:90a:19dd:b0:23b:2ce5:2ddb with SMTP id 29-20020a17090a19dd00b0023b2ce52ddbmr950530pjj.8.1679007595957;
        Thu, 16 Mar 2023 15:59:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g34-20020a635662000000b004f1cb6ffe81sm155022pgm.64.2023.03.16.15.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 15:59:55 -0700 (PDT)
Message-ID: <7ddfa9e1-c7a2-7a62-a2ba-eb2c93a3a2fa@gmail.com>
Date:   Thu, 16 Mar 2023 15:59:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
References: <20230315223044.471002-1-kuba@kernel.org>
 <20230315155202.2bba7e20@hermes.local> <20230315161142.48de9d98@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315161142.48de9d98@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 16:11, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 15:52:02 -0700 Stephen Hemminger wrote:
>> On Wed, 15 Mar 2023 15:30:44 -0700
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>
>>> Add basic documentation about NAPI. We can stop linking to the ancient
>>> doc on the LF wiki.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>> CC: jesse.brandeburg@intel.com
>>> CC: anthony.l.nguyen@intel.com
>>> CC: corbet@lwn.net
>>> CC: linux-doc@vger.kernel.org
>>
>> The one thing missing, is how to handle level vs edge triggered interrupts.
>> For level triggered interrupts, the re-enable is inherently not racy.
>> I.e re-enabling interrupt when packet is present will cause an interrupt.
>> But for devices with edge triggered interrupts, it is often necessary to
>> poll and manually schedule again. Older documentation referred to this
>> as the "rotten packet" problem.
>>
>> Maybe this is no longer a problem for drivers?
>> Or maybe all new hardware uses PCI MSI and is level triggered?
> 
> It's still a problem depending on the exact design of the interrupt
> controller in the chip / tradeoffs the SW wants to make.
> I haven't actually read the LF doc, because I wasn't sure about the
> licenses (sigh). The rotten packet problem does not come up in reviews
> very often, so it wasn't front of mind. I'm not sure I'd be able to
> concisely describe it, actually :S There are many races and conditions
> which can lead to it.

True, though I would put a word in or two about level vs. edge triggered 
anyway, if nothing else, explain essentially what Stephen just provided 
ought to be a good starting point for driver writers to consider the 
possible issue.
-- 
Florian

