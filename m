Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410454AA664
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379308AbiBEEK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEEK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:10:56 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF29C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:10:54 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id b5so181382ile.11
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z+C56iJ36OqRTSDdvxGVTOdSrhGfv+PUxed1fq4ea2s=;
        b=ECrcSSmQF3n11fRzoj+C6Bw4S8XHGezelivKYwJayGxcccnZ3Sa0lWEJ0Bu2uWuGUK
         ZcuQhDiblWHxUpVXceJQfJ5j0micKHJAbOI8A50wWNDtWpO0IF+2E9l+Br1gQtucBj9D
         EWuv56ARdwzKAhmy7MrfylR9gkTr4KYiXCtWt/LV8HQStqG8n906oyyorrCCbCMNQTtt
         fttAFMKNKbxHsMbNHbFzjO6mFJZjRohLzDaP+Kg0CDjhGu88Mro7S+t1p/gBk948IpGp
         kQVlFrz+WWSFr24Kij9+gTIIYTG8tX4P7hwBtb7e6JUxf6v55R1Luxs53kxmoWfdtTN3
         nzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z+C56iJ36OqRTSDdvxGVTOdSrhGfv+PUxed1fq4ea2s=;
        b=J32oamidTaWm6Vt7aYlIwnIReSCCE6HCRWZNeZJeE9rlKCSYnrquKSGPAxVEokk7wE
         caWyXLygU3A4Nw2STjMkCS8PCY6ysUBq5SYc6i2g+y9ic1XqGrHDf/7+dYiY6VyWXAJD
         4eSmPZv8LtgBQnhBDOYyrnnGWmXs1QfNW3sPQaQsUjidbTvwZ/v+qKYUt92X82cB7226
         n3zuvT7yWg1aZ3LXbZOGkgZrr3FoyK2u7SylV4LesDzekLfLZOWtuzO87DwbLhIgKXmK
         yzRhYIW5zywa2V+TZW2052Nv+Mlh+7gofWKwJfX8cpKhRx0MBURrW7g97vbOZn2kZ+pg
         luQg==
X-Gm-Message-State: AOAM530pCtdhaI/MfbmInsqjd5ykT/bgf18duPaHlNCvV3Bu2rxOMgDZ
        IlGBVmPQLg/gSCRbZdt0liQIRrVkzxI=
X-Google-Smtp-Source: ABdhPJxavpOoZD5xQ5SC20egQ+zyVuh1ALMQio+Hh2VYk4Jop0TcACX+P6LT8w/bJ8QIEM6TccMw+w==
X-Received: by 2002:a05:6e02:b4a:: with SMTP id f10mr1169355ilu.4.1644034254024;
        Fri, 04 Feb 2022 20:10:54 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:c454:3919:8cde:fcfe? ([2601:284:8200:b700:c454:3919:8cde:fcfe])
        by smtp.googlemail.com with ESMTPSA id x24sm1881292iox.20.2022.02.04.20.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 20:10:53 -0800 (PST)
Message-ID: <1f5e05a3-7d07-0412-1db2-8a848aa868d9@gmail.com>
Date:   Fri, 4 Feb 2022 21:10:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP
 addresses
Content-Language: en-US
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <42653bf5-ba76-2561-9cf9-27b0ae730210@gmail.com>
 <20220204180728.1597731-1-Jacques.De.Laval@westermo.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220204180728.1597731-1-Jacques.De.Laval@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/22 11:07 AM, Jacques de Laval wrote:
>>> @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
>>>  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
>>>  #endif
>>>  
>>> +/* ifa_protocol */
>>> +#define IFAPROT_UNSPEC	0
>>
>> *If* the value is just a passthrough (userspace to kernel and back), no
>> need for this uapi. However, have you considered builtin protocol labels
>> - e.g. for autoconf, LLA, etc. Kernel generated vs RAs vs userspace
>> adding it.
> 
> Agreed. For my own (very isolated) use case I only need the passthrough,
> but I can see that it would make sense to standardize some labels.
> I was trying to give this some thought but I have to admit I copped out
> because of my limited knowledge on what labels would be reasonable to
> reserve.
> 
> Based on what you mention, do you think the list bellow would make sense?
> 
> #define IFAPROT_UNSPEC		0  /* unspecified */
> #define IFAPROT_KERNEL_LO	1  /* loopback */
> #define IFAPROT_KERNEL_RA	2  /* auto assigned by kernel from router announcement */
> #define IFAPROT_KERNEL_LL	3  /* link-local set by kernel */

Those above look good to me.

> #define IFAPROT_STATIC		4  /* set by admin */
> #define IFAPROT_AUTO		5  /* DHCP, BOOTP etc. */
> #define IFAPROT_LL		6  /* link-local set by userspace */
> 
> Or do you think it needs more granularity?

anything coming from userspace can just be a passthrough, so protocol
label is only set if it is an autonomous action by the kernel or some
app passed in a value.
