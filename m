Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E86963BBB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGITM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:12:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43215 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfGITM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:12:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so9927742pgv.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 12:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3W5ihE6b7lwSLN5YH+LdxAcACxBg8AJ/eCIOLcWrvvQ=;
        b=U2emgQaHaKiT8y7LXSoXbiC+WjT1EJBSmdEqOWrjdzSg6Esetqf7wXv98FJTHCiB9G
         5UNdvwH2UJfoYSaq52wY9nQ40fttyFY+WqQ3MNfR2ihFuHPUuKvRhaR2J9NCfo50keru
         F+BsatMtAgWuijvatUkxMszU+kjfunuoIwnT4vUgmp9KxH3a7sJ5Dvnn4N75YDEgY5AB
         Pyz6e2Bf87CFhShAkol65PYkyIQ5VOnojlmpQIQUvMxyj9Iw+MHQBXcWJGS7/cXLpn2Z
         zVzs28R5Sv8Wc9JAc5ZcJF5a+JLrPuTtRysSOKK05L74lkICnoRBKGiyWzSs2Nx/ecVs
         1/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3W5ihE6b7lwSLN5YH+LdxAcACxBg8AJ/eCIOLcWrvvQ=;
        b=AdUGpUTP56jW+99Xg8UKmysfiRHonpTN0HX2wT7Sa4G1ZL+24dO+CqbvvBHL3ZM6+h
         uiQPpHkyxvRHdQPV5BJmdKfRfRxqmIVgvuamtuGTNscg9e5QzWdZOlWRcjoKI71V56p2
         wSCZKCuGy6BjOeQKCqSHznnj1cGmkJ+rZAt4CW/qxtNf1YnuxFlZFeeSjLky1HQlWRsJ
         Fr9yhY51aIUKM9JQz3/NPWLG3VIcK6Z6ZDmN6qDr/jWwy4hOTsC267tqf2NsOwmVAGLc
         6wrX93Mi/nCRM20sVOIh47gCi5ELH8fc/DoPmfKNBmWX8dGWhx7cXZyms+7lPTerE2LB
         380w==
X-Gm-Message-State: APjAAAXgVIVSRnQtXEG6wZ77fk6TVYZjmtlyE66LAuzGggsr4/BEeg11
        wWaj3SAsY7g5HhbLp3EXIG5Sc7r6XGk=
X-Google-Smtp-Source: APXvYqzwz7HRhwQ8cXv/pUfpjVMNN0wGRUveYePy0gPwtCj6XqY52SEJCYb0Cb2pQflynGVXhe6t2Q==
X-Received: by 2002:a63:e807:: with SMTP id s7mr31430143pgh.194.1562699577092;
        Tue, 09 Jul 2019 12:12:57 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id a3sm23283218pfi.63.2019.07.09.12.12.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 12:12:56 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
 <af206309-514d-9619-1455-efc93af8431e@pensando.io>
 <20190708200350.GG2282@nanopsycho.orion>
 <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
 <20190709065620.GJ2282@nanopsycho.orion>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0ae90b8d-5c73-e60d-8e56-5f6f56331e1a@pensando.io>
Date:   Tue, 9 Jul 2019 12:13:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190709065620.GJ2282@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 11:56 PM, Jiri Pirko wrote:
> Tue, Jul 09, 2019 at 12:58:00AM CEST, snelson@pensando.io wrote:
>> On 7/8/19 1:03 PM, Jiri Pirko wrote:
>>> Mon, Jul 08, 2019 at 09:58:09PM CEST, snelson@pensando.io wrote:
>>>> On 7/8/19 12:34 PM, Jiri Pirko wrote:
>>>>> Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>>>>>> +
>>>>>> +static const struct devlink_ops ionic_dl_ops = {
>>>>>> +	.info_get	= ionic_dl_info_get,
>>>>>> +};
>>>>>> +
>>>>>> +int ionic_devlink_register(struct ionic *ionic)
>>>>>> +{
>>>>>> +	struct devlink *dl;
>>>>>> +	struct ionic **ip;
>>>>>> +	int err;
>>>>>> +
>>>>>> +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
>>>>> Oups. Something is wrong with your flow. The devlink alloc is allocating
>>>>> the structure that holds private data (per-device data) for you. This is
>>>>> misuse :/
>>>>>
>>>>> You are missing one parent device struct apparently.
>>>>>
>>>>> Oh, I think I see something like it. The unused "struct ionic_devlink".
>>>> If I'm not mistaken, the alloc is only allocating enough for a pointer, not
>>>> the whole per device struct, and a few lines down from here the pointer to
>>>> the new devlink struct is assigned to ionic->dl.  This was based on what I
>>>> found in the qed driver's qed_devlink_register(), and it all seems to work.
>>> I'm not saying your code won't work. What I say is that you should have
>>> a struct for device that would be allocated by devlink_alloc()
>> Is there a particular reason why?  I appreciate that devlink_alloc() can give
>> you this device specific space, just as alloc_etherdev_mq() can, but is there
> Yes. Devlink manipulates with the whole device. However,
> alloc_etherdev_mq() allocates only net_device. These are 2 different
> things. devlink port relates 1:1 to net_device. However, devlink
> instance can have multiple ports. What I say is do it correctly.

So what you are saying is that anyone who wants to add even the smallest 
devlink feature to their driver needs to rework their basic device 
memory setup to do it the devlink way.  I can see where some folks may 
have a problem with this.

>
>
>> a specific reason why this should be used instead of setting up simply a
>> pointer to a space that has already been allocated?  There are several
>> drivers that are using it the way I've setup here, which happened to be the
>> first examples I followed - are they doing something different that makes
>> this valid for them?
> Nope. I'll look at that and fix.
>
>
>>> The ionic struct should be associated with devlink_port. That you are
>>> missing too.
>> We don't support any of devlink_port features at this point, just the simple
>> device information.
> No problem, you can still register devlink_port. You don't have to do
> much in order to do so.

Is there any write-up to help guide developers new to devlink in using 
the interface correctly?  I haven't found much yet, but perhaps I've 
missed something.  The manpages are somewhat useful in showing what the 
user might do, but they really don't help much in guiding the developer 
through these details.

sln

