Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3E440EB1
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhJaNmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 09:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhJaNmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 09:42:49 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3C2C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 06:40:18 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id bq14so2738165qkb.1
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0vKOcpsgo0AUN0CmEYGcLIeEZ0oSg1/GfMh8jB3vgvg=;
        b=WI2P7rCGu5PyYtJB0rv2L6uQhIWO66l6fforhV6ep7kAbUS/6jnOQi9IFRTJ/Rw7Dp
         HTUvRgm0O6ryXWFdE5Qv4x7Dssu2/hNUKQ6WxVaLfhWO/pkA33A3B/fDa0mDkQOWKN1L
         hUvzOWZn2TUa5gPHe1LnCAWinPIRB0slfptAYYhcgpKp+78S3Sb8bL6pgPQLM/oyVgNy
         kr5otqQFRxTyJl9L1N03qFADECXVAG6LVTI4PSwY7E/JmIu3mc/nnBOAPPqIgHmXGaMY
         Mm4SWFp+MtUFbEUrGFrkXcvIBA+8/HAEf5VLog9ZnClOV72/S21b7pwen7qVw4zIgdPu
         nnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0vKOcpsgo0AUN0CmEYGcLIeEZ0oSg1/GfMh8jB3vgvg=;
        b=zxcpXv4d6CkOosQm7nLyusBC+0LyxFJeho2KLpEUi9WH0Y4ZPWhD0trOmfKID0Y2qs
         +4fTz6QnKJdfi/2LHUw/jT8xjjcelF9cwQFXIYWE5MHdKenWt5o9aGsieSiEHzbuvgtb
         gPsf1KJDDlyQ1GUxFc1Zvlq7q9HZrWGApUs+k//KIzrAagwJsPB9Ur2kkgRYwpS6Mbj0
         166PLfexrzL+7WMfz6I76pKu2ozD8r+U8UCjp+y7ttc3u7T+S+6Du6fUtCFwp8aLFfHr
         +jOF1rfNb/7zdyHmqEVBM5Z9ABv4WbSV8YneTY5m8iseqRPq9hIEgtgdhGZjHlbWWlz+
         jFmw==
X-Gm-Message-State: AOAM533l0HN3qBJDMAbqEaoiCX6QKjM7skI6EdcGjpUG4EvNfmX45EVT
        YcIaKWe9T1OGyZQ22tzrMF0kFA==
X-Google-Smtp-Source: ABdhPJz2DKJgiNmlyA1U1Zn9S218ZZPkjcv7FMO6FijYOUm7RZFlHzkgUDUUj75zcj4rghqqOK1Ukw==
X-Received: by 2002:a05:620a:1999:: with SMTP id bm25mr18508319qkb.40.1635687617447;
        Sun, 31 Oct 2021 06:40:17 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id h19sm8733263qtb.18.2021.10.31.06.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 06:40:17 -0700 (PDT)
Message-ID: <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
Date:   Sun, 31 Oct 2021 09:40:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
To:     Oz Shlomo <ozsh@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-31 05:50, Oz Shlomo wrote:
> 
> 
> On 10/28/2021 2:06 PM, Simon Horman wrote:
>> Baowen Zheng says:
>>
>> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to 
>> offload
>> tc actions independent of flows.
>>
>> The motivation for this work is to prepare for using TC police action
>> instances to provide hardware offload of OVS metering feature - which 
>> calls
>> for policers that may be used by multiple flows and whose lifecycle is
>> independent of any flows that use them.
>>
>> This patch includes basic changes to offload drivers to return EOPNOTSUPP
>> if this feature is used - it is not yet supported by any driver.
>>
>> Tc cli command to offload and quote an action:
>>
>> tc qdisc del dev $DEV ingress && sleep 1 || true
>> tc actions delete action police index 99 || true
>>
>> tc qdisc add dev $DEV ingress
>> tc qdisc show dev $DEV ingress
>>
>> tc actions add action police index 99 rate 1mbit burst 100k skip_sw
>> tc actions list action police
>>
>> tc filter add dev $DEV protocol ip parent ffff:
>> flower ip_proto tcp action police index 99
>> tc -s -d filter show dev $DEV protocol ip parent ffff:
>> tc filter add dev $DEV protocol ipv6 parent ffff:
>> flower skip_sw ip_proto tcp action police index 99
>> tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
>> tc actions list action police
>>
>> tc qdisc del dev $DEV ingress && sleep 1
>> tc actions delete action police index 99
>> tc actions list action police
>>
> 
> Actions are also (implicitly) instantiated when filters are created.
> In the following example the mirred action instance (created by the 
> first filter) is shared by the second filter:
> 
> tc filter add dev $DEV1 proto ip parent ffff: flower \
>      ip_proto tcp action mirred egress redirect dev $DEV3
> 
> tc filter add dev $DEV2 proto ip parent ffff: flower \
>      ip_proto tcp action mirred index 1
> 
> 

I sure hope this is supported. At least the discussions so far
are a nod in that direction...
I know there is hardware that is not capable of achieving this
(little CPE type devices) but lets not make that the common case.

cheers,
jamal
