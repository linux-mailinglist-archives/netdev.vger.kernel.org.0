Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EF5219FE2
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGIMTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 08:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgGIMTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 08:19:22 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AE0C061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 05:19:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so1561501wmg.1
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 05:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rHUX9k/QZQL3wbZQqkLrYTPwl6GOZUQVnsjlbkZujZ4=;
        b=WbdWQjvZ861Nc4R1IA8l70iKZc0gFdHA8ahAD+E+sMxVwMMbMBpNeD8X9j/8+l8GHn
         82mzIpay/OiipI1cwGXz77o474wmWhTs/lKhjJBY2JjoeNXR3yEoYYG9kdyfyajU7TVY
         81vs3QC6zTNyy5/TRKXExYAqAKKsCb8/Jj9briw/WcLBAehO6PjqnP9niL2SihYMFLxJ
         pXdksFyH8XpD4LRD4wYL1MP90yRHosShilcAU6XyL4bsiQH0tLR4U/ImfQCo5s/DcH41
         yNDb7lcN7TBBZGp9bmf+E0PYSJKRgwOyKuIRu2VpNPG1do/u6AhyGhcUtbZxCYQ7li9+
         NTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rHUX9k/QZQL3wbZQqkLrYTPwl6GOZUQVnsjlbkZujZ4=;
        b=Nj/a+QAVU/xV6ws6eLCb0vDY9UNZy3Z5jlR27G+HVxSIcYvR7XI7pIar6MvaCcA0lv
         MWrxjjQ6GhjWIum1AhecGym0jYc4g12Rb5fsfV/pV/RzGnl2TURk6Bb/D/nbylPDr/hg
         kSBNqydGD5VrSqWDvWaVKs6vIPefysZ0LYBts+F7CSJ4UepFLQQ8bcnAhd87m44mXXox
         0F5ikmbmDwT+raMxCIqmZ1XSk9owaZU8ds+WycnwKTEgdqORNepjT0/3UXcmTYn/Yv2j
         hit3bw6HrgnNcO640dvYbXV7XADebBdSpRONzl1yvOI7M/5APurXhT70vm9g4KR/IGUs
         zQHQ==
X-Gm-Message-State: AOAM531+oXIDKTwVLJn6fmZ8xNTJHm2czQ88yB7TnGZ0sUSxs1ts7KSy
        ZKczxCnjP8UkKD1yYEZaBliGtg==
X-Google-Smtp-Source: ABdhPJz+EMD4Y5P6/UX+7QKS6of15PTByKQEAvNLPZXf7oAb7lr5HAxjK+Z5srdVIPs9sYHz0tbJuQ==
X-Received: by 2002:a05:600c:4109:: with SMTP id j9mr13502220wmi.157.1594297161196;
        Thu, 09 Jul 2020 05:19:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r28sm4973267wrr.20.2020.07.09.05.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 05:19:20 -0700 (PDT)
Date:   Thu, 9 Jul 2020 14:19:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
Message-ID: <20200709121919.GC3667@nanopsycho.orion>
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <20200707100556.GB2251@nanopsycho.orion>
 <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
 <20200708144508.GB3667@nanopsycho.orion>
 <908144ff-315c-c743-ed2e-93466d40523c@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <908144ff-315c-c743-ed2e-93466d40523c@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 09, 2020 at 01:00:26PM CEST, jhs@mojatatu.com wrote:
>On 2020-07-08 10:45 a.m., Jiri Pirko wrote:
>> Wed, Jul 08, 2020 at 03:54:14PM CEST, jhs@mojatatu.com wrote:
>> > On 2020-07-07 6:05 a.m., Jiri Pirko wrote:
>
>
>[..]
>> > IMO:
>> > For this specific case where _offload_ is the main use case i think
>> > it is not a good idea because flower on ingress is slow.
>> 
>> Eh? What do you mean by that?
>> 
>> 
>> > The goal of offloading classifiers to hardware is so one can reduce
>> > consumed cpu cycles on the host. If the hardware
>> > has done the classification for me, a simple hash lookup of the
>> > 32 bit skbhash(similar to fw) in the host would be a lot less
>> > compute intensive than running flower's algorithm.
>> 
>> It is totally up to the driver/fw how they decide to offload flower.
>> There are multiple ways. So I don't really follow what do you mean by
>> "flower's algorithm"
>> 
>
>Nothing to do with how a driver offloads. That part is fine.
>
>By "flower's algorithm" I mean the fact you have to parse and
>create the flow cache from scratch on ingress - that slows down
>the ingress path. Compare, from cpu cycles pov, to say fw

Could you point to the specific code please?

The skb->hash is only accessed if the user sets it up for matching.
I don't understand what slowdown you are talking about :/


>classifier which dereferences skbmark and uses it as a key
>to lookup a hash table.
>An skbhash classifier would look the same as fw in its
>approach.
>subtle point i was making was: if your goal was to save cpu cycles
>by offloading the lookup(whose result you then use to do
>less work on the host) then you need all the cycles you can
>save.
>
>Main point is: classifying based on hash(and for that
>matter any other metadata like mark) is needed as a general
>utility for the system and should not be only available for
>flower. The one big reason we allow all kinds of classifiers
>in tc is in the name of "do one thing and do it well".

Sure. That classifier can exist, no problem. At the same time, flower
can match on it as well. There are already multiple examples of
classifiers matching on the same thing. I don't see any problem there.


>It is impossible for any one classifier to classify everything
>and do a good job at it. For example, I hope you are NEVER
>going to add string classification in flower.
>
>Note, what i am describing has precendence:
>I can do the same thing with skbmark offloading today.
>On ingress I use fw classifier (not u32 or flower).
>
>> 
>> > 
>> > I think there is a line for adding everything in one place,
>> > my main concern is that this feature this is needed
>> > by all classifiers and not just flower.
>> 
>> "All" is effectively only flower. Let's be clear about that.
>> 
>
>Unless I am misunderstanding, why is it just about flower?
>u32 does offload to some hardware. RSS can set this value
>and various existing things like XDP, tc ebpf and the action
>posted by Ariel.
>
>cheers,
>jamal
