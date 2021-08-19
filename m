Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B10E3F1DB7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhHSQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhHSQXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:23:24 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8353C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:22:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v2so9666322edq.10
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sgDW0EeKIbc+tXjRijAMbaibbrP+Mz/1SBwo8s0GZRs=;
        b=bHeGJQpbkzoTrOkfCmMFaZkuTpg5QP5tMmyTlG8ndVg9eD+zGCnzPv7A2aI22Lmxia
         XHL5utpReYqP9T/3rMhb8joLsWDGFSJggm5MFwVMzWxgZC45U5JVUKhOaY6JhEdpbUr0
         PmynGgOCXXPAn8691qSlko5mP/2C94gMR9qK+WBAWJcNVLvffSxSSiBauH+8MNi5Qe4v
         hfQVd7b76yCpAM54eJJaxCO9VpuqbEFS0MqmL80AyPAPTwh6crTMCu8mQsCaJaOc//4M
         UK6gxB62fXVUdjDbnQ0FDopH+swhy+Ly1PclxpHSGQFWHM4eKlqccpyxchnP+z6ap0MI
         Odqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sgDW0EeKIbc+tXjRijAMbaibbrP+Mz/1SBwo8s0GZRs=;
        b=WQ4W011O7P6h3PxBkD5471/BWuPHehQ2S9x3Rlz3GkjtnYxyhEatyhYVlJCi9C0R0W
         UhWnSRC8E50XRwhz3+0zk7yAdMDcWIdn4pRGk7zhZ/v+hxv9y7q2cuv9zpPaKCo9HaG9
         x05zxTlZd6SAxXo+xzGXzbP5fXMZ3b8B1wBYvtGeZ6OqUvDCARuTcgQODoqvcMUyhDcx
         NKdPL+LZ6xZvXfCL7fR4ZcZwe/dOs763Y9zRB+t38GBakEAh/h50ZPqqoXqP+LgTqQg6
         zc+6QhD79MV8pv3aXIbxk7lFuAm40MWLBcbHaE8VhT7tUoOnYsTVYVuVVgi4AXBo3E69
         935Q==
X-Gm-Message-State: AOAM533TVFWjzLkUYReYZHn56g76XKx7cOcInXh0msmeiw7ndYkFA0nC
        /Uw/4/m640f7HxVyU3znHg4I2A==
X-Google-Smtp-Source: ABdhPJwDflUsJEgmQVE8lQzR79B4ronR5T/P3YOz4uDNkODM3tVmRf4z0FcLRzMfN9LtAUjsgZALhw==
X-Received: by 2002:a05:6402:2554:: with SMTP id l20mr17177108edb.252.1629390166253;
        Thu, 19 Aug 2021 09:22:46 -0700 (PDT)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id h10sm1951831edb.74.2021.08.19.09.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:22:45 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: bridge: multicast: add vlan support
To:     Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210719170637.435541-1-razor@blackwall.org>
 <875yw1qv9a.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
Message-ID: <458e3729-0bf0-8c45-9e45-352da76eaeb6@blackwall.org>
Date:   Thu, 19 Aug 2021 19:22:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <875yw1qv9a.fsf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2021 19:01, Joachim Wiberg wrote:
> Hi Hik, everyone!
> 

Hi,
> On Mon, Jul 19, 2021 at 20:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>> This patchset adds initial per-vlan multicast support, most of the code
>> deals with moving to multicast context pointers from bridge/port pointers.
> 
> Awesome work, this looks very interesting! :)  I've already built and
> tested net-next for regressions on Marvell SOHO switches, looking good
> so far.
> 
> Curious, are you planning querier per-vlan, including use-ifaddr support
> as well?  In our in-house hack, which I posted a few years ago, we added
> some "dumpster diving" to inet_select_addr(), but it got rather tricky.
> So I've been leaning towards having that in userspace instead.
> 

Yes, that is already supported (use-ifaddr needs attention though). In my next
patch-set where I added the initial global vlan mcast options I added control
for per-vlan querier with per-vlan querier elections and so on. The use-ifaddr
needs more work though, that's why I still haven't added that option. I need
to add the per-vlan/port router control option so we'll have mostly everything
ready in a single release.

>> Future patch-sets which build on this one (in order):
>>  - iproute2 support for all the new uAPIs
> 
> I'm very eager to try out all the new IGMP per-VLAN stuff, do you have
> any branch of the iproute2 support available yet for testing?  For now
> I've hard-coded BROPT_MCAST_VLAN_SNOOPING_ENABLED in br_multicast_init()
> as a workaround, and everything seems to work just as expected :-)

I don't have it public yet because I need to polish the support, currently
it's very rough, enough for testing purposes for these patch-sets. :)
I plan to work on that after I finish with the per-vlan/port router control.

> 
> Best regards
>  /Joachim
> 

Thanks,
 Nik

