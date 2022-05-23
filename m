Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BECE531E3A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 23:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiEWVxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 17:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiEWVxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 17:53:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C871B82D8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:53:17 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id a9so12746918pgv.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2PvCUJqO/D7+tSH2/svNE48KB1CyrmMsg/9dSQIv6wM=;
        b=IEu0Aq6spUeiLT/QWD3L4ISVT+2OR/KcLLYDoQZdJ4d2rcNnbqbc7A4rk9zb9WErB8
         +vvrHNGLRYUAixiSJF69kCWn24GQ10HpIQnQ271GMxukVXKWilrDplsb7VTA4pucbJ8l
         TQpRvFoZjB/PSiBrhBiDeGaqeSObFe+E/XxE1p0khgCSNWmoMcEWHzfyGHg3FWnHpoP8
         5kUHkX8TsQyjGjRHjX7DSSJMhunQsz5QxBR6KbD1cktUc8mfXHQ6JkfjIChY5+FnuQ9V
         KQZQeyqxOBs0OVZq+zvljVTqKsk76649cDnzbAOfclekb+a49Sztxl8ZKN8QjKM0648d
         pXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2PvCUJqO/D7+tSH2/svNE48KB1CyrmMsg/9dSQIv6wM=;
        b=nC0ecxPTBixnjqF3vyKC8flK8ox1d1tvjbrh0L38nF6tpawZodOMvUx9BxlLSzJBzC
         dkVXB5DgE9j9Ug8OydrVUI2cmn/FTbs5u1YA2KpWvlKFe5akj2y6ZiaIk/YA8jo1jpwq
         +jay6LHO0BPGcAv3qxOGV7JqdBQORJ4UJ2YPIYP2FaJtnL4YTPUjolg0jn3ohjpWy1QG
         7XBhk8ploiy5EJjEJB89DNk/aHbKxtl5joAeL4mvGhS1GL9Xkey5b2f7+tvrjhFWljDq
         bP2HEuCWnw+64Chq4fNPMjKAn03AyBxKqk+YNwk3Wjbgcu3Fe7qUfy6GeMWpAu98iZZH
         ob5Q==
X-Gm-Message-State: AOAM533aSIHcfCxS4cZr686ulNd2sznzV8jG2aN8t7UMcV6IFA6qC+hv
        ApNSPL3bx1K3j6RvZJ7aIPg=
X-Google-Smtp-Source: ABdhPJzjAcrLF+gFZgISahvRED/cN9nwShceRpECmM9uul3DEA8Tlw4+4yZyzf+7DCxMZmPwJPBiuQ==
X-Received: by 2002:a65:44c1:0:b0:3f6:26e8:77a9 with SMTP id g1-20020a6544c1000000b003f626e877a9mr21738684pgs.204.1653342796850;
        Mon, 23 May 2022 14:53:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d10-20020a17090a2a4a00b001ded49491basm563586pjg.2.2022.05.23.14.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 14:53:16 -0700 (PDT)
Message-ID: <3d6a78b5-1570-5c6d-8f81-465fc2c9c9a8@gmail.com>
Date:   Mon, 23 May 2022 14:53:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Note: this patch set isn't probably tested nearly well enough, and
> contains (at least minor) bugs. Don't do crazy things with it. I'm
> posting it to get feedback on the proposed UAPI.
> 
> Those who have been following part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> and part 2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> will know that I am trying to enable the second internal port pair from
> the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> This series represents part 3 of that effort.
> 
> Covered here are some code structure changes so that DSA monitors
> changeupper events of its masters, as well as new UAPI introduction via
> rtnetlink for changing the current master. Note, in the case of a LAG
> DSA master, DSA user ports can be assigned to the LAG in 2 ways, either
> through this new IFLA_DSA_MASTER, or simply when their existing DSA
> master joins a LAG.
> 
> Compared to previous attempts to introduce support for multiple CPU ports:
> https://lore.kernel.org/netdev/20210410133454.4768-1-ansuelsmth@gmail.com/
> 
> my proposal is to not change anything in the default behavior (i.e.
> still start off with the first CPU port from the device tree as the only
> active CPU port). But focus is instead put on being able to live-change
> what the user-to-CPU-port affinity is. Marek Behun has expressed a
> potential use case as being to dynamically load balance the termination
> of ports between CPU ports, and that should be best handled by a user
> space daemon if it only had the means - this creates the means.
> 
> Host address filtering is interesting with multiple CPU ports.
> There are 2 types of host filtered addresses to consider:
> - standalone MAC addresses of ports. These are either inherited from the
>    respective DSA masters of the ports, or from the device tree blob.
> - local bridge FDB entries.
> 
> Traditionally, DSA manages host-filtered addresses by calling
> port_fdb_add(dp->cpu_dp->index) in the appropriate database.
> But for example, when we have 2 bridged DSA user ports, one with CPU
> port A and the other with CPU port B, and the bridge offloads a local
> FDB entry for 00:01:02:03:04:05, DSA would attempt to first call
> port_fdb_add(A, 00:01:02:03:04:05, DSA_DB_BRIDGE), then
> port_fdb_add(B, 00:01:02:03:04:05, DSA_DB_BRIDGE). And since an FDB
> entry can have a single destination, the second port_fdb_add()
> overwrites the first one, and locally terminated traffic for the ports
> assigned to CPU port A is broken.
> 
> What should be done in that situation, at least with the HW I'm working
> with, is that the host filtered addresses should be delivered towards a
> "multicast" destination that covers both CPU ports, and let the
> forwarding matrix eliminate the CPU port that the current user port
> isn't affine to.
> 
> In my proposed patch set, the Felix driver does exactly that: host
> filtered addresses are learned towards a special PGID_CPU that has both
> tag_8021q CPU ports as destinations.
> 
> I have considered introducing new dsa_switch_ops API in the form of
> host_fdb_add(user port) and host_fdb_del(user port) rather than calling
> port_fdb_add(cpu port). After all, this would be similar to the newly
> introduced port_set_host_flood(user port). But I need to think a bit
> more whether it's needed right away.
> 
> Finally, there's LAG. Proposals have been made before to describe in DT
> that CPU ports are under a LAG, the idea being that we could then do the
> same for DSA (cascade) ports. The common problem is that shared (CPU and
> DSA) ports have no netdev exposed.
> 
> I didn't do that, instead I went for the more natural approach of saying
> that if the CPU ports are in a LAG, then the DSA masters are in a
> symmetric LAG as well. So why not just monitor when the DSA masters join
> a LAG, and piggyback on that configuration and make DSA reconfigure
> itself accordingly.
> 
> So LAG devices can now be DSA masters, and this is accomplished by
> populating their dev->dsa_ptr. Note that we do not create a specific
> struct dsa_port to populate their dsa_ptr, instead we reuse the dsa_ptr
> of one of the physical DSA masters (the first one, in fact).

This looks pretty good to me and did not blow up with bcm_sf2 not 
implementing port_change_master, so far so good.
-- 
Florian
