Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39D5B2024
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiIHOIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiIHOIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:08:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C3F11364E
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFC9B820F4
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 14:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E288C433D6;
        Thu,  8 Sep 2022 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662646104;
        bh=u7rP930MaNmHuXiSH4Kd1D5iH709eRGDRqYVctwEO3Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FJ42sBvLs31CFK422LZdrwRHz4bf5zV88wat8yonX++vaMkpJJ/SdooRq88hfzMl+
         aUo5bQ6b/8LaLjHYVrS5UhKdKAGJqRoX2f/Uehkmc71DE298ODi4o04j7g33JYfmK/
         84lIlmGxaOKvtmavu93cUM1sggP+T7ggGTW0OnRGiGCrcBWlig4sf8tR0ghYAq0K5x
         VGk7EDboAlbStua4dP1Q+o3Ba0NSTIJd1KdBH+VZXxFPdf3yxTBj4jhq4h71eHS/UV
         UMgKyz6YyEL1Xxq7N8WHCmF6ph3XjldKGzwnS8HChS36o+i63ujK04xbT+iiVt7aov
         pMziSnw7nN2Tg==
Message-ID: <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
Date:   Thu, 8 Sep 2022 08:08:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220908125117.5hupge4r7nscxggs@skbuf>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220908125117.5hupge4r7nscxggs@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/22 6:51 AM, Vladimir Oltean wrote:
> On Tue, Sep 06, 2022 at 01:33:09PM -0700, Florian Fainelli wrote:
>> On 9/6/2022 1:05 PM, Andrew Lunn wrote:
>>>> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]
>>>
>>> Unfortunately, it is not gender neutral, which i assume is a
>>> requirement?
>>>
>>> Plus the plural is also schnauzer, which would make your current
>>> multiple CPU/schnauzer patches confusing, unless you throw the rule
>>> book out and use English pluralisation.
>>
>> What a nice digression, I had no idea you two mastered German that well :).
>> How about "conduit" or "mgmt_port" or some variant in the same lexicon?
> 
> Proposing any alternative naming raises the question how far you want to
> go with the alternative name. No user of DSA knows the "conduit interface"
> or "management port" or whatnot by any other name except "DSA master".
> What do we do about the user-visible Documentation/networking/dsa/configuration.rst,
> which clearly and consistently uses the 'master' name everywhere?
> Do we replace 'master' with something else and act as if it was never
> named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
> UAPI and explain in the documentation "oh yeah, that's how you change
> the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
> then?" "Well...."
> 
> Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
> also change that to reflect the new terminology, or do we just have
> documentation stating one thing and the code another?
> 
> At this stage, I'm much more likely to circumvent all of this, and avoid
> triggering anyone by making a writable IFLA_LINK be the mechanism through
> which we change the DSA master.

IMHO, 'master' should be an allowed option giving the precedence of
existing code and existing terminology. An alternative keyword can be
used for those that want to avoid use of 'master' in scripts. vrf is an
example of this -- you can specify 'vrf <device>' as a keyword instead
of 'master <vrf>'
