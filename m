Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5280C25CB79
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgICUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgICUsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:48:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05478C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 13:48:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w186so3058915pgb.8
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O9kJg8ILQKUFJUfFSy0swZlRXByNmZPCpawRy5x78Mc=;
        b=b3uf5p76RVwn9E6VpNA7SUcZg5gUBm0+y6LQUAmYm7KYmnHmtD9vFjduJKk2eNgvFD
         9RrPKA1LD4ajuRq6Wy6cqa1EdwuKPVfesqs4AG/An2vI9zJZ7m152tc0d4UFetH42tfe
         nePSOeHO6E+bdx4Yex6GFC6NeWd3PjTxJQ/auxYXHtPKMA15v3aupF276A5Q8H0/3xqe
         L7m2BPOt7VEr44YvPVztc8H/i40KOioP4hDGFfUNkWQOrxWfBn/LuFedjheZrV7nGLxQ
         93KgpgG2M2sqPCjqbugi+io1UtG2GyfD/YE96gbnn70+08/g7fNblS+EwUiXilOEIVFr
         busQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O9kJg8ILQKUFJUfFSy0swZlRXByNmZPCpawRy5x78Mc=;
        b=Vtu//mFppsiokAZpwV52dU7r1dwMr7Fb/HqaqWGHWyy9mYHS3uEHYKm68fQYZs3B9+
         DKw31kuole+k0d3ZTaIg6NQdzqVdzpMHKMbhBqW1dOc24VuMmAH1NsB9lmZ7ZuLcyA7o
         BE6JX56hfi856icqlrdMs3tMmyWUbqKVnubwvxkHnasWoGc8GrIvIKc4VPXVs9aJ3UwL
         Xl2+MCXtreo2kX7a0wu7yANTMxZh2D9XjtGt6QuLLcMTQVpHpU12EClsSQto5jlqXoPx
         AbLapvV02jxZ0TTueGJiW5wDjr+vC7w/Vfjs56r/nXHSPfoUUQ+IYy0HQaxV4qIqtB++
         DmNQ==
X-Gm-Message-State: AOAM532BB/V82k8HHDB2KQ4VhVeg48CtezQ1uEM+9EgMw3GsNYhVlXip
        aCEzlWyRvtxgqqaPcI5uWL0=
X-Google-Smtp-Source: ABdhPJz1YRA8Buxu1MKJnk2O6WqKW+sIKFidreVWilMYgpUHxrmCIgrKLsk/Hjb9xCMycm/5zJYcmg==
X-Received: by 2002:a63:d43:: with SMTP id 3mr4452807pgn.170.1599166122254;
        Thu, 03 Sep 2020 13:48:42 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d65sm1710455pfd.82.2020.09.03.13.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 13:48:41 -0700 (PDT)
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
To:     Jakub Kicinski <kuba@kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, andrew@lunn.ch,
        mkubecek@suse.cz, dsahern@gmail.com,
        Michael Chan <michael.chan@broadcom.com>, saeedm@mellanox.com,
        rmk+kernel@armlinux.org.uk
References: <20200903020336.2302858-1-kuba@kernel.org>
 <CAKOOJTwwZ0wug6Wn6vVmvyWX=vz_n1shu5t_Gf-NT21MP7HMxg@mail.gmail.com>
 <20200903134507.4ba426f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <52ad841c-c51d-f606-09e3-e757fc0d193b@gmail.com>
Date:   Thu, 3 Sep 2020 13:48:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903134507.4ba426f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 1:45 PM, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 09:29:22 -0700 Edwin Peer wrote:
>> On Wed, Sep 2, 2020 at 7:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>> +Drivers should report all statistics which have a matching member in
>>> +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` exclusively
>>> +via `.ndo_get_stats64`. Reporting such standard stats via ethtool
>>> +or debugfs will not be accepted.
>>
>> Should existing drivers that currently duplicate standard stats in the
>> ethtool list be revised also?
> 
> That's probably considered uAPI land. I've removed the stats from the
> nfp awhile back, and nobody complained, but I'm thinking to leave the
> decision to individual maintainers.
> 
> Funnily enough number of 10G and 40G drivers report tx_heartbeat_errors
> in their ethtool stats (always as 0). Explainer what the statistic
> counts for a contemporary reader:
> 
> http://www.ethermanage.com/ethernet/sqe/sqe.html
> 
>>> + * @rx_packets: Number of good packets received by the interface.
>>> + *   For hardware interfaces counts all good packets seen by the host,
>>> + *   including packets which host had to drop at various stages of processing
>>> + *   (even in the driver).
>>
>> This is perhaps a bit ambiguous. I think you mean to say packets received from
>> the device, but I could also interpret the above to mean received by the device
>> if 'host' is read to be the whole physical machine (ie. including NIC hardware)
>> instead of the part that is apart from the NIC from the NIC's perspective.
> 
> How about:
> 
>    For hardware interfaces counts all good packets received from the
>    device by the host, including packets which host had to drop...
> 
>>> + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.
>>> + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.
>>
>> Including or excluding FCS?
> 
> Good point, no FCS is probably a reasonable expectation.
> 
> I'm not sure what to say about pad. I'm tempted to also mention that
> for tx we shouldn't count pad, no? (IOW Ethernet Frame - FCS - pad)

It depends I would say, if the driver needed to add padding in order to 
get the frame to be transmitted because the Ethernet MAC cannot pad 
automatically then it would seem natural to count the added padding. If 
you implement BQL that is what you will be reporting because that how 
much travels on the wire. What do you think?

> 
>>> + *   For Ethernet devices this counter may be equivalent to:
>>> + *
>>> + *    - 30.3.1.1.21 aMulticastFramesReceivedOK
>>
>> You mention the IEEE standard in your commit message, but I don't think this
>> document properly cites what you are referring to here? It might be an idea to
>> say "IEEE 30.3.1.1.21 aMulticastFramesReceivedOK" here and provide an
>> appropriate citation reference at the end, or perhaps a link.
> 
> How about I replace Ethernet with IEEE 802.3:
> 
>    For IEEE 802.3 devices this counter may be equivalent to:
> 
>     - 30.3.1.1.21 aMulticastFramesReceivedOK
> 

-- 
Florian
