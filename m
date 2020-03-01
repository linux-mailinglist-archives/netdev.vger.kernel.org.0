Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4BC174C57
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgCAI6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:58:01 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45931 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCAI6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:58:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id v2so8539399wrp.12
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=McNKsnaf8ZVEiHC3AS1hZ/xSNNvEaItYM1h8PjboBkk=;
        b=yFkbYHMesXfGTOLs0ERtj9TdGOYlV9hy9A03ToV6Yt7AvJs8pUtxJTuGLbUhgWgD3m
         HqRViYaJG3WEpkps1qSV2rMHlePZjLfFjaW3/wjTIKASNQQG8FkNyqiqwgHwbGute8RB
         KPrxRYnmdkJBJAV7I0WOTYQvSF42j4XEqgSJegGs+VvzsR6IlQMdG0vCrgx7shnJzm5f
         x6YWh9cJdmr8nLKyBPb6n5DxldBfoheWfsDZ8CVGRslK/vy8CbzFt5+tXCcZkKpbpRlU
         O8dr3+hTGjESidrjFPOWLylmoo9GkZUutam1eKuvNW5IuRCkmJFXlNeOE0+muDbFua1A
         ExKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=McNKsnaf8ZVEiHC3AS1hZ/xSNNvEaItYM1h8PjboBkk=;
        b=PGXCrkbtAncvPYyWc+7LligZagcasBWkOAKihU6CWtUn7TFKJEo388WS21JdtwFPtr
         duq13r2KStCgqz7oHFY1bPCjsIQ3lRmt3KO2Zw6e9TQvCkJzRlYJRN5JH7wOvPtHqLhj
         BebJ2/WNMFCQ8qgXNavkcJ1aSPJy5prj9L5NXOscu1h/9f3GEkvqmzUBQYBWIvNngJ51
         VWXfhQ8pchwm2sRKvqzZEClPS570hJ1V4ei6YGRYqoKOvB7xwdDHHwaGT8dZFWK3+CKj
         I/oNa2PtupQPOlLp4LoRs5FV+HKgodDWnc1N3TSATxcZG/zoh/0Bcmh202fPyw8fOSBV
         Xh0A==
X-Gm-Message-State: APjAAAVQ853Qt4QLJzwPMvUPvJIRqXEQrJ3/SJt5e8eHOWK+NHvtJ5Kl
        T+XHSoAUSN1GASLQFseN9cQqNA==
X-Google-Smtp-Source: APXvYqxwl++iN80RohQ9AcHKV8IyAuWGd5WNUNH48CQ1rzTxgMbBMZhMccCKRA9TZE4Xxe1W5ytI2g==
X-Received: by 2002:adf:eac1:: with SMTP id o1mr14862918wrn.234.1583053078110;
        Sun, 01 Mar 2020 00:57:58 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id x8sm8933908wro.55.2020.03.01.00.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 00:57:57 -0800 (PST)
Date:   Sun, 1 Mar 2020 09:57:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify type
 of HW stats for a filter
Message-ID: <20200301085756.GS26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-13-jiri@resnulli.us>
 <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200229075209.GM26061@nanopsycho>
 <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 29, 2020 at 09:14:52PM CET, kuba@kernel.org wrote:
