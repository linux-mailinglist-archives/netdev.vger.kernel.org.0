Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9848595B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbiAETmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiAETmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:42:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C094AC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 11:42:42 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 8so105097pgc.10
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I1W7R+RRVlh76BIEdEOyZj9eEipZHo+bzLZMWYV2VFg=;
        b=cIMA0Tc5svSsyAqUYYhh0e2TELgZ6iBYjbDBEVfHR/asxkx6jqE647R0Vb1Nbho2H1
         cpqIWoDp1xnh49e7Jhw0oxVwZW2qGzAQkXVllAr7l5A163l+LXxjIk3EmS/9tHIla35c
         Hwzzxhp4DEqvnN248KH9GpAX4Yvu813b94NDhhviwtkP/zTuJn7da9JoDY+l2AXjkLxs
         uC1GpmyHAkmkIP+BQelfMSuks9tv/TtH1oIwH3ERvxRCiqvA1NhgrXUkEzS0L6g7QoNn
         ZWj4OrQyJd/vgnRKPXVhv3tO++oF3s5Kot6h5N0fjEGgItVXgvOCJohulw0tbHT6iUNh
         68Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I1W7R+RRVlh76BIEdEOyZj9eEipZHo+bzLZMWYV2VFg=;
        b=2eCkgp8iis9k+0HswKNM3pFnyAgYNjU7s5Izh5Uw3J1Ojxevuf/VLa9XKrGGLo4vzp
         WNX8XxKjD2wsQcRveW9Dt9bJ0btDHaR+Di2xuHyEPON0+hsoFl+d5WtQcoUgQDkY/3st
         ssg5UKIRr4UEWl4pjzknSzAy1s3Nb+9aEqnfxVtbfo5jVvjP1WmF0LhtCmNr8Tj+t4YA
         LZKF7Q1ojdEK3vdK5uIBFlaWJ1kLn+9XZ1ym89i49wme31qY1sWqyFKEXw7yuVIMmRr8
         Q53F4sSfLEha23qgz8ZTdN8QMfefFp4W07DPg5IWxmBQXNeG7p3DmS8sKLaxyUydRBb4
         i0uQ==
X-Gm-Message-State: AOAM531qDoaABHe9NFsMweCc9sHUDVjKIC9mzLuK/tQxbG2Em7UfelTd
        XY2YzzCJoJB8UM5djRWBe04=
X-Google-Smtp-Source: ABdhPJxJ4HiT1Fm4Q8fY5kfah0qLD5CnVude9yZ+cgfc5Fx3aKbZVcX2rxsdTJ3KpmUTujyvP0125w==
X-Received: by 2002:a63:af08:: with SMTP id w8mr22022556pge.70.1641411762131;
        Wed, 05 Jan 2022 11:42:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y29sm32664399pfa.54.2022.01.05.11.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:42:41 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
 <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
 <20220105183934.yxidfrcwcuirm7au@skbuf>
 <07c9858a-aae1-725e-67e7-fc64f8341f3e@gmail.com>
 <20220105185627.vq6kgnw2yhbymiuc@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <72cace33-d973-461b-7f51-41174b3954df@gmail.com>
Date:   Wed, 5 Jan 2022 11:42:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105185627.vq6kgnw2yhbymiuc@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 10:56 AM, Vladimir Oltean wrote:
> On Wed, Jan 05, 2022 at 10:46:44AM -0800, Florian Fainelli wrote:
>> On 1/5/22 10:39 AM, Vladimir Oltean wrote:
>>> Hi Florian,
>>>
>>> On Wed, Jan 05, 2022 at 10:30:54AM -0800, Florian Fainelli wrote:
>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>
>>> Thanks a lot for the review.
>>>
>>> I'm a bit on the fence on this patch and the other one for dsa_switch.
>>> The thing is that bit fields are not atomic in C89, so if we update any
>>> of the flags inside dp or ds concurrently (like dp->vlan_filtering),
>>> we're in trouble. Right now this isn't a problem, because most of the
>>> flags are set either during probe, or during ds->ops->setup, or are
>>> serialized by the rtnl_mutex in ways that are there to stay (switchdev
>>> notifiers). That's why I didn't say anything about it. But it may be a
>>> caveat to watch out for in the future. Do you think we need to do
>>> something about it? A lock would not be necessary, strictly speaking.
>>
>> I would probably start with a comment that describes these pitfalls, I
>> wish we had a programmatic way to ensure that these flags would not be
>> set dynamically and outside of the probe/setup path but that won't
>> happen easily.
> 
> A comment is probably good.
> 
>> Should we be switching to a bitmask and bitmap helpers to be future proof?
> 
> We could have done that, and it would certainly raise the awareness a
> bit more, but the reason I went with the bit fields at least in the
> first place was to reduce the churn in drivers. Otherwise, sure, if
> driver changes are on the table for this, we can even discuss about
> adding more arguments to dsa_register_switch(). The amount of poking
> that drivers do inside struct dsa_switch has grown, and sometimes it's
> not even immediately clear which members of that structure are supposed
> to be populated by whom and when. We could definitely just tell them to
> provide their desired behavior as arguments (vlan_filtering_is_global,
> needs_standalone_vlan_filtering, configure_vlan_while_not_filtering,
> untag_bridge_pvid, assisted_learning_on_cpu_port, ageing_time_min,
> ageing_time_max, phys_mii_mask, num_tx_queues, num_lag_ids, max_num_bridges)
> and only DSA will update struct dsa_switch, and we could then control
> races better that way. But the downside is that we'd have 11 extra
> arguments to dsa_register_switch()....

I would not mind if we introduced a dsa_switch::features or similar
bitmap and require driver to set bits in there before
dsa_register_switch() but that seems outside the scope of your patch
set, and I am not sure what the benefits would be unless we do happen to
do dynamic bit/feature toggling.

So for now, I believe a comment is enough, and if we spot a driver
changing that paradigm we consider a more "dynamic" solution.
-- 
Florian
