Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0ABD32EF0C
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCEPhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 10:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhCEPhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 10:37:46 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3A6C061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 07:37:46 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a17so2178320oto.5
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 07:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ntdhwoIS2Ol4O/YRB96v3sBqCygp5Sy2SwrrmJATy0E=;
        b=sgG8eu/SqSd/VhGgBfR3AJqrg41pwQbj4FEk9VPhoYLzWdSmKEDcZ5fAelamhTZPi8
         +wplRh2ZgUMXproCi9ObIFbv5Zu4UG2JNpuDY75UX1FmGyjbO+iTS8hLoUcVF/EDwp2S
         sw49P1knzTC5xv9surd0WzIamJhFxwHh3q0E4PthEK8mgCBGNIRscgfMxX9TBeG07PVr
         jVGDiDUEA/CAXdLRBC7kP/U1P7CelNPxHxvXlZ36VJGfEGZBUibQcIFfbUm9gButvMhF
         5FwBUYz7ieXIQzDBbv9XwITIrUGLgSmphZyWo5orsNsSNTUxKSoxowKlH4qY3JWyypCl
         nDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntdhwoIS2Ol4O/YRB96v3sBqCygp5Sy2SwrrmJATy0E=;
        b=DjJdEzwRxzsjX4qorbvmeyqed29snj2GX2qKIhF/CIS/2L8Rfs7kyCXwnb7dEvKutM
         TXs6sAo7wkmKoxfONuxxcX1L/VyNUKEhDthfwxmFI8mZsxAco9KsHZ+BaNvZamApevuI
         tc08kgYxqSWODxNkTvKx3C8pHPXxPb2ds1KycNyhSTC+xek7jDA8UMcuSd1Qw29XzVei
         49Q28ecFx4XKzrwrfeX8kJrXRDC/cGeME2+tpgUhqUM/ftR5MvJiaPikgZB3B2wcbyCM
         8oE7sQ7P/hWqwWryutNS+F+OORFo5MB+sZOWDxnEcmgX2GXBfgWsxtKjNjY1J5os1niY
         pGww==
X-Gm-Message-State: AOAM533Xc6FU9q4WaTHaS5Yimtd3f5n5cALkuwGPfFUC6ykWQkviP+Mt
        4pKKpay7SIbBIrzbSi8lRrAT4uDKtlo=
X-Google-Smtp-Source: ABdhPJybOHVfbB59ijUaIskGYcOUlYFIS6gDRtXAlBlCyHtwePIN47N/5CmdZTjNgUjCjKhcb9L7kQ==
X-Received: by 2002:a05:6830:1502:: with SMTP id k2mr8766517otp.166.1614958665935;
        Fri, 05 Mar 2021 07:37:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id a30sm619451oiy.42.2021.03.05.07.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 07:37:45 -0800 (PST)
Subject: Re: VRF leaking doesn't work
To:     Greesha Mikhalkin <grigoriymikhalkin@gmail.com>,
        netdev@vger.kernel.org
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a47aac93-d528-beee-a2a7-ce4b12c718b9@gmail.com>
Date:   Fri, 5 Mar 2021 08:37:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 3:57 AM, Greesha Mikhalkin wrote:
> Hi. I need a help to understand why VRF leaking doesn’t work in my situation.
> I want to set up leaking between 2 VRFs, that are set up by following commands:
> 
>       # Setup bridge
>       sudo ip link add bridge type bridge
> 
>       # Setup VLANs
>       ip link add link bridge name vlan1 type vlan id 1
>       ip link add link bridge name vlan2 type vlan id 2
>       ip addr add 10.0.0.31/32 dev vlan1
>       ip addr add 10.0.0.32/32 dev vlan2
>       ip link set vlan1 up
>       ip link set vlan2 up
> 
>       # Setup VXLANs
>       ip link add vni1 type vxlan id 1 local 10.1.0.1 dev lan1 srcport
> 0 0 dstport 4789 nolearning
>       ip link add vni2 type vxlan id 2 local 10.1.0.1 dev lan1 srcport
> 0 0 dstport 4789 nolearning
>       ip link set vni1 master bridge
>       ip link set vni2 master bridge
>       bridge vlan add dev vni1 vid 1 pvid untagged
>       bridge vlan add dev vni2 vid 2 pvid untagged
>       ip link set vni1 up
>       ip link set vni2 up
> 
>       # Setup VRFs
>       ip link add vrf1 type vrf table 1000
>       ip link set dev vrf1 up
>       ip link add vrf2 type vrf table 1001
>       ip link set dev vrf2 up
> 
>     Setting routes:
> 
>       # Unreachable default routes
>       ip route add table 1000 unreachable default metric 4278198272
>       ip route add table 1001 unreachable default metric 4278198272
> 
>       # Nexthop
>       ip route add table 1000 100.255.254.3 proto bgp metric 20
> nexthop via 10.0.0.11 dev vlan1 weight 1 onlink
> 
> I'm trying to setup VRF leaking in following way:
> 
>       ip r a vrf vrf2 100.255.254.3/32 dev vrf1
>       ip r a vrf vrf2 10.0.0.31/32 dev vrf1
>       ip r a vrf vrf1 10.0.0.32/32 dev vrf2
> 
> Main goal is that 100.255.254.3 should be reachable from vrf2. But
> after this setup it doesn’t work. When i run `ping -I vrf2
> 100.255.254.3` it sends packets from source address that belongs to
> vlan1 enslaved by vrf1. I can see in tcpdump that ICMP packets are
> sent and then returned to source address but they're not returned to
> ping command for some reason. To be clear `ping -I vrf1 …` works fine.
> 

What kernel version? If you have not tried 5.10 or 5.11, please do.
