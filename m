Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF94E4A368E
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 14:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354926AbiA3N7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 08:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354916AbiA3N7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 08:59:15 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC6C061714;
        Sun, 30 Jan 2022 05:59:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m11so21554921edi.13;
        Sun, 30 Jan 2022 05:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycTbeWVF2k4ldeYij/DKOzznuWwYeGFWN8BJHoJuoyE=;
        b=jN3jnwWsU9nD9Nd8JMncMCVZcuX311nzUmbsFxdvy7+gUZWQ3T3vz+y/AxQ2ejDvea
         YXEBx+O9LdppbXvRVFLtMvuodYUaXCcJRtJ6+8maueSFcejgdlSn9rZL3tZLhM2fn7bZ
         KUcIEzPCawuy++O2pmNl7TQOpyMH6Hfshc5EhPLCGSYwvVfQjXi7rVL6MET/3WPJt7Ur
         LZaqR/2qYjLkoCsOn/MqhTGjujzxzCVpFA5fON7OwkVEJ/aOaiXUX1w5gUGNq/3x8jRU
         4XtNQMcFkeYwaJvZXD7viueZeY2rmECgB6M0M932ztOGe1yG1PYw/YoESIW4d9Y+6Bex
         +qKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ycTbeWVF2k4ldeYij/DKOzznuWwYeGFWN8BJHoJuoyE=;
        b=ZSDrIjwuuE1LMfDlB2ePwK69WPiQXv+Vz/RU6SkQwTmvYkS77MXIWPtQGwPMXsMILy
         WdZM+0hDP47TzDsjes7dLDtUElz/mMV9T5RB0LK2Jus1Ktp0t6yocbGnQJPTVZxCgzm4
         t0qFtF8HaqtXnPK2GdhVVEQFsp8SKYNwo3v0Z4g8FRUf7UCpN6CfVD8fpXFvWo98NzuG
         opZqYC4YJXZjMA9Y2GFKGWLxPD3c4gFsfHPGSBae0Di5zs0itmKXAWY3G6+qwgPMBT9q
         EPqxHyJK+TuX+Z2hpdloKKQ+XwGKf+IwOaoqWYuYSvn+IexwH+seOUasqNuqd5OG4BjG
         UJPA==
X-Gm-Message-State: AOAM533Iw4J34aPEFzCORWBwj0SoEMAJm3M3t21/Gs7D3rlQF32imMcB
        Bd8Us//1khmwWjlj8tM8u78=
X-Google-Smtp-Source: ABdhPJxTV8e96JL/W7bqFfbr97rk0tU1Mt3imLw62b0KyMpOWnQ8gObZH/MTkScWlqyrvQkmLf4/Lw==
X-Received: by 2002:a05:6402:430e:: with SMTP id m14mr16864890edc.86.1643551152898;
        Sun, 30 Jan 2022 05:59:12 -0800 (PST)
Received: from Ansuel-xps.localdomain ([87.13.143.9])
        by smtp.gmail.com with ESMTPSA id bv2sm12176256ejb.154.2022.01.30.05.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 05:59:12 -0800 (PST)
