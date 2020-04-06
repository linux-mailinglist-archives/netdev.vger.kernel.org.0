Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3075819FE77
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDFTwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:52:12 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:40438 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgDFTwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:52:12 -0400
Received: by mail-wm1-f53.google.com with SMTP id a81so760793wmf.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PnqJbd4hXHJb7kb9AgY9GXBVojb5hbQObeddO7NqVYg=;
        b=QJOkpv2kDVROJGTAwpEu2rSCt964Kko5ZB9q0/6onSXInbA+srOspIW3bXTF9OmBAW
         kfZWzX1ttOGo0g5ASmra2XOCE2yY3hJxQhDW+eNJaBrJx09q3M9EdzE9QqxKfpU9rU+2
         s5Yh1qxc9J+5BzsAWCp2pSJzZk16V1Vr8q/MznOVU+7WwkFs/vqf6xTroATwe+bOPZJt
         c2R07LKTEjSp2TKob9KI2/8zPhBtM6R7CFA8Lrkk6bU73WdhsFbX0H2GqbpXmFjPkGIT
         5b5eM8h2uEZxCd+vMw6YunHMYoKp3C4wknrKmRy3llu8cieFstrFXFMKV9/RrIWnevQM
         Ph8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PnqJbd4hXHJb7kb9AgY9GXBVojb5hbQObeddO7NqVYg=;
        b=UbhQ0qfuMXm3R0q2syWw0aisedthD4nhqzF7vO6A6MwA+das5KMQPt18i6XhblkR2f
         RhXvy1bIOrvkm5FVpfXpMgGfhkku0ug36pwGLyWP9IloJ5e4CTcrj5c/vuBZqaUxBdiX
         8amDRm2A85cb/qIglS+eccdPhlGTUXFeefSm9CeyLURq+74S60vwoFAv0bdKo6pxtZBi
         vCYrWCN8bVZgmGGN0BGPbsh140dfoVFL7mVtjqR3seq0zb93UVOzP06tGl1Zd04ehY9F
         tM4uNd20mp8/5ZEHG1o7xgZEyLsNxQCfa2b1vrUBOBb0kMwvFBwXVaduteb7zwl3DeKh
         LKsA==
X-Gm-Message-State: AGi0PubQ6OFPaca42BlEXqrYiY42o2Us2+UAb7ry2e7qT9gDJgYikt5P
        0azR0iQ13eEjSkZJE8hdQd0SLfKa
X-Google-Smtp-Source: APiQypJrWRknPud0orWZHnnO/rLklXxwiyqQQnNiQx0J7Pguy0s9Zp0i07NjrAAQ50rQAH1R03+GzQ==
X-Received: by 2002:a7b:c012:: with SMTP id c18mr715168wmb.22.1586202726929;
        Mon, 06 Apr 2020 12:52:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m21sm765809wmc.6.2020.04.06.12.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 12:52:06 -0700 (PDT)
Subject: Re: Changing devlink port flavor dynamically for DSA
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
 <20200406180410.GB2354@nanopsycho.orion>
 <2efae9ae-8957-7d52-617a-848b62f5aca3@gmail.com>
 <20200406182002.GD2354@nanopsycho.orion>
 <176481d3-eeee-feae-095a-6a3023d986f5@gmail.com>
 <20200406190050.GE2354@nanopsycho.orion>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <7e671174-a466-b8c8-64e6-d6ded3be37db@gmail.com>
