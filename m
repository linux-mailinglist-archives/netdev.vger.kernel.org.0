Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7792B21898E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgGHNyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 09:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgGHNyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 09:54:18 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7D0C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 06:54:18 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z63so41486935qkb.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 06:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7QTdmCV7uJI09EUvoJaGnkyF1y38CQHgo+7lXY70zZE=;
        b=AHK3MYE4/CwM9kmd2/YleKd/eqpUOpBTPPiSioeG4GhDBpMqWgsEZJ4pFuDeE6N/es
         8sVf96pLZj/+2GA45kJrtqID+cuVJJhTJu4i3+5ADDfWPe8HPRlg8NWdVfyPIAIe6Lyn
         BlGRh+c5GAhY9/Syssq61AxcCAB8/N0GNuxLCCERgSJxk6ftVgN1NPkxClw7rYZQwIPc
         5hQxPLag2HWaLHTn6KaPaNuvWsmKAx4lHDGdPiMzJ2Qk7usgXmhVJbZLCQ1vnJyRkbFc
         Jo3BkNFeCzEy+R+VV5FRz9r3xXxlmNvgmplWXj4OLoks8NfKqE0cvKUemc4RKKl34mI5
         ddSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7QTdmCV7uJI09EUvoJaGnkyF1y38CQHgo+7lXY70zZE=;
        b=i3LYKdBxrdx0rVNWByALZevl10TtL0vR2yrrWt1ycUcEGgUckC2C7tc4wdI4j+IQDT
         a2CtCciUU3euXyjtVN7RiGj0zkcnuSkeYYRVWPQduhVHFGufMqfWFeoKdUIsBZklavzE
         bS2phf0EprE9HwqGwx+GGtwSHD2geMXHWYieFHMODEwVCUSETlGXPF5GxyMWeHlQ6H4A
         R4/jlTwOpemuG2tZpdyDC1C1rZ5/OClU/KmnATBTg9CB1V84fGShXLkZOHexJBuDIYzM
         7AFcqHyO7xheFkRMb3cjNLi+g2LqHKNrtjHetfPngssOK213ghslA7FLkSLr4zx7rkXO
         QD5A==
X-Gm-Message-State: AOAM531HohZFgsYFzZXg8ihj4mZn7dbNjWcNzSYQzpz6MA9zllndsz93
        KgLyYGtBllweycKSnOMJqred0g==
X-Google-Smtp-Source: ABdhPJy7xTV8OmnEc4++p6pUrj7gUcJsBNVj7KvhXgR/i95WLvrrI0Tr1C57LiM5xfbNn9kiwjt0GA==
X-Received: by 2002:a37:a711:: with SMTP id q17mr57402823qke.257.1594216457795;
        Wed, 08 Jul 2020 06:54:17 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id e25sm28048105qtc.93.2020.07.08.06.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 06:54:16 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <20200707100556.GB2251@nanopsycho.orion>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
Date:   Wed, 8 Jul 2020 09:54:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707100556.GB2251@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-07 6:05 a.m., Jiri Pirko wrote:
> Fri, Jul 03, 2020 at 01:22:47PM CEST, jhs@mojatatu.com wrote:
>> Hi,
>>
>> Several comments:
>> 1) I agree with previous comments that you should
>> look at incorporating this into skbedit.
>> Unless incorporating into skbedit introduces huge
>> complexity, IMO it belongs there.
>>
>> 2) I think it would make sense to create a skb hash classifier
>> instead of tying this entirely to flower i.e i should not
>> have to change u32 just so i can support hash classification.
> 
> Well, we don't have multiple classifiers for each flower match, we have
> them all in one classifier.

Packet data matches, yes - makes sense. You could argue the same for
the other classifiers.

> It turned out to be very convenient and
> intuitive for people to use one classifier to do the job for them.

IMO:
For this specific case where _offload_ is the main use case i think
it is not a good idea because flower on ingress is slow.
The goal of offloading classifiers to hardware is so one can reduce
consumed cpu cycles on the host. If the hardware
has done the classification for me, a simple hash lookup of the
32 bit skbhash(similar to fw) in the host would be a lot less
compute intensive than running flower's algorithm.

I think there is a line for adding everything in one place,
my main concern is that this feature this is needed
by all classifiers and not just flower.


> Modularity is nice, but useability is I think more important in this
> case. Flower turned out to do good job there.
> 

For humans, agreed everything in one place is convinient.
Note: your arguement could be used for "ls" to include "grep"
functionality because in my scripts I do both most of the time.

cheers,
jamal



> + Nothing stops you from creating separate classifier to match on hash
> as you wanted to :)
> 
>
