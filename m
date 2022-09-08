Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB865B23AB
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiIHQfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIHQfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:35:08 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E0842AFD
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:35:06 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l5so13320635qtv.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NxFhENTCp8sPm6qiLhptK7iAPt+bokv+FjgpHvLq8do=;
        b=dcrnJqqMlxY83H5WGvsNkUKpgMveZXbRmJtwn9dsyfT4CE/1XJuAzitJHK3ORsqhJq
         8ANs48gyQ33kFcNrHQM38w1/BBP8QPaLHjTpEYD9bc0NHgS44AxjsNtzQCHhLJGu73oC
         7LZw8eSPJXJgiaZsPrVjcCbZTbtB97wXcDS5wZfBaj70BWO7iF7JsK+58/sowU7nlqL/
         ZcB1PvFSoNqIT45Wz9kdIqZ2PKdcE/9DsknKZSOtMP9BLP/xuX6qBwxT9bfh2FodpAxA
         m8DgPREFPx8NrSh7rQPM2FbSQcsy/c5edS/wv0Zuq37aGmuNshKw4rIFGBU17fgVC8Le
         w2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NxFhENTCp8sPm6qiLhptK7iAPt+bokv+FjgpHvLq8do=;
        b=sef608+PLQV8YUbJMH9+fnkkRnxV+uSjZknnzeBo9w+ErYdYTDaHtwjvCuMtuFShdz
         8k5gaTLRn5U3N7wZuCQsUCQVCDcQWeV59NgzWIqzJtDNZHeuX+K8FAXInMtyk4UwiGER
         m3UyOXxPOJV8Gfj9bpQAJbkICiG0Wr6nfKSdtCYq5b4pN+Ad0QWokI7xhWVf03dNowby
         7M7fJteBjttvRvz2d39DmdUSFlPHlfM0WbvnrYoTUPIv7zBCzNhNO/MP2wNYUJkuw3vX
         U583PkHtRfcEJygMPrf9ywXw8ZmDHyzauCWLDXdSyQaxeUDbnC8z3fniInYqlN14zABq
         Fcyg==
X-Gm-Message-State: ACgBeo1qOQhmpmdZxVIPXx3iK51G7mJ+KHXy+cZWMMY1i1J0JHcwecXe
        Zz9phoWHrGEv2SvH2PE4n267SBsqQYc=
X-Google-Smtp-Source: AA6agR4Px0J1MWEdS6aHmcBy4aMNA7tOfFzKz5c6D+UG/bXzqtQ8rYSV58xlfYUEEOr4GWBaA6OQcQ==
X-Received: by 2002:ac8:5901:0:b0:344:5846:129e with SMTP id 1-20020ac85901000000b003445846129emr8880419qty.469.1662654905914;
        Thu, 08 Sep 2022 09:35:05 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h26-20020ac846da000000b003450358fe82sm14364087qto.76.2022.09.08.09.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 09:35:05 -0700 (PDT)
Message-ID: <857e2dd4-cbc6-613c-c8e1-b3ff5d13dc47@gmail.com>
Date:   Thu, 8 Sep 2022 09:35:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220908125117.5hupge4r7nscxggs@skbuf>
 <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
 <20220908072519.5ceb22f8@hermes.local>
 <20220908161104.rcgl3k465ork5vwv@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220908161104.rcgl3k465ork5vwv@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URI_DOTEDU autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2022 9:11 AM, Vladimir Oltean wrote:
> On Thu, Sep 08, 2022 at 07:25:19AM -0700, Stephen Hemminger wrote:
>> On Thu, 8 Sep 2022 08:08:23 -0600 David Ahern <dsahern@kernel.org> wrote:
>>>> Proposing any alternative naming raises the question how far you want to
>>>> go with the alternative name. No user of DSA knows the "conduit interface"
>>>> or "management port" or whatnot by any other name except "DSA master".
>>>> What do we do about the user-visible Documentation/networking/dsa/configuration.rst,
>>>> which clearly and consistently uses the 'master' name everywhere?
>>>> Do we replace 'master' with something else and act as if it was never
>>>> named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
>>>> UAPI and explain in the documentation "oh yeah, that's how you change
>>>> the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
>>>> then?" "Well...."
>>>>
>>>> Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
>>>> also change that to reflect the new terminology, or do we just have
>>>> documentation stating one thing and the code another?
>>>>
>>>> At this stage, I'm much more likely to circumvent all of this, and avoid
>>>> triggering anyone by making a writable IFLA_LINK be the mechanism through
>>>> which we change the DSA master.
>>>
>>> IMHO, 'master' should be an allowed option giving the precedence of
>>> existing code and existing terminology. An alternative keyword can be
>>> used for those that want to avoid use of 'master' in scripts. vrf is an
>>> example of this -- you can specify 'vrf <device>' as a keyword instead
>>> of 'master <vrf>'
>>
>> Agreed, just wanted to start discussion of alternative wording.
> 
> So are we or are we not in the clear with IFLA_DSA_MASTER and
> "ip link set ... type dsa master ..."? What does being in the clear even
> mean technically, and where can I find more details about the policy
> which you just mentioned? Like is it optional or mandatory, was there
> any public debate surrounding the motivation for flagging some words,
> how is it enforced, are there official exceptions, etc?

The "bonding" driver topic has some good context:

https://lkml.iu.edu/hypermail/linux/kernel/2010.0/02186.html
-- 
Florian