Date:   Mon, 6 Apr 2020 12:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200406190050.GE2354@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2020 12:00 PM, Jiri Pirko wrote:
> Mon, Apr 06, 2020 at 08:41:25PM CEST, f.fainelli@gmail.com wrote:
>>
>>
>> On 4/6/2020 11:20 AM, Jiri Pirko wrote:
>>> Mon, Apr 06, 2020 at 08:11:18PM CEST, f.fainelli@gmail.com wrote:
>>>>
>>>>
>>>> On 4/6/2020 11:04 AM, Jiri Pirko wrote:
>>>>> Sun, Apr 05, 2020 at 10:42:29PM CEST, f.fainelli@gmail.com wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
>>>>>> connect to separate Ethernet MACs that the host/CPU can control. In
>>>>>> premise they are both interchangeable because the switch supports
>>>>>> configuring the management port to be either 5 or 8 and the Ethernet
>>>>>> MACs are two identical instances.
>>>>>>
>>>>>> The Ethernet MACs are scheduled differently across the memory controller
>>>>>> (they have different bandwidth and priority allocations) so it is
>>>>>> desirable to select an Ethernet MAC capable of sustaining bandwidth and
>>>>>> latency for host networking. Our current (in the downstream kernel) use
>>>>>> case is to expose port 5 solely as a control end-point to the user and
>>>>>> leave it to the user how they wish to use the Ethernet MAC behind port
>>>>>> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
>>>>>> disabled. Port 5 of that switch does not make use of Broadcom tags in
>>>>>> that case, since ARL-based forwarding works just fine.
>>>>>>
>>>>>> The current Device Tree representation that we have for that system
>>>>>> makes it possible for either port to be elected as the CPU port from a
>>>>>> DSA perspective as they both have an "ethernet" phandle property that
>>>>>> points to the appropriate Ethernet MAC node, because of that the DSA
>>>>>> framework treats them as CPU ports.
>>>>>>
>>>>>> My current line of thinking is to permit a port to be configured as
>>>>>> either "cpu" or "user" flavor and do that through devlink. This can
>>>>>> create some challenges but hopefully this also paves the way for finally
>>>>>> supporting "multi-CPU port" configurations. I am thinking something like
>>>>>> this would be how I would like it to be configured:
>>>>>>
>>>>>> # First configure port 8 as the new CPU port
>>>>>> devlink port set pci/0000:01:00.0/8 type cpu
>>>>>> # Now unmap port 5 from being a CPU port
>>>>>> devlink port set pci/0000:01:00.0/1 type eth
>>>>>
>>>>> You are mixing "type" and "flavour".
>>>>>
>>>>> Flavours: cpu/physical. I guess that is what you wanted to set, correct?
>>>>
>>>> Correct, flavor is really what we want to change here.
>>>>
>>>>>
>>>>> I'm not sure, it would make sense. The CPU port is still CPU port, it is
>>>>> just not used. You can never make is really "physical", am I correct? 
>>>>
>>>> True, although with DSA as you may know if we have a DSA_PORT_TYPE_CPU
>>>> (or DSA_PORT_TYPE_DSA), then we do not create a corresponding net_device
>>>> instance because that would duplicate the Ethernet MAC net_device. This
>>>> is largely the reason for suggesting doing this via devlink (so that we
>>>> do not rely on a net_device handle). So by changing from a
>>>> DSA_PORT_TYPE_CPU flavor to DSA_PORT_TYPE_USER, this means you would now
>>>> see a corresponding net_device instance. Conversely when you migrate
>>> >from DSA_PORT_TYPE_USER to DSA_PORT_TYPE_CPU, the corresponding
>>>> net_device would be removed.
>>>
>>> Wait, why would you ever want to have a netdevice for CPU port (changed
>>> to "user")? What am I missing? Is there a usecase, some multi-person
>>> port?
>>>
>>
>> I believe I explained the use case in my first email. The way the Device
>> Tree description is currently laid out makes it that Port 5 gets picked
>> up as the CPU port for the system. This is because the DSA layer stops
>> whenever it encounters the first "CPU" port, which it determines by
>> having an "ethernet" phandle (reference) to an Ethernet MAC controller node.
>>
>> The Ethernet MAC controller behind Port 5 does not have the necessary
>> bandwidth allocation at the memory controller level to sustain Gigabit
>> traffic with 64B packets. Instead we want to use Port 8 and the Ethernet
>> MAC connected to it which has been budgeted to support that bandwidth.
>>
>> The reason why we want to have a representor (DSA_PORT_TYPE_USER) for
>> port 5 of the switch is also because we need to set-up Compact Field
>> Processor (CFP) rules which need to identify specific packets ingressing
>> a specific port number and to be redirected towards another port (7) for
>> audio/video streaming processing. The interface to configure CFP is
>> currently ethool::rxnfc and that requires a net_device handle,
>> cls_flower would be the same AFAICT.
> 
> But if you don't use port 5 as CPU port, you don't use if for anything.
> Okay, you say that you need it for ethtool setup. But can't you use
> other netdevs of another port (physical port) for that?

Not really, the net_device gives you the physical port number, and there
is no way for the user to specify something different. It would also be
utterly confusing that you used whatever net_device exists to configure
an ingress matching rule to another physical port...

> 
> My point is, port 5 would not ever become physical port, equivalent to
> port 1 for example. Will still be CPU port. Only used/unused.

This is a valid point and question. If we are to support dynamically
changing DSA port flavor, there would be an expectation that when the
CPU port becomes DSA_PORT_TYPE_USER, we would be creating a net_device
representor for it at that time (since that is what would happen if we
did let DSA create devices in the first place). Conversely, if being an
USER port and being changed to a CPU port we would remove the net_device.
-- 
Florian
