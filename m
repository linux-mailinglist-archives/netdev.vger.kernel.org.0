Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA5D651A9C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLTGXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLTGXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:23:00 -0500
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEFF13E04;
        Mon, 19 Dec 2022 22:22:59 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id i9so16096516edj.4;
        Mon, 19 Dec 2022 22:22:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XzGIMiqBhgv2PEcRSAgBf4utolAOX1ZbZTjBRd5KR8=;
        b=sbtQoTJgFQbHKfoHOksLXUXVqNNH2iWMpxwp1k2cg1T9aicLUVlCXy4ttLL9YOY4HT
         PfFGMP9ZYAOL81KEKYyGStf8i8gmy8Vd2t4h6lCEW3NThpTR+B52xu+F8i9xfpoBDLoW
         ecfPXN1eMoqguiQbaop1HqXd3ANIY6kzlJNfmSshWJVgd7opyyMQLEsdPMH585MoK2Qf
         G5ZG0fd0CkREJMc1VVC8Yr7aSjwAEXLwTq9AaEVJC5U1Vhldr/RBiUQkmtgRGI8VMm9A
         xS1iWTZuqlORtI2WSXaoYKxJPDkG8pViS3gKXzLp9dT3iR5jQJDebZ5urxYNBkTRpoQO
         J0tA==
X-Gm-Message-State: ANoB5pk8rbzy4AlYYlxc64pA06nF2oDhinpI3By9AbHRuA0ey0Q4rXhW
        OPu45TAOSHI0KzTbpXINxZU=
X-Google-Smtp-Source: AA0mqf4LkyJ1sXaUUIBNHxX9lqV96cttdjk6fczG6Dfw6cJDawsRWCp9dsjUBdMHxDaGbE5KikJbbg==
X-Received: by 2002:a05:6402:205c:b0:46d:c48c:50eb with SMTP id bc28-20020a056402205c00b0046dc48c50ebmr55319962edb.13.1671517378271;
        Mon, 19 Dec 2022 22:22:58 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id p26-20020a056402045a00b004610899742asm5215572edw.13.2022.12.19.22.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 22:22:57 -0800 (PST)
Message-ID: <5bb57ae6-c2a7-e6ea-3fe8-62b8b61bc7c5@kernel.org>
Date:   Tue, 20 Dec 2022 07:22:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PULL] Networking for next-6.1
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, joannelkoong@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com
References: <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
 <20221218232547.44526-1-kuniyu@amazon.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221218232547.44526-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19. 12. 22, 0:25, Kuniyuki Iwashima wrote:
> From:   Jiri Slaby <jirislaby@kernel.org>
> Date:   Fri, 16 Dec 2022 11:49:01 +0100
>> Hi,
>>
>> On 04. 10. 22, 7:20, Jakub Kicinski wrote:
>>> Joanne Koong (7):
>>
>>>         net: Add a bhash2 table hashed by port and address
>>
>> This makes regression tests of python-ephemeral-port-reserve to fail.
>>
>> I'm not sure if the issue is in the commit or in the test.
> 
> Hi Jiri,
> 
> Thanks for reporting the issue.
> 
> It seems we forgot to add TIME_WAIT sockets into bhash2 in
> inet_twsk_hashdance(), therefore inet_bhash2_conflict() misses
> TIME_WAIT sockets when validating bind() requests if the address
> is not a wildcard one.
> 
> I'll fix it.

Hi,

is there a fix for this available somewhere yet?

thanks,
-- 
js
suse labs

