Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6226774A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgILCyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 22:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgILCyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 22:54:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C9CC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:54:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o68so8766995pfg.2
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xIr708w0KD5zJj589d3pQ4oHOQv50ZTCXJl7YMqXzmE=;
        b=J/6i1HRX56eroEcWOC53CJDSoYxYKNFAyR/vTBUV5TPjhmdsqeaMgYe9FgDtBDxwXC
         5LkSOggV7x2r5R7j3DaTZ/k4aa8B5+cO/T/NnZKj18+kY3KFBNLjypgodHBwpMnxodrH
         TMJp+r6ID/Q6JybwBKHHl2QKhyU7TMQstuxZQaCPne6lXb7qOMC08pu3zBmw2LQpUsd9
         srBnj1WsVdAomIAAZxZLWDSDWLEQS/NtnHG6qrAIeRhSNMHqLfO2IdNXselVhznVGC/z
         YLql8StG9mhiBIlOBncPxXgotLqNBiGuRduIlyPAned92vDw7M7nh+VwMHor8YLslL55
         +cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xIr708w0KD5zJj589d3pQ4oHOQv50ZTCXJl7YMqXzmE=;
        b=OFcp9AsSEUI/vqvvZUb5/z444GkZPqNk8a3xLkGzCoUKTWGSXUbHSOtlYL7uald7pm
         NsNsHtSg7vZFXYTT69BiodZxLyc7MbXNYk683XuI5i9/5MmikVvcumtNsw4tofn8c5aG
         ABRfYEA5lbNpMxPeFo78MBuQjRCaSvGrDFbz7CUxaC8m7zX8KiL4uOz3x3J4+BQ4swFC
         PK6Lihl3dIBHTabhLiqTQX/IX37uZX0NYnP+4F5V0lH5LxA6bbokm8UpVbJ940H5dpjD
         Td8yVrVoQBHR2KMA06jz0VLwaJJfixaTmYThxzRR+ogaHvU7PVPRSJNqW2UXAs8s6nRs
         G4tw==
X-Gm-Message-State: AOAM533FsAmsxXs5s9xtXdRRV09gFpQ7eG+pq4aduehAhypgifE5Dg/Y
        Gor3R33TT3UyinoRnrX6Ysg=
X-Google-Smtp-Source: ABdhPJzBou5fQQRnVivuYR9xCyHm1R/7+0DJ5tuAn7F9wg32Su4fVN4aVebsRUu6NxwKW/Vs9W3Y9Q==
X-Received: by 2002:a63:841:: with SMTP id 62mr3268935pgi.35.1599879254357;
        Fri, 11 Sep 2020 19:54:14 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j19sm3501252pfi.51.2020.09.11.19.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 19:54:13 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912001542.fqn2hcp35xkwqoun@skbuf>
 <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
Date:   Fri, 11 Sep 2020 19:54:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 5:42 PM, Jakub Kicinski wrote:
> On Sat, 12 Sep 2020 03:15:42 +0300 Vladimir Oltean wrote:
>> On Fri, Sep 11, 2020 at 05:07:24PM -0700, Jakub Kicinski wrote:
>>> On Sat, 12 Sep 2020 02:49:32 +0300 Vladimir Oltean wrote:
>>>> On Fri, Sep 11, 2020 at 04:28:45PM -0700, Jakub Kicinski wrote:
>>>>> Hi!
>>>>>
>>>>> This is the first (small) series which exposes some stats via
>>>>> the corresponding ethtool interface. Here (thanks to the
>>>>> excitability of netlink) we expose pause frame stats via
>>>>> the same interfaces as ethtool -a / -A.
>>>>>
>>>>> In particular the following stats from the standard:
>>>>>   - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
>>>>>   - 30.3.4.3 aPAUSEMACCtrlFramesReceived
>>>>>
>>>>> 4 real drivers are converted, hopefully the semantics match
>>>>> the standard.
>>>>>
>>>>> v2:
>>>>>   - netdevsim: add missing static
>>>>>   - bnxt: fix sparse warning
>>>>>   - mlx5: address Saeed's comments
>>>>
>>>> DSA used to override the "ethtool -S" callback of the host port, and
>>>> append its own CPU port counters to that.
>>>>
>>>> So you could actually see pause frames transmitted by the host port and
>>>> received by the switch's CPU port:
>>>>
>>>> # ethtool -S eno2 | grep pause
>>>> MAC rx valid pause frames: 1339603152
>>>> MAC tx valid pause frames: 0
>>>> p04_rx_pause: 0
>>>> p04_tx_pause: 1339603152
>>>>
>>>> With this new command what's the plan?
>>>
>>> Sounds like something for DSA folks to decide :)
>>>
>>> What does ethtool -A $cpu_port control?
>>> The stats should match what the interface controls.
>>
>> Error: $cpu_port: undefined variable.
>> With DSA switches, the CPU port is a physical Ethernet port mostly like
>> any other, except that its orientation is inwards towards the system
>> rather than outwards. So there is no network interface registered for
>> it, since I/O from the network stack would have to literally loop back
>> into the system to fulfill the request of sending a packet to that
>> interface.
> 
> Sorry, perhaps I should have said $MAC, but that kind of in itself
> answers the question.
> 
>> The ethtool -S framework was nice because you could append to the
>> counters of the master interface while not losing them.
>> As for "ethtool -A", those parameters are fixed as part of the
>> fixed-link device tree node corresponding to the CPU port.
> 
> I think I'm missing the problem you're trying to describe.
> Are you making a general comment / argument on ethtool stats?
> 
> Pause stats are symmetrical - as can be seen in your quote
> what's RX for the CPU is TX for the switch, and vice versa.
> 
> Since ethtool -A $cpu_mac controls whether CPU netdev generates
> and accepts pause frames, correspondingly the direction and meaning
> of pause statistics on that interface is well defined.
> 
> You can still append your custom CPU port stats to ethtool -S or
> debugfs or whatnot, but those are only useful for validating that
> the configuration of the CPU port is not completely broken. Otherwise
> the counters are symmetrical. A day-to-day user of the device doesn't
> need to see both of them.

It would be a lot easier to append the stats if there was not an 
additional ndo introduce to fetch the pause statistics because DSA 
overlay ndo on a function by function basis. Alternatively we should 
consider ethtool netlink operations over a devlink port at some point so 
we can get rid of the ugly ndo and ethtool_ops overlay that DSA does.

Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a 
stringset identifier? That way there is a single point within driver to 
fetch stats.
--
Florian