Date:   Sun, 30 Jan 2022 14:59:10 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:21AM +0100, Ansuel Smith wrote:
> Hi, this is ready but require some additional test on a wider userbase.
> 
> The main reason for this is that we notice some routing problem in the
> switch and it seems assisted learning is needed. Considering mdio is
> quite slow due to the indirect write using this Ethernet alternative way
> seems to be quicker.
> 
> The qca8k switch supports a special way to pass mdio read/write request
> using specially crafted Ethernet packet.
> This works by putting some defined data in the Ethernet header where the
> mac source and dst should be placed. The Ethernet type header is set to qca
> header and is set to a mdio read/write type.
> This is used to communicate to the switch that this is a special packet
> and should be parsed differently.
> 
> Currently we use Ethernet packet for
> - MIB counter
> - mdio read/write configuration
> - phy read/write for each port
> 
> Current implementation of this use completion API to wait for the packet
> to be processed by the tagger and has a timeout that fallback to the
> legacy mdio way and mutex to enforce one transaction at time.
> 
> We now have connect()/disconnect() ops for the tagger. They are used to
> allocate priv data in the dsa priv. The header still has to be put in
> global include to make it usable by a dsa driver.
> They are called when the tag is connect to the dst and the data is freed
> using discconect on tagger change.
> 
> (if someone wonder why the bind function is put at in the general setup
> function it's because tag is set in the cpu port where the notifier is
> still not available and we require the notifier to sen the
> tag_proto_connect() event.
> 
> We now have a tag_proto_connect() for the dsa driver used to put
> additional data in the tagger priv (that is actually the dsa priv).
> This is called using a switch event DSA_NOTIFIER_TAG_PROTO_CONNECT.
> Current use for this is adding handler for the Ethernet packet to keep
> the tagger code as dumb as possible.
> 
> The tagger priv implement only the handler for the special packet. All the
> other stuff is placed in the qca8k_priv and the tagger has to access
> it under lock.
> 
> We use the new API from Vladimir to track if the master port is
> operational or not. We had to track many thing to reach a usable state.
> Checking if the port is UP is not enough and tracking a NETDEV_CHANGE is
> also not enough since it use also for other task. The correct way was
> both track for interface UP and if a qdisc was assigned to the
> interface. That tells us the port (and the tagger indirectly) is ready
> to accept and process packet.
> 
> I tested this with multicpu port and with port6 set as the unique port and
> it's sad.
> It seems they implemented this feature in a bad way and this is only
> supported with cpu port0. When cpu port6 is the unique port, the switch
> doesn't send ack packet. With multicpu port, packet ack are not duplicated
> and only cpu port0 sends them. This is the same for the MIB counter.
> For this reason this feature is enabled only when cpu port0 is enabled and
> operational.
> 
> 
> 
> 
> Sorry if I missed any comments. This series is 2 month old so I think it
> would be good to recheck everything. In the mean time this was tested on
> and no regression are observed related to random port drop.
> 
> v7:
> - Rebase on net-next changes
> - Add bulk patches to speedup this even more
> v6:
> - Fix some error in ethtool handler caused by rebase/cleanup
> v5:
> - Adapt to new API fixes
> - Fix a wrong logic for noop
> - Add additional lock for master_state change
> - Limit mdio Ethernet to cpu port0 (switch limitation)
> - Add priority to these special packet
> - Move mdio cache to qca8k_priv
> v4:
> - Remove duplicate patch sent by mistake.
> v3:
> - Include MIB with Ethernet packet.
> - Include phy read/write with Ethernet packet.
> - Reorganize code with new API.
> - Introuce master tracking by Vladimir
> v2:
> - Address all suggestion from Vladimir.
>   Try to generilize this with connect/disconnect function from the
>   tagger and tag_proto_connect for the driver.
> 
> Ansuel Smith (14):
>   net: dsa: tag_qca: convert to FIELD macro
>   net: dsa: tag_qca: move define to include linux/dsa
>   net: dsa: tag_qca: enable promisc_on_master flag
>   net: dsa: tag_qca: add define for handling mgmt Ethernet packet
>   net: dsa: tag_qca: add define for handling MIB packet
>   net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet
>     packet
>   net: dsa: qca8k: add tracking state of master port
>   net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
>   net: dsa: qca8k: add support for mib autocast in Ethernet packet
>   net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
>   net: dsa: qca8k: move page cache to driver priv
>   net: dsa: qca8k: cache lo and hi for mdio write
>   net: da: qca8k: add support for larger read/write size with mgmt
>     Ethernet
>   net: dsa: qca8k: introduce qca8k_bulk_read/write function
> 
> Vladimir Oltean (2):
>   net: dsa: provide switch operations for tracking the master state
>   net: dsa: replay master state events in
>     dsa_tree_{setup,teardown}_master
> 
>  drivers/net/dsa/qca8k.c     | 709 +++++++++++++++++++++++++++++++++---
>  drivers/net/dsa/qca8k.h     |  46 ++-
>  include/linux/dsa/tag_qca.h |  82 +++++
>  include/net/dsa.h           |  17 +
>  net/dsa/dsa2.c              |  74 +++-
>  net/dsa/dsa_priv.h          |  13 +
>  net/dsa/slave.c             |  32 ++
>  net/dsa/switch.c            |  15 +
>  net/dsa/tag_qca.c           |  83 +++--
>  9 files changed, 993 insertions(+), 78 deletions(-)
>  create mode 100644 include/linux/dsa/tag_qca.h
> 
> -- 
> 2.33.1
> 

Hi,
sorry for the delay in sending v8, it's ready but I'm far from home and
I still need to check some mdio improvement with pointer handling.

Anyway I have some concern aboutall the skb alloc.
I wonder if that part can be improved at the cost of some additional
space used.

The idea Is to use the cache stuff also for the eth skb (or duplicate
it?) And use something like build_skb and recycle the skb space
everytime...
This comes from the fact that packet size is ALWAYS the same and it
seems stupid to allocate and free it everytime. Considering we also
enforce a one way transaction (we send packet and we wait for response)
this makes the allocation process even more stupid.

So I wonder if we would have some perf improvement/less load by
declaring the mgmt eth space and build an skb that always use that
preallocate space and just modify data.

I would really love some feedback considering qca8k is also used in very
low spec ath79 device where we need to reduce the load in every way
possible. Also if anyone have more ideas on how to improve this to make
it less heavy cpu side, feel free to point it out even if it would
mean that my implemenation is complete sh*t.

(The use of caching the address would permit us to reduce the write to
this preallocated space even more or ideally to send the same skb)

-- 
	Ansuel
