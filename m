Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD39E58F73C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiHKFTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHKFTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:19:06 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E81D84EEF;
        Wed, 10 Aug 2022 22:19:05 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id kb8so31584944ejc.4;
        Wed, 10 Aug 2022 22:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=gMjB2N9R7Ro3z4ByOfxiwvDwPmV80AzSjsbNAujyymc=;
        b=EDnpe94fy9hexdLasFPbvwUcaDB/QG8qmVrOKN6us4Zo/cknDKJM7k11Dxq1k4Emkd
         8uVzu1W23d6uS8vBpSSUyYhDbWzI84Pjd4M9bw95eQKlSKlI8bK+765UoRgPUxQ+2vQy
         GquZDb52LxbdS2DQkPsa0KANObF9z8lp60a1qhOy6/liPfeBi7UhFwe+w0UTYKTDL7sn
         rAQNo3RVD6NVS3bp8eOlQDIsjqESqFLVPV8rmIaj8AZEXt5ukMmN4ZbIhZZleFCSY+ZS
         v7qe71Jb50bhbni1mR4BrH1GsvCVqtbJ2iibifYv7ed5MfneH1vMPnqFxnx/ccrXGdGJ
         Lkgw==
X-Gm-Message-State: ACgBeo39FIDXof1YklN4JAbj3AeT3/sbkRACMeR3wELUuSGBWCFGc7rV
        nRSm3j5H/7UVkuaOfPsYzrTVFvqy/R0=
X-Google-Smtp-Source: AA6agR7fQAAEuVDKG4I0mAiXnJNN74aBQiXQlUXkvXkUdLdEXnuE0Q7aAXo6037qgASxgG7zftsTug==
X-Received: by 2002:a17:906:e8f:b0:730:9480:9728 with SMTP id p15-20020a1709060e8f00b0073094809728mr22137532ejf.99.1660195144054;
        Wed, 10 Aug 2022 22:19:04 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id w19-20020aa7dcd3000000b0043d668dec21sm8663577edu.38.2022.08.10.22.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 22:19:03 -0700 (PDT)
Message-ID: <de3170f3-6035-21e4-8ca5-427ca878b3a4@kernel.org>
Date:   Thu, 11 Aug 2022 07:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH net-next 3/6] net: atm: remove support for ZeitNet ZN122x
 ATM devices
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
References: <20220426175436.417283-1-kuba@kernel.org>
 <20220426175436.417283-4-kuba@kernel.org>
 <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org>
 <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
 <20220810094206.36dcfca8@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220810094206.36dcfca8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10. 08. 22, 18:42, Jakub Kicinski wrote:
> On Wed, 10 Aug 2022 11:11:32 +0200 Arnd Bergmann wrote:
>>> This unfortunately breaks linux-atm:
>>> zntune.c:18:10: fatal error: linux/atm_zatm.h: No such file or directory
>>>
>>> The source does also:
>>> ioctl(s,ZATM_SETPOOL,&sioc)
>>> ioctl(s,zero ? ZATM_GETPOOLZ : ZATM_GETPOOL,&sioc)
>>> etc.
>>>
>>> So we should likely revert the below:
>>
>> I suppose there is no chance of also getting the linux-atm package updated
>> to not include those source files, right? The last release I found on
>> sourceforge
>> is 12 years old, but maybe I was looking in the wrong place.
> 
> Is linux-atm used for something remotely modern? PPPoA? Maybe it's
> time to ditch it completely? I'll send the revert in any case.

Sorry, I have no idea. openSUSE is just a provider of an rpm -- if there 
any users? Who knows...

thanks,
-- 
js
suse labs

