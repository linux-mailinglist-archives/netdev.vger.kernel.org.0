Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C282FE8
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732664AbfHFKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:44:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43583 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbfHFKo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:44:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id w17so3369270qto.10
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 03:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l+OYD4TuORNiWBhVtCP+A7co6yo5d194v1Fm1oVg7XU=;
        b=ABMXvHr9nXN23lcR/HKAIyY9Lc77HeYFd5p26BVRouK6ycAo8RZpnYXRt7P25F70X3
         k5GjCNI2SfRcIj8ZZ9YuDiAsKYhlroxJlOhp3JxWUCU6Q/WEKAG90o2Bs7Ub01Rono5P
         bgsaIqbS/YvmcKpchNeSobD5uTgm5mePQvKmgK8ibad0vVHslUB5mdWoKyVetbLaLO1s
         7U7xEN9ftdZZticq/l1Fz3AWLgYCK83tXMi37szWqiqCyj6XlzNU/0FhZY30gS6HfYWm
         Oa72dE6lrcMOFmqYddYD7JMba7KUNrtOB/OQfFWnnYDhp4hAGKS+5LLBjT9ZsMbNlTel
         bdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l+OYD4TuORNiWBhVtCP+A7co6yo5d194v1Fm1oVg7XU=;
        b=kpx/crTVOWtzAXgZo1V97FmskLxe6RuYve/E29yMMBcvykcLcAqO/4q67UCD8ik2bh
         StGsvHFfTQSaQhxHHwUU8i11sJfbtJriBRqnyoYEbqXptQxB5FLbUvzlGBph17jqHH2C
         vFbGd0O0Com6oO91ZBX57oUDx8/ijBbIStEftjbyZfq0/ag976tT1kzVxCmaC/U+X/Zo
         pyXuCwJZGTZyBRHDwiYgUF1ghhx1vom+laY/lqDhMeV/hGO0Pfesxlr7NlXcHYhK2aHS
         /Ieso0iHOzz48RKcukd8OVFnWCgLH0sRyEw5QYVJidn77Dd5gzRyCBoTleGD1uSEQBnt
         sbaA==
X-Gm-Message-State: APjAAAWtt07wTHElx1MILaxQlCSWaTVk5MsC6gS56EvyPSU2P14BHXcB
        vKi6qIN4pubR4s+1K0UKRwSw6Ukef98=
X-Google-Smtp-Source: APXvYqw80oSUguJgf9K+o+CRg0b+iuqQIY2ufRVvXyMsSclQOd2gAEO3Q5TqHs93nbRj7PrpQUpftA==
X-Received: by 2002:ac8:4705:: with SMTP id f5mr2177540qtp.99.1565088268913;
        Tue, 06 Aug 2019 03:44:28 -0700 (PDT)
Received: from [192.168.0.123] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id a67sm39398843qkg.131.2019.08.06.03.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 03:44:27 -0700 (PDT)
Subject: Re: [PATCH net 0/2] Fix batched event generation for vlan action
To:     Roman Mashak <mrv@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <abe81140-9dce-5373-ce51-2400c1e1cf17@mojatatu.com>
Date:   Tue, 6 Aug 2019 06:44:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-02 3:16 p.m., Roman Mashak wrote:
> When adding or deleting a batch of entries, the kernel sends up to
> TCA_ACT_MAX_PRIO (defined to 32 in kernel) entries in an event to user
> space. However it does not consider that the action sizes may vary and
> require different skb sizes.
> 
> For example, consider the following script adding 32 entries with all
> supported vlan parameters (in order to maximize netlink messages size):
> 
> % cat tc-batch.sh
> TC="sudo /mnt/iproute2.git/tc/tc"
> 
> $TC actions flush action vlan
> for i in `seq 1 $1`;
> do
>     cmd="action vlan push protocol 802.1q id 4094 priority 7 pipe \
>                 index $i cookie aabbccddeeff112233445566778800a1 "
>     args=$args$cmd
> done
> $TC actions add $args
> %
> % ./tc-batch.sh 32
> Error: Failed to fill netlink attributes while adding TC action.
> We have an error talking to the kernel
> %
> 
> patch 1 adds callback in tc_action_ops of vlan action, which calculates
> the action size, and passes size to tcf_add_notify()/tcf_del_notify().
> 
> patch 2 updates the TDC test suite with relevant vlan test cases.

For the  series:
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