>On Sat, 29 Feb 2020 08:52:09 +0100 Jiri Pirko wrote:
>> Fri, Feb 28, 2020 at 08:59:23PM CET, kuba@kernel.org wrote:
>> >On Fri, 28 Feb 2020 18:25:05 +0100 Jiri Pirko wrote:  
>> >> From: Jiri Pirko <jiri@mellanox.com>
>> >> +/* tca HW stats type */
>> >> +enum tca_act_hw_stats_type {
>> >> +	TCA_ACT_HW_STATS_TYPE_ANY, /* User does not care, it's default
>> >> +				    * when user does not pass the attr.
>> >> +				    * Instructs the driver that user does not
>> >> +				    * care if the HW stats are "immediate"
>> >> +				    * or "delayed".
>> >> +				    */
>> >> +	TCA_ACT_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
>> >> +					  * the current HW stats state from
>> >> +					  * the device queried at the dump time.
>> >> +					  */
>> >> +	TCA_ACT_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
>> >> +					* HW stats that might be out of date
>> >> +					* for some time, maybe couple of
>> >> +					* seconds. This is the case when driver
>> >> +					* polls stats updates periodically
>> >> +					* or when it gets async stats update
>> >> +					* from the device.
>> >> +					*/
>> >> +	TCA_ACT_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
>> >> +					 * any HW statistics.
>> >> +					 */
>> >> +};  
>> >
>> >On the ABI I wonder if we can redefine it a little bit..
>> >
>> >Can we make the stat types into a bitfield?
>> >
>> >On request:
>> > - no attr -> any stats allowed but some stats must be provided *
>> > - 0       -> no stats requested / disabled
>> > - 0x1     -> must be stat type0
>> > - 0x6     -> stat type1 or stat type2 are both fine  
>> 
>> I was thinking about this of course. On the write side, this is ok
>> however, this is very tricky on read side. See below.
>> 
>> >* no attr kinda doesn't work 'cause u32 offload has no stats and this
>> >  is action-level now, not flower-level :S What about u32 and matchall?  
>> 
>> The fact that cls does not implement stats offloading is a lack of
>> feature of the particular cls.
>
>Yeah, I wonder how that squares with strict netlink parsing.
>
>> >We can add a separate attribute with "active" stat types:
>> > - no attr -> old kernel
>> > - 0       -> no stats are provided / stats disabled
>> > - 0x1     -> only stat type0 is used by drivers
>> > - 0x6     -> at least one driver is using type1 and one type2  
>> 
>> There are 2 problems:
>> 1) There is a mismatch between write and read. User might pass different
>> value than it eventually gets from kernel. I guess this might be fine.
>
>Separate attribute would work.
>
>> 2) Much bigger problem is, that since the same action may be offloaded
>> by multiple drivers, the read would have to provide an array of
>> bitfields, each array item would represent one offloaded driver. That is
>> why I decided for simple value instead of bitfield which is the same on
>> write and read.
>
>Why an array? The counter itself is added up from all the drivers.
>If the value is a bitfield all drivers can just OR-in their type.

Yeah, for uapi. Internally the array would be still needed. Also the
driver would need to somehow "write-back" the value to the offload
caller and someone (caller/tc) would have to use the array to track
these bitfields for individual callbacks (probably idr of some sort).
I don't know, is this excercise worth it?

Seems to me like we are overengineering this one a bit.

Also there would be no "any" it would be type0|type1|type2 the user
would have to pass. If new type appears, the userspace would have to be
updated to do "any" again :/ This is inconvenient.


>
>> >That assumes that we may one day add another stat type which would 
>> >not be just based on the reporting time.
>> >
>> >If we only foresee time-based reporting would it make sense to turn 
>> >the attribute into max acceptable delay in ms?
>> >
>> >0        -> only immediate / blocking stats
>> >(0, MAX) -> given reporting delay in ms is acceptable
>> >MAX      -> don't care about stats at all  
>> 
>> Interesting, is this "delayed" granularity something that has a usecase?
>> It might turn into a guessing game between user and driver during action
>> insertion :/
>
>Yeah, I don't like the guessing part too, worst case refresh time may 
>be system dependent.
>
>With just "DELAYED" I'm worried users will think the delay may be too
>long for OvS. Or simply poll the statistics more often than the HW
>reports them, which would be pointless.
>
>For the latter case I guess the best case refresh time is needed, 
>while the former needs worst case. Hopefully the two are not too far
>apart.
>
>Maybe some day drivers may also tweak the refresh rate based on user
>requests to save PCIe bandwidth and CPU..
>
>Anyway.. maybe its not worth it today.
>
>> >> +tcf_flow_action_hw_stats_type(enum tca_act_hw_stats_type hw_stats_type)
>> >> +{
>> >> +	switch (hw_stats_type) {
>> >> +	default:
>> >> +		WARN_ON(1);
>> >> +		/* fall-through */  
>> >
>> >without the policy change this seems user-triggerable  
>> 
>> Nope. tcf_action_hw_stats_type_get() takes care of setting 
>> TCA_ACT_HW_STATS_TYPE_ANY when no attr is passed.
>
>I meant attribute is present but carries a large value.

Ah, will sanitize this.


>
>> >> +	case TCA_ACT_HW_STATS_TYPE_ANY:
>> >> +		return FLOW_ACTION_HW_STATS_TYPE_ANY;
>> >> +	case TCA_ACT_HW_STATS_TYPE_IMMEDIATE:
>> >> +		return FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE;
>> >> +	case TCA_ACT_HW_STATS_TYPE_DELAYED:
>> >> +		return FLOW_ACTION_HW_STATS_TYPE_DELAYED;
>> >> +	case TCA_ACT_HW_STATS_TYPE_DISABLED:
>> >> +		return FLOW_ACTION_HW_STATS_TYPE_DISABLED;
>
