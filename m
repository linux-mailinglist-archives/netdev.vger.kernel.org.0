Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241B7128940
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 14:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLUNpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 08:45:34 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41604 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfLUNpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 08:45:34 -0500
Received: by mail-pg1-f195.google.com with SMTP id x8so6421612pgk.8
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 05:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0JY9FoI8IqX4GEpiO6H7by1oGNz8Mc8iWUGoFvjzGU4=;
        b=EfcBvvUEiXTD58/HgoygPF7hEY+67f3M3icVVY6jmQ0it/ocezZvcsyJr2QqcI6Rp6
         CJbWCVhSshWtkgTQyi/2ctPTc4t/ManKvBbZ0UD+XeY/IEsqyyJIk+yuEdEJg52zySi6
         D6pR77R9pcN0J0+Rwd1viwidW0qQjB08fMP37URHfEh4qZavF9gINSPK2BHXpvVr8eb1
         0MIaPy5l2mNg/ebVkg4KhqJxUTFhg8rI1YRTI1BFq/XFPSBlNY+Eg5n8BFfqV2cmSbAl
         bIRcrt595APpvLdv9YeewOQ5phFZtThLhmDt635KhzQPgVr0EmgZdu3krkzq30y6vW61
         0Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0JY9FoI8IqX4GEpiO6H7by1oGNz8Mc8iWUGoFvjzGU4=;
        b=JvIehbj7qcwocxD53oEdftoNd78fwPFcuBwiLoso6N/XChE1M+FCMVOPp/DJdUMsIB
         GKyQHU2xLxj2ZJ87i4b6iRZQmB8caqvVBUkYaNDbMnbA3GIeqs0sE8UXJDA+4X33DMbo
         9YBm1He1v3TROawhwRfxNGt7mDiLtFHXR22yutEFExJxERuwL42f2OPJ7LIl6e551WOT
         cN5sjLNxvWdWNAPn3VBtpyBUzr8jMHNVH2c5iTVKjgAZ5kHYr52oeGhCGm2UTC0AzAeo
         EKdC3lOqnFw9JPrCh8DarzMhxzrjpuqiJ2wNj5+u6Ae9vmqA2OEuFxh195PVYBcticu0
         ZL0A==
X-Gm-Message-State: APjAAAXxCq7vHvMd8eaXaZNtCeicwpSsdJpyLgUaaee2/kZBicRog3/h
        Mx0pHjg92TosokUb/JaTZkrmQXDm/+WjCw==
X-Google-Smtp-Source: APXvYqztl+Ru2LSIMCIqewmFyGiu3dvYh+Gwm+xs7hxVVLAq13a/Kj1e3sH8FestK9W1yJhCXTRJNA==
X-Received: by 2002:a63:ed49:: with SMTP id m9mr20461252pgk.304.1576935933074;
        Sat, 21 Dec 2019 05:45:33 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x11sm16742701pfn.53.2019.12.21.05.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:45:32 -0800 (PST)
Subject: Re: iwlwifi warnings in 5.5-rc1
To:     Johannes Berg <johannes@sipsolutions.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
 <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
 <bac02c88-6107-7517-0114-e9c369f5fb41@kernel.dk>
 <d907132a16e7bfcd253df088a1d5a1b317c32589.camel@sipsolutions.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9f6db6b5-3953-9f69-15cd-6dc1da54aa80@kernel.dk>
Date:   Sat, 21 Dec 2019 06:45:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d907132a16e7bfcd253df088a1d5a1b317c32589.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/19 2:17 AM, Johannes Berg wrote:
> On Fri, 2019-12-20 at 17:55 -0700, Jens Axboe wrote:
>> On 12/11/19 1:36 AM, Johannes Berg wrote:
>>> On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Since the GRO issue got fixed, iwlwifi has worked fine for me.
>>>> However, on every boot, I get some warnings:
>>>>
>>>> ------------[ cut here ]------------
>>>> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208
>>>
>>> Yeah, we've seen a few reports of this.
>>>
>>> I guess I kinda feel responsible for this since I merged the AQL work,
>>> I'll take a look as soon as I can.
>>
>> Still the case in -git, as of right now. Just following up on this to
>> ensure that a patch is merged to fix this up.
> 
> It's in net/master, so from my POV it's on the way :)

Great! Just wanted to follow up, as I've seen various draft patches
being tossed around, but nothing posted that looked like a final
submission. Guess I just wasn't CC'ed on those.

-- 
Jens Axboe

