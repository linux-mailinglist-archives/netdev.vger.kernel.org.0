Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55DC69BEEE
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 08:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBSHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 02:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBSHf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 02:35:29 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9B610431
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 23:35:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1676792104; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=W9O9SXXSS27qNPQMZvJcnjoJmnx7uhUi0G61eXD8VtnBqwPuYPw/FDWZzh4V1sF1PjLqW9BQUMFDy6R7NMdjtSK8HpxDfo/M54ObhlltWiV6F3uff+VI8ggmhcb4Q86zs6C+YR5de0No8jb9IUhRwLqg/bexypYscWvls1zPF98=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1676792104; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ZMy79y31ToV2ZQhtRmTXcQ7sEnZUwifZ+vwNGVBS/Gc=; 
        b=HZcNP7bldkwB4Sa9L9YnYkwwS1+G8dTtwgIuMOkH3E9lt5sBqN+qnRhvsW0zxZXxe/6bAFP18NJL2R1B47IXbuRvkD+h6+TWhMmAQVbAzad20+uAKsrXtDvkCdTHNiKfxPu0qh9IlsyjUnjxss/KysfBE6mKxKnHPI/xctVKJN8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1676792104;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=ZMy79y31ToV2ZQhtRmTXcQ7sEnZUwifZ+vwNGVBS/Gc=;
        b=Tdk9vQFXAA6fMV1KixqktBSi72Ip2BidEcklDk5vYpBoILgIuzw97jvuLwkgLNH7
        GEn02z+8FbELAnxVBF2rNmuiQqd8CBZPzrCiffrkVyNBRexbMDzKcxMZXTUX1RjYD1O
        GliI9bPap6BhgMFH9dpJKy1YhBf5wAyeN1u8PBsc=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1676792103390332.79315168104097; Sat, 18 Feb 2023 23:35:03 -0800 (PST)
Message-ID: <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
Date:   Sun, 19 Feb 2023 10:35:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Choose a default DSA CPU port
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230218205204.ie6lxey65pv3mgyh@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2023 23:52, Vladimir Oltean wrote:
> Hi Arınç,
> 
> On Sat, Feb 18, 2023 at 08:07:53PM +0300, Arınç ÜNAL wrote:
>> Hey there folks,
>>
>> The problem is this. Frank and I have got a Bananapi BPI-R2 with MT7623 SoC.
>> The port5 of MT7530 switch is wired to gmac1 of the SoC. Port6 is wired to
>> gmac0. Since DSA sets the first CPU port it finds on the devicetree, port5
>> becomes the CPU port for all DSA slaves.
>>
>> But we'd prefer port6 since it uses trgmii while port5 uses rgmii. There are
>> also some performance issues with the port5 - gmac1 link.
>>
>> Now we could change it manually on userspace if the DSA subdriver supported
>> changing the DSA master.
>>
>> I'd like to find a solution which would work for the cases of; the driver
>> not supporting changing the DSA master, or saving the effort of manually
>> changing it on userspace.
>>
>> The solution that came to my mind:
>>
>> Introduce a DT property to designate a CPU port as the default CPU port.
>> If this property exists on a CPU port, that port becomes the CPU port for
>> all DSA slaves.
>> If it doesn't exist, fallback to the first-found-cpu-port method.
>>
>> Frank doesn't like this idea:
>>
>>> maybe define the default cpu in driver which gets picked up by core
>> (define port6 as default if available).
>>> Imho additional dts-propperty is wrong approch...it should be handled by
>> driver. But cpu-port-selection is currently done in dsa-core which makes it
>> a bit difficult.
>>
>> What are your thoughts?
>>
>> Arınç
> 
> Before making any change, I believe that the first step is to be in agreement
> as to what the problem is.
> 
> The current DSA device tree binding has always chosen the numerically first
> CPU port as the default CPU port. This was also the case at the time when the
> mt7530 driver was accepted upstream. Clearly there are cases where this choice
> is not the optimal choice (from the perspective of an outside observer).
> For example when another CPU port has a higher link speed. But it's not
> exactly obvious that higher link speed is always better. If you have a CPU
> port at a higher link speed than the user ports, but it doesn't have flow
> control, then the choice is practically worse than the CPU port which operates
> at the same link speed as user ports.
> 
> So the choice between RGMII and TRGMII is not immediately obvious to some code
> which should take this decision automatically. And this complicates things
> a lot. If there is no downside to having the kernel take a decision automatically,
> generally I don't have a problem taking it. But here, I would like to hear
> some strong arguments why port 6 is preferable over port 5.

I'm leaving this to Frank to explain.

> 
> If there are strong reasons to consider port 6 a primary CPU port and
> port 5 a secondary one, then there is also a very valid concern of forward
> compatibility between the mt7530 driver and device trees from the future
> (with multiple CPU ports defined). The authors of the mt7530 driver must have
> been aware of the DSA binding implementation's choice of selecting the
> first CPU port as the default, but they decided to hide their head in
> the sand and pretend like this issue will never crop up. The driver has
> not been coded up to accept port 5 as a valid CPU port until very recently.
> What should have been done (*assuming strong arguments*) is that
> dsa_tree_setup_default_cpu() should have been modified from day one of
> mt7530 driver introduction, such that the driver has a way of specifying
> a preferred default CPU port.
> 
> In other words, the fact that the CPU port becomes port 5 when booting
> on a new device tree is equally a problem for current kernels as it is
> for past LTS kernels. I would like this to be treated seriously, and
> current + stable kernels should behave in a reasonable manner with
> device trees from the future, before support for multiple CPU ports is
> added to mt7530. Forcing users to change device trees in lockstep with
> the kernel is not something that I want to maintain and support, if user
> questions and issues do crop up.
> 
> Since this wasn't done, the only thing we're left with is to retroactively
> add this functionality to pick a preferred default CPU port, as patches
> to "net" which get backported to stable kernels. Given enough forethought
> in the mt7530 driver development, this should not have been necessary,
> but here we are.
> 
> Now that I expressed this point of view, let me comment on why your
> proposal, Arınç, solves exactly nothing.
> 
> If you add a device tree property for the preferred CPU port, you
> haven't solved any of the compatibility problems:
> 
> - old kernels + new device trees will not have the logic to interpret
>    that device tree property
> - old device trees + new kernels will not have that device tree property
> 
> so... yeah.

Makes perfect sense. I always make the assumption that once the DTs on 
the kernel source code is updated, it will be used everywhere, which is 
just not the case.

Arınç
