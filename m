Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA924FBC65
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbiDKMus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiDKMuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:50:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6327929C87
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:48:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z17so1908511lfj.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Oc2K+2CtJ8Gsak4SaLylSbYXStQK9UEgEevfDiUlLwE=;
        b=OZ0ZFXxU739F6wwrew5uXByw4wxCbP5JXkkyYo7X6/t4bLB6W/fE55gVncDMmB7zZq
         mtPbTvgozTeu6QgdMawj7qfAQD0hqoxIDKCA4+NdoFWPTUqkY3AVHVhcsV43O7I/az3u
         i69AkM/9WGqLE62lG8a6XwE6YO6/y4jFS2yUifCHHnUH0GjzJMW46KfXU0qnQQxzplr2
         NtF4yERCDzjo6Tlknjgb00zmYc2foQ+SyQBFMb53nGu3pdHLFd8xHTd4XEKpj/dGSoOV
         qEA6CyLDfxRlsZObROIKqwiTiKAnWxBuOb69xHO4UmBdNqR4kouP9On9WWfJ5wg9IRXr
         KyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Oc2K+2CtJ8Gsak4SaLylSbYXStQK9UEgEevfDiUlLwE=;
        b=0ZIWt0+fjVqco2f8m6Mbes9XCftQT64Hj28WrX4NfdEsebkXCynfITl3THP/Jz2o1W
         LhwAEZQc2w8e3TDCryYOuK7A9Szzt3GfM3X3JEUJcp2H+/f62JwRUmMrlionWfC0g0o5
         3sD4y0gFxGj6eOiFmDEkQu+UC29Ylp+jMmmXw66Pdn315GKEjc1GFn25+XG8ZeYXDyUd
         p4fQ/pz9YguZeKyf5KjG5IFi1wrS2GL5+tjidPyRtzlldTQ/TqegdPa5iur4PWBGi2KY
         N0hwJ+lmBU4cF+LNlgw2aMHFV02LpVwiOpHSxUWOw9Y4CL2UaVBlklluNOvPlU3O2PJE
         xSDA==
X-Gm-Message-State: AOAM533c+b0i4TSrfLgg0+oyTGfFX8tRRfNyGdMUKEaO8OAXtjnMfxI9
        /O8yBVzQe3mIlnoR/s/YSVo=
X-Google-Smtp-Source: ABdhPJw1KhZylyHZE14RnYyjk62BG6ki/nzCASHYE7T2fjdfBWupq90n34BFgDsAIaJ4+gnPE4054A==
X-Received: by 2002:a05:6512:3fa2:b0:44a:f3f0:47b6 with SMTP id x34-20020a0565123fa200b0044af3f047b6mr22241548lfa.610.1649681310529;
        Mon, 11 Apr 2022 05:48:30 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id f20-20020a193814000000b0046b945c4f99sm716130lfa.167.2022.04.11.05.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 05:48:30 -0700 (PDT)
Message-ID: <aa550823-8d75-d255-232e-e5c1791dbca3@gmail.com>
Date:   Mon, 11 Apr 2022 14:48:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 net-next 0/3] net: dsa: mv88e6xxx: Implement offload of
 matchall for bridged DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
 <20220411123908.i73i7uonbs2qyvjt@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220411123908.i73i7uonbs2qyvjt@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-11 14:39, Vladimir Oltean wrote:
> On Mon, Apr 11, 2022 at 02:06:30PM +0200, Mattias Forsblad wrote:
>> RFC -> v1: Monitor bridge join/leave and re-evaluate offloading (Vladimir Oltean)
>> v2: Fix code standard compliance (Jakub Kicinski)
>> v3: Fix warning from kernel test robot (<lkp@intel.com>)
>> v4: Check matchall priority (Jakub)
>>     Use boolean type (Vladimir)
>>     Use Vladimirs code for checking foreign interfaces
>>     Drop unused argument (Vladimir)
>>     Add switchdev notifier (Vladimir)
> 
> By switchdev notifier you mean SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV?
> I'm sorry, you must have misunderstood. I said, in reference to
> dp->ds->ops->bridge_local_rcv():
> 
> | Not to mention this should be a cross-chip notifier, maybe a
> | cross-tree notifier.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220404104826.1902292-2-mattias.forsblad@gmail.com/#24805497
> 
> A cross-chip notifier is an event signaled using dsa_tree_notify() and
> handled in switch.c. Its purpose is to replicate an event exactly once
> towards all switches in a multi-switch topology.
> 
> You could have explained that this isn't necessary, because
> dsa_slave_setup_bridge_tc_indr_block(netdev=bridge_dev) indirectly binds
> dsa_slave_setup_bridge_block_cb() which calls dsa_slave_setup_tc_block_cb()
> for each user port under said bridge. So replicating the ds->ops->bridge_local_rcv()
> towards each switch is already taken care of in another way, although
> suboptimally, because if there are 4 user ports under br0 in switch A
> and 4 user ports in switch B, ds->ops->bridge_local_rcv() will be called
> 4 times for switch A and 4 times for switch B. 6 out of those 8 calls
> are for nothing.
> 
> Or you could have said that you don't understand the request and ask me
> to clarify.
> 
> But I don't understand why you've added SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV
> which has no consumer. Initially I thought you'd go back to having the
> bridge monitor flow blocks binding to its ingress chain instead of this
> broken indirect stuff, then emit SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV on
> the switchdev notifier chain which DSA catches and offloads. And initial
> state would be synced/unsynced via attribute replays in
> dsa_port_switchdev_sync_attrs(). At least that would have worked.
> But nope. It really looks like SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV was
> added to appease an unclear comment even if it made no sense.
> 

My thinking was that the notifier I was aware of was the one I implemented
and someway was a preparation for consumers (that didn't exist yes). I didn't even
know about dsa_tree_notify(). So I'll remove that part, yes? Is that ok even
if it's not optimal, like you say?


>>     Only call ops when value have changed (Vladimir)
>>     Add error check (Vladimir)
>>
>> Mattias Forsblad (3):
>>   net: dsa: track whetever bridges have foreign interfaces in them
>>   net: dsa: Add support for offloading tc matchall with drop target
>>   net: dsa: mv88e6xxx: Add HW offload support for tc matchall in Marvell
>>     switches
>>
>>  drivers/net/dsa/mv88e6xxx/chip.c |  17 +-
>>  include/net/dsa.h                |  15 ++
>>  include/net/switchdev.h          |   2 +
>>  net/dsa/dsa2.c                   |   2 +
>>  net/dsa/dsa_priv.h               |   3 +
>>  net/dsa/port.c                   |  14 ++
>>  net/dsa/slave.c                  | 321 +++++++++++++++++++++++++++++--
>>  7 files changed, 361 insertions(+), 13 deletions(-)
>>
>> -- 
>> 2.25.1
>>

