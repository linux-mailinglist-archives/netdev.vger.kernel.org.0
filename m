Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8031D19FDCC
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgDFTAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:00:54 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38712 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgDFTAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:00:54 -0400
Received: by mail-wr1-f52.google.com with SMTP id 31so795821wre.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AAwYP8qPxxHpMIXG1y9N9/bqBTipKdfeHTR5j2FnmxU=;
        b=LQ8rASWLWA3kuE4CYGcoSP34o9F9MGLjoiM/cDUt9goXkAkLGZQQdC6wa6LTOWqnXv
         O0D2CpJMaxySy3ut22AVQL6rOzbVUObH7BRTHIPWQM3gYyFCh4m9HpsUUsGZUJpHppK7
         AHU7Oe/OU8atsYe/aRinY5vbxLE6vBlKwMMaYLPv80q1uY8l+N5wyXU4pcVMgs6Pvw7A
         cFKFLtSmbpIMNztkPgoye10VPqvs5FVHcPn+sbkde9aOb5YWLnqAonrXGTtdD9XUNzZb
         2x+6MeTJZtZLjDZ59fiMWV1/anp53DD5rQC8YymFZK7bJfT74abM96kRViOzSL40Q8Ym
         sB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AAwYP8qPxxHpMIXG1y9N9/bqBTipKdfeHTR5j2FnmxU=;
        b=YuOU7LJz0y/y0M0GnMjtjSG+PHGxlFoyAV11eMam7gGIpHYgZldHhMz1sGThVjuYkU
         W52C0CnLNwmKsX309DMtbFNwMFuUelWlT6jFK3xUatzDMJhz5Ydz0lfBVP5X8+rotKf8
         IPFpe+DDddVJbwRD92GRzxpA5Yu8eglSY0YJj25+MnFmxuaAtOu2COqtpr8vA1GZ4bVh
         Uql+ikvai/+XXqd/LST5uyzCwiopUJKciXRQboWj5aWNzBxipTm67FlEV7Qy59OfQFSA
         QWDeH9oKCnBAP+6KJUh8/e5ko6GLw19flAVPkIK7Dv9Ah+agmOt5M90L95UW/riU7a5j
         BQ6A==
X-Gm-Message-State: AGi0PuYtzrp+WQerGuG7JxKDTWcgS9WzLJRBJewYRo1SWxTrGAO3Z6Pi
        Tf+xF3mc/XPg/o5DbDs3ezR54vkDjM8=
X-Google-Smtp-Source: APiQypKdV+0ptK4o7FQqtMnOjntEq/BLNMAqnzIWWISuVPcJPgM8zYiekKE+MFXoFxSPhXM8FX8+ew==
X-Received: by 2002:adf:e7c6:: with SMTP id e6mr670167wrn.159.1586199651797;
        Mon, 06 Apr 2020 12:00:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q187sm532830wma.41.2020.04.06.12.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:00:51 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:00:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Changing devlink port flavor dynamically for DSA
Message-ID: <20200406190050.GE2354@nanopsycho.orion>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
 <20200406180410.GB2354@nanopsycho.orion>
 <2efae9ae-8957-7d52-617a-848b62f5aca3@gmail.com>
 <20200406182002.GD2354@nanopsycho.orion>
 <176481d3-eeee-feae-095a-6a3023d986f5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176481d3-eeee-feae-095a-6a3023d986f5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 06, 2020 at 08:41:25PM CEST, f.fainelli@gmail.com wrote:
>
>
>On 4/6/2020 11:20 AM, Jiri Pirko wrote:
>> Mon, Apr 06, 2020 at 08:11:18PM CEST, f.fainelli@gmail.com wrote:
>>>
>>>
>>> On 4/6/2020 11:04 AM, Jiri Pirko wrote:
>>>> Sun, Apr 05, 2020 at 10:42:29PM CEST, f.fainelli@gmail.com wrote:
>>>>> Hi all,
>>>>>
>>>>> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
>>>>> connect to separate Ethernet MACs that the host/CPU can control. In
>>>>> premise they are both interchangeable because the switch supports
>>>>> configuring the management port to be either 5 or 8 and the Ethernet
>>>>> MACs are two identical instances.
>>>>>
>>>>> The Ethernet MACs are scheduled differently across the memory controller
>>>>> (they have different bandwidth and priority allocations) so it is
>>>>> desirable to select an Ethernet MAC capable of sustaining bandwidth and
>>>>> latency for host networking. Our current (in the downstream kernel) use
>>>>> case is to expose port 5 solely as a control end-point to the user and
>>>>> leave it to the user how they wish to use the Ethernet MAC behind port
>>>>> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
>>>>> disabled. Port 5 of that switch does not make use of Broadcom tags in
>>>>> that case, since ARL-based forwarding works just fine.
>>>>>
>>>>> The current Device Tree representation that we have for that system
>>>>> makes it possible for either port to be elected as the CPU port from a
>>>>> DSA perspective as they both have an "ethernet" phandle property that
>>>>> points to the appropriate Ethernet MAC node, because of that the DSA
>>>>> framework treats them as CPU ports.
>>>>>
>>>>> My current line of thinking is to permit a port to be configured as
>>>>> either "cpu" or "user" flavor and do that through devlink. This can
>>>>> create some challenges but hopefully this also paves the way for finally
>>>>> supporting "multi-CPU port" configurations. I am thinking something like
>>>>> this would be how I would like it to be configured:
>>>>>
>>>>> # First configure port 8 as the new CPU port
>>>>> devlink port set pci/0000:01:00.0/8 type cpu
>>>>> # Now unmap port 5 from being a CPU port
>>>>> devlink port set pci/0000:01:00.0/1 type eth
>>>>
>>>> You are mixing "type" and "flavour".
>>>>
>>>> Flavours: cpu/physical. I guess that is what you wanted to set, correct?
>>>
>>> Correct, flavor is really what we want to change here.
>>>
>>>>
>>>> I'm not sure, it would make sense. The CPU port is still CPU port, it is
>>>> just not used. You can never make is really "physical", am I correct? 
>>>
>>> True, although with DSA as you may know if we have a DSA_PORT_TYPE_CPU
>>> (or DSA_PORT_TYPE_DSA), then we do not create a corresponding net_device
>>> instance because that would duplicate the Ethernet MAC net_device. This
>>> is largely the reason for suggesting doing this via devlink (so that we
>>> do not rely on a net_device handle). So by changing from a
>>> DSA_PORT_TYPE_CPU flavor to DSA_PORT_TYPE_USER, this means you would now
>>> see a corresponding net_device instance. Conversely when you migrate
>>>from DSA_PORT_TYPE_USER to DSA_PORT_TYPE_CPU, the corresponding
>>> net_device would be removed.
>> 
>> Wait, why would you ever want to have a netdevice for CPU port (changed
>> to "user")? What am I missing? Is there a usecase, some multi-person
>> port?
>> 
>
>I believe I explained the use case in my first email. The way the Device
>Tree description is currently laid out makes it that Port 5 gets picked
>up as the CPU port for the system. This is because the DSA layer stops
>whenever it encounters the first "CPU" port, which it determines by
>having an "ethernet" phandle (reference) to an Ethernet MAC controller node.
>
>The Ethernet MAC controller behind Port 5 does not have the necessary
>bandwidth allocation at the memory controller level to sustain Gigabit
>traffic with 64B packets. Instead we want to use Port 8 and the Ethernet
>MAC connected to it which has been budgeted to support that bandwidth.
>
>The reason why we want to have a representor (DSA_PORT_TYPE_USER) for
>port 5 of the switch is also because we need to set-up Compact Field
>Processor (CFP) rules which need to identify specific packets ingressing
>a specific port number and to be redirected towards another port (7) for
>audio/video streaming processing. The interface to configure CFP is
>currently ethool::rxnfc and that requires a net_device handle,
>cls_flower would be the same AFAICT.

But if you don't use port 5 as CPU port, you don't use if for anything.
Okay, you say that you need it for ethtool setup. But can't you use
other netdevs of another port (physical port) for that?

My point is, port 5 would not ever become physical port, equivalent to
port 1 for example. Will still be CPU port. Only used/unused.
