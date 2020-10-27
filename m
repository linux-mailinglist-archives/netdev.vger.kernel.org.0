Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1729C95E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 21:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1830632AbgJ0UCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 16:02:25 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43932 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgJ0UCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 16:02:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id dn5so2741307edb.10
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 13:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0G9OKjR/V/MFCD6RZt0kNwqDdd7UFzCDFa82Mj0f478=;
        b=WQZKcQcLXVKd9UWfh6ygAld1F8wvDIAYwpir2fiqFLMZQav29DauBCLUmOAh9Vff7j
         S/Mg+nMgWG01QBmXp5cRrASl3DnygPaWu7SArVtwu9+Ps0igM59MsJj2NcH/5rn6e3Z9
         ZC3iTsWDO7BctOXbnwCL12RjXzTGJLW08gP1yO55U7UEyhvOB9+rd5ercToctuDc0YqD
         G+hIaNLFDaw/V3tMZPChQL95PDhGrckpbL9bqiOiUtfaAGpa3dCrfsGtX+OkbA4AHtHz
         MTXaOI2EKxplZM2kn3J0TkHphT5zOSKlxu08tmkdUWO1kyTPC5IGRe71LdPuijqZomcQ
         PfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0G9OKjR/V/MFCD6RZt0kNwqDdd7UFzCDFa82Mj0f478=;
        b=CDUUVVBohKreA56Xf0yzXxn0/ZTBB9BATAf364DM3c+DjXpZ/3Wd2Y6ArY5wlvuj+8
         8N/h50GKmNIdC4jkw4ncFqRnF+/bHRLzaj9Z848nKDaI+sxKWCe5LgfYZSPhGjRL8iRO
         8w9VgjpLzvvwgh+qhSw6iKX/8dUNNQULm9kEiPbxQKlvEXlDw/YRNko2TmmFe06LPXZw
         NwIgizaHxmIIuwrqb94IcYhF53jgrnXd1033Bl4WWcRdKQHIaNw+h90rshy1HLl6kiEf
         TzxHfORZwN2DZ49wWz4yropzehIpeTQs8NSVqDacu6wc6HtJw93CSEQ8UJMCkyf9XjI0
         W3XA==
X-Gm-Message-State: AOAM53358+yMDYxqbKmJuj93gn0kKADjD5Z1xhnXOcsxYBa2wy8WJvff
        Ww6K9ZsrhXoCbtBaM61rezQ=
X-Google-Smtp-Source: ABdhPJygp9DaQXfPjs2QiwDSMjMEi1nlc4wu/ftXOVQYxbMbmBPqxqhQuP3XfU9kWx+pwv/w74szxA==
X-Received: by 2002:a05:6402:17ad:: with SMTP id j13mr1005984edy.347.1603828942325;
        Tue, 27 Oct 2020 13:02:22 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 6sm1603650ejv.49.2020.10.27.13.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:02:21 -0700 (PDT)
Date:   Tue, 27 Oct 2020 22:02:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027200220.3ai2lcyrxkvmd2f4@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027160530.11fc42db@nic.cz>
 <20201027152330.GF878328@lunn.ch>
 <87k0vbv84z.fsf@waldekranz.com>
 <20201027190034.utk3kkywc54zuxfn@skbuf>
 <87blgnv4rt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blgnv4rt.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 08:37:58PM +0100, Tobias Waldekranz wrote:
> >> In order for this to work on transmit, we need to add forward offloading
> >> to the bridge so that we can, for example, send one FORWARD from the CPU
> >> to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.

[...]

> In a single-chip system I agree that it is not needed, the CPU can do
> the load-balancing in software. But in order to have the hardware do
> load-balancing on a switch-to-switch LAG, you need to send a FORWARD.
> 
> FROM_CPUs would just follow whatever is in the device mapping table. You
> essentially have the inverse of the TO_CPU problem, but on Tx FROM_CPU
> would make up 100% of traffic.

Woah, hold on, could you explain in more detail for non-expert people
like myself to understand.

So FROM_CPU frames (what tag_edsa.c uses now in xmit) can encode a
_single_ destination port in the frame header.

Whereas the FORWARD frames encode a _source_ port in the frame header.
You inject FORWARD frames from the CPU port, and you just let the L2
forwarding process select the adequate destination ports (or LAG, if
any ports are under one) _automatically_. The reason why you do this, is
because you want to take advantage of the switch's flooding abilities in
order to replicate the packet into 4 packets. So you will avoid cloning
that packet in the bridge in the first place.

But correct me if I'm wrong, sending a FORWARD frame from the CPU is a
slippery slope, since you're never sure that the switch will perform the
replication exactly as you intended to. The switch will replicate a
FORWARD frame by looking up the FDB, and we don't even attempt in DSA to
keep the FDB in sync between software and hardware. And that's why we
send FROM_CPU frames in tag_edsa.c and not FORWARD frames.

What you are really looking for is hardware where the destination field
for FROM_CPU packets is not a single port index, but a port mask.

Right?

Also, this problem is completely orthogonal to LAG? Where does LAG even
come into play here?

> Other than that there are some things that, while strictly speaking
> possible to do without FORWARDs, become much easier to deal with:
> 
> - Multicast routing. This is one case where performance _really_ suffers
>   from having to skb_clone() to each recipient.
> 
> - Bridging between virtual interfaces and DSA ports. Typical example is
>   an L2 VPN tunnel or one end of a veth pair. On FROM_CPUs, the switch
>   can not perform SA learning, which means that once you bridge traffic
>   from the VPN out to a DSA port, the return traffic will be classified
>   as unknown unicast by the switch and be flooded everywhere.

And how is this going to solve that problem? You mean that the switch
learns only from FORWARD, but not from FROM_CPU?

Why don't you attempt to solve this more generically somehow? Your
switch is not the only one that can't perform source address learning
for injected traffic, there are tons more, some are not even DSA. We
can't have everybody roll their own solution.
