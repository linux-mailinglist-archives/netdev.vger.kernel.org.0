Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8031A23DC1B
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgHFQqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbgHFQp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:45:56 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1C6C0A3BD0
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 09:45:55 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l64so38726451qkb.8
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 09:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDmsv2V6FvhJ5ZJsgyOmePovP7IYl5Yo5ORIf3cwSkY=;
        b=subWDPPloDIbCUjaO2jVl+li2uBNcORqHylgyArQ0NkXVSa8IegTAnE3xGiYG74ttr
         O0znyk+OiMGNZ8gJt8YXP5hrae4M34rXvLlq1j+4qDUymBfgsnLcdb9uUUqqzlR0mg2d
         ucU06KhLH2UsrwQnliroxEhj7AA9pcXdvTDsH74h73F8faVlxzbIzhzFP2lv45JLj2tW
         kVsoya3FyCN5OGpOa3+bLHzaJTp9ZvF0opddS1hdcE0AtbT6TR/tunCAOJ7Gwx6kzFel
         WjtNJqpzaR4eVdACIldInoKzqw5IkQtaoiFgqaEXhatuTYFEfJ1hncKctDVHV0oWbRon
         DIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDmsv2V6FvhJ5ZJsgyOmePovP7IYl5Yo5ORIf3cwSkY=;
        b=Y13dobsvLk/v+4BHsf4ooIfuo/+o++c6dJxmM6wVa4Srw1+Wxp7/ik74fELQJGxSCL
         bmvmEHdvHj8k3c9wxJWMZWLc+etUQB4MwpDHmNlS9ZvYV8qjQlZSBfdKZ9YFqDKNK/wQ
         9nIUDJyJKHNu0ftQSaWJ1hmaYxGWfXVqL2RpNax5hUtHaUCfxxgOJCH1boKr1wqUoNgT
         uikVqIBjsRooaJc8mWu9UBtL3yY7FXJTWo/hAg1BHkShfG5g+7Ejc9/LFCXVB4UCnKDi
         +3vJtVUOz54rrwbeQlNcst+nsNGoMRIqfeqB7fXF7Y5jyDQlrOKmH6gfutGkpWOg7A21
         IA8Q==
X-Gm-Message-State: AOAM5333COfon7VRocjkQM+qJ0yfdiPZf291oc3a9JI4JlB8IMDjNwPe
        DTCwnHdu2ZHBkxIFBMaNde4=
X-Google-Smtp-Source: ABdhPJxAmVeROza3hEPN9GPpr6mkPQxBjmMAGLGhKIGs3tzm6pMjJ53D/Z6NkG9JqannNOcDJz5S+A==
X-Received: by 2002:a05:620a:1594:: with SMTP id d20mr8383133qkk.242.1596732355117;
        Thu, 06 Aug 2020 09:45:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7c83:3cd:b611:a456? ([2601:282:803:7700:7c83:3cd:b611:a456])
        by smtp.googlemail.com with ESMTPSA id 78sm4630575qke.81.2020.08.06.09.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 09:45:54 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXSBjYW4gY3VycmVudCBFQ01QIGltcGxl?=
 =?UTF-8?Q?mentation_support_consistent_hashing_for_next_hop=3f?=
To:     Ido Schimmel <idosch@idosch.org>
Cc:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
 <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
 <20200802144959.GA2483264@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c965294-fe7d-3893-e9d9-3354ff508731@gmail.com>
Date:   Thu, 6 Aug 2020 10:45:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200802144959.GA2483264@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/20 8:49 AM, Ido Schimmel wrote:
> On Thu, Jun 11, 2020 at 10:36:59PM -0600, David Ahern wrote:
>> On 6/11/20 6:32 PM, Yi Yang (杨燚)-云服务集团 wrote:
>>> David, thank you so much for confirming it can't, I did read your cumulus document before, resilient hashing is ok for next hop remove, but it still has the same issue there if add new next hop. I know most of kernel code in Cumulus Linux has been in upstream kernel, I'm wondering why you didn't push resilient hashing to upstream kernel.
>>>
>>> I think consistent hashing is must-have for a commercial load balancing solution, otherwise it is basically nonsense , do you Cumulus Linux have consistent hashing solution?
>>>
>>> Is "- replacing nexthop entries as LB's come and go" ithe stuff https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hashing is showing? It can't ensure the flow is distributed to the right backend server if a new next hop is added.
>>
>> I do not believe it is a problem to be solved in the kernel.
>>
>> If you follow the *intent* of the Cumulus document: what is the maximum
>> number of load balancers you expect to have? 16? 32? 64? Define an ECMP
>> route with that number of nexthops and fill in the weighting that meets
>> your needs. When an LB is added or removed, you decide what the new set
>> of paths is that maintains N-total paths with the distribution that
>> meets your needs.
> 
> I recently started looking into consistent hashing and I wonder if it
> can be done with the new nexthop API while keeping all the logic in user
> space (e.g., FRR).
> 
> The only extension that might be required from the kernel is a new
> nexthop attribute that indicates when a nexthop was last recently used.

The only potential problem that comes to mind is that a nexthop can be
used by multiple prefixes.

But, I'm not sure I follow what the last recently used indicator gives
you for maintaining flows as a group is updated.

> User space can then use it to understand which nexthops to replace when
> a new nexthop is added and when to perform the replacement. In case the
> nexthops are offloaded, it is possible for the driver to periodically
> update the nexthop code about their activity.
> 
> Below is a script that demonstrates the concept with the example in the
> Cumulus documentation. I chose to replace the individual nexthops
> instead of creating new ones and then replacing the group.

That is one of the features ... a group points to individual nexthops
and those can be atomically updated without affecting the group.

> 
> It is obviously possible to create larger groups to reduce the impact on
> existing flows when a new nexthop is added.
> 
> WDYT?

This is inline with my earlier responses, and your script shows an
example of how to manage it. Combine it with the active-backup patch set
and you handle device events too (avoid disrupting size of the group on
device events).

