Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C32F16AB49
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgBXQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:25:26 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39142 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgBXQZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:25:26 -0500
Received: by mail-wm1-f43.google.com with SMTP id c84so10107464wme.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 08:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tIAZFaTvIkd6nXh7LxgqD08IpO2vAcFJgZssf5DGn/Y=;
        b=oB6In5JtzdrOSoTk9D1vawrh8KwKlnCOHwr33t9dyRJ3GAVC5zQV2g8qrXGPgdNUtK
         /fIcJjJRfbWlsBI7ic4wZAaAvz1cgmdKDcKw/vQW+23gf1wcEmojxNfb49mJL+dOQxKX
         LrKAlFshq/Gv0H5z+tbWi9c7MRZN3bIl63MP89N/KS9CzwJEJ8rei6NL+4QninEH6efi
         0Yq7cdcXbtQH19HRchhDn7ojrSNlLniAbJk7yvZi+Kj0GPq+yW0F6m+G+vBcZGEdLREp
         erOiZ8H3Q81VOSea8gc5mU4yHU/ixN2KhaFh98XKyq4EvAwHHLUcptcKeU/WgFiMyLew
         AVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tIAZFaTvIkd6nXh7LxgqD08IpO2vAcFJgZssf5DGn/Y=;
        b=ejT1+FSFgzaVXhJMErZjFBFngHkBscTHOBFKBOLJtpXd6CbKFzoFwg0D9RpufIJHww
         cNX/QXqwpYQ+qmMLEGWVqLIBOndWVdhB6+GRDoppOV4whfw3aLdvNvhf2yjnoqpQRwG1
         5trQrh36uMT+FJF1Z+hLcJRA+0XU4oN5K+QBmo0Kfxg8nL3XWVLEc5PpptnRcau9p4Jw
         rxr8OelSRA3QOkHzPqC6p/uZ8KWRZ6iMzxFwijpYtKnfb0M3pywUBb29aktPr5DG7z2q
         bX6vdzVrJAYcluZ6gOEepGd0xbxeoUG5Ai7SiZkrnmGD3E7JOKKXCalxh3UcHRebwnhG
         4Bdg==
X-Gm-Message-State: APjAAAWl3fFUZdMnT8YTqe+wHatHdqj+cJ6J189R+alNZnAGewnmAxyZ
        B6K8aZzlDlN/ZS52+fAQlKVXpw==
X-Google-Smtp-Source: APXvYqydo5BzoQ15eoqIXkPuJjgWwIAwHmi8engPksMVizxnPGOJmp4dYtVxBYdUSBEGyD6nGUnTGA==
X-Received: by 2002:a7b:cab1:: with SMTP id r17mr22810609wml.116.1582561523113;
        Mon, 24 Feb 2020 08:25:23 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s8sm20394028wrt.57.2020.02.24.08.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:25:22 -0800 (PST)
Date:   Mon, 24 Feb 2020 17:25:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200224162521.GE16270@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 24, 2020 at 04:45:57PM CET, jhs@mojatatu.com wrote:
>On 2020-02-24 8:11 a.m., Jiri Pirko wrote:
>> Mon, Feb 24, 2020 at 12:38:20PM CET, ecree@solarflare.com wrote:
>> > On 22/02/2020 06:38, Jiri Pirko wrote:
>
>[..]
>> > Potentially a user could only want stats on one action and disable them
>> >   on another.  For instance, if their action chain does delivery to the
>> >   'customer' and also mirrors the packets for monitoring, they might only
>> >   want stats on the first delivery (e.g. for billing) and not want to
>> >   waste a counter on the mirror.
>> 
>> Okay.
>> 
>
>+1  very important for telco billing use cases i am familiar with.
>
>Ancient ACL implementations that had only one filter and
>one action (drop/accept) didnt need more than one counter.
>But not anymore in my opinion.
>
>There's also a requirement for the concept of "sharing" - think
>"family plans" or "small bussiness plan".
>Counters may be shared across multiple filter-action chains for example.

In hardware, we have a separate "counter" action with counter index.
You can reuse this index in multiple counter action instances.
However, in tc there is implicit separate counter for every action.

The counter is limited resource. So we overcome this mismatch in mlxsw
by having action "counter" always first for every rule inserted:
rule->action_counter,the_actual_action,the_actual_action2,...the_actual_actionN

and we report stats from action_counter for all the_actual_actionX.


>
>> 
>> > 
>> > > Plus, if the fine grained setup is ever needed, the hw_stats could be in
>> > > future easilyt extended to be specified per-action too overriding
>> > > the per-filter setup only for specific action. What do you think?
>> > I think this is improper; the stats type should be defined per-action in
>> >   the uapi, even if userland initially only has UI to set it across the
>> >   entire filter.  (I imagine `tc action` would grow the corresponding UI
>> >   pretty quickly.)  Then on the driver side, you must determine whether
>> >   your hardware can support the user's request, and if not, return an
>> >   appropriate error code.
>> > 
>> > Let's try not to encourage people (users, future HW & driver developers)
>> >   to keep thinking of stats as per-filter entities.
>> > Okay, but in that case, it does not make sense to have "UI to set it
>> across the entire filter". The UI would have to set it per-action too.
>> Othewise it would make people think it is per-filter entity.
>> But I guess the tc cmdline is chatty already an it can take other
>> repetitive cmdline options.
>> 
>
>I normally visualize policy as a dag composed of filter(s) +
>actions. The UI and uAPI has to be able to express that.
>
>I am not sure if mlxsw works this way, but:
>Most hardware i have encountered tends to have a separate
>stats/counter table. The stats table is indexed.
>
>Going backwards and looking at your example in this stanza:
>---
>  in_hw in_hw_count 2
>  hw_stats immediate
>        action order 1: gact action drop
>         random type none pass val 0
>         index 1 ref 1 bind 1 installed 14 sec used 7 sec
>        Action statistics:
>----
>
>Guessing from "in_hw in_hw_count 2" - 2 is a hw stats table index?
>If you have enough counters in hardware, the "stats table index"
>essentially can be directly mapped to the action "index" attribute.

>
>Sharing then becomes a matter of specifying the same drop action
>with the correct index across multiple filters.
>
>If you dont have enough hw counters - then perhaps a scheme to show
>separate hardware counter index and software counter index (aka action
>index) is needed.

I don't, that is the purpose of this patchset, to be able to avoid the
"action_counter" from the example I wrote above.

Note that I don't want to share, there is still separate "last_hit"
record in hw I expose in "used X sec". Interestingly enough, in
Spectrum-1 this is per rule, in Spectrum-2,3 this is per action block :)


>
>cheers,
>jamal
>
>> What do you think?
>> 
>> 
>> Thanks!
>> 
>
