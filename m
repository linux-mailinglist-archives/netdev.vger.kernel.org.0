Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0F4CAEB8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbiCBTb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCBTb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:31:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FAFD64F5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:30:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h17so2454295plc.5
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=c8iavTYSZtTHkQTvUlJdWFExD94rcN/KiGbYJ4UsBRc=;
        b=YxLrR5R+6xrjuIRazephUgnJ9Dw9t5rzaFNmjb/G9hh7W8vD0XADNlpmMXLlwkcsA2
         FIqVuqOLgLH8Go9zZ5sytfaOA6A1MW+Oh7U8OFo6BS2th4irAO5UOw8Xxs91QoOZnN0N
         jkfl3++TIp6EnzYjPzhKWpEGz81O7u/1jqeiqdUe2veZLjt2Vpfe1StgLtS2XeHeCC1m
         VYQK9JoN8mFFSh4xcmZ6zcw6ASIhT4xLBunQdlXpRVcgcelh5MosqM72uZI06Ij8oRUy
         Rk3YGgOvb19Ol1S444DuQLrjyOyUbYC/5T7Zrbvc2/1k3a+C7seZ0rtbP5oxV34CHdOv
         F3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c8iavTYSZtTHkQTvUlJdWFExD94rcN/KiGbYJ4UsBRc=;
        b=UDEkCfBEPxhySMnKj1NZGskn6TwBAR4BCN0trbKgSE0AXyRBQIa0yosIdZae5vrTse
         k1YNv71as6j6Dy1mPci+0Xtu5hl4zmu8WtuDz3ux7wzxtG1Y/gjLbUnBhVhGdy6ulT/D
         KQKXq4IU9cKfvnRzwyQQoC+cCcPnxI1D3Xk+NDrryreLJVKMX4wlh2lFPk3nav3ZmOgg
         c4jCmxhbwOoMmObZOscGe2DWyzRK2feIcWBRifg/doQWfoSl/1P1y7/zIxnpyxvGgX9n
         MaIjmbzhqXRBrzcfBzTBY5QbJafUpSfiyEb8wNYIkjqldbAzC6iXqiz9Iq+9+gRlPPvc
         9+Iw==
X-Gm-Message-State: AOAM530Nd0pyY+VMGy8i2MmxqePZZJFIeO+GIZ1qysYApig3veXfmuFf
        tcyXeKQlcODqRebddnHPt+QeF0yCkZU=
X-Google-Smtp-Source: ABdhPJxMJSKDNTZAImVz/7CUxjqkyMzhXHDk0JCjTW0ddepfmGftE2n2KeCxSH7exnryW56tdQKQ2Q==
X-Received: by 2002:a17:902:db0f:b0:151:5fbb:5f4b with SMTP id m15-20020a170902db0f00b001515fbb5f4bmr18882125plx.36.1646249444207;
        Wed, 02 Mar 2022 11:30:44 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r10-20020a635d0a000000b0035d81dd2a09sm16389187pgb.81.2022.03.02.11.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 11:30:43 -0800 (PST)
Message-ID: <8b65b656-bf65-7fa5-f1f2-72429708cf41@gmail.com>
Date:   Wed, 2 Mar 2022 11:30:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 3/2/2022 11:14 AM, Vladimir Oltean wrote:
> This series doesn't attempt anything extremely brave, it just changes
> the way in which standalone ports which support FDB isolation work.
> 
> Up until now, DSA has recommended that switch drivers configure
> standalone ports in a separate VID/FID with learning disabled, and with
> the CPU port as the only destination, reached trivially via flooding.
> That works, except that standalone ports will deliver all packets to the
> CPU. We can leverage the hardware FDB as a MAC DA filter, and disable
> flooding towards the CPU port, to force the dropping of packets with
> unknown MAC DA.
> 
> We handle port promiscuity by re-enabling flooding towards the CPU port.
> This is relevant because the bridge puts its automatic (learning +
> flooding) ports in promiscuous mode, and this makes some things work
> automagically, like for example bridging with a foreign interface.
> We don't delve yet into the territory of managing CPU flooding more
> aggressively while under a bridge.
> 
> The only switch driver that benefits from this work right now is the
> NXP LS1028A switch (felix). The others need to implement FDB isolation
> first, before DSA is going to install entries to the port's standalone
> database. Otherwise, these entries might collide with bridge FDB/MDB
> entries.
> 
> This work was done mainly to have all the required features in place
> before somebody starts seriously architecting DSA support for multiple
> CPU ports. Otherwise it is much more difficult to bolt these features on
> top of multiple CPU ports.

Thanks a lot for submitting this, really happy to see a solution being 
brought upstream. I will be reviewing this in more details later on, but 
from where I left a few years ago, the two challenges that I had are 
outlined below, and I believe we have not quite addressed them yet:

- for switches that implement global VLAN filtering, upper VLAN 
interfaces on top of standalone ports would require programming FDB and 
MDB entries with the appropriate VLAN ID, however there is no such 
tracking today AFAICT, so we are not yet solving those use cases yet, right?

- what if the switch does not support FDB/MDB isolation, what would be 
our options here? As you might remember from a few months ago, the 
Broadcom roboswitch do not have any isolation, but what they can do is 
internally tag Ethernet frames with two VLAN tags, an that may be used 
as a form of isolation

> 
> Vladimir Oltean (10):
>    net: dsa: remove workarounds for changing master promisc/allmulti only
>      while up
>    net: dsa: rename the host FDB and MDB methods to contain the "bridge"
>      namespace
>    net: dsa: install secondary unicast and multicast addresses as host
>      FDB/MDB
>    net: dsa: install the primary unicast MAC address as standalone port
>      host FDB
>    net: dsa: manage flooding on the CPU ports
>    net: dsa: felix: migrate host FDB and MDB entries when changing tag
>      proto
>    net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port
>    net: dsa: felix: start off with flooding disabled on the CPU port
>    net: dsa: felix: stop clearing CPU flooding in felix_setup_tag_8021q
>    net: mscc: ocelot: accept configuring bridge port flags on the NPI
>      port
> 
>   drivers/net/dsa/ocelot/felix.c     | 241 ++++++++++++++++++++------
>   drivers/net/ethernet/mscc/ocelot.c |   3 +
>   include/net/dsa.h                  |   7 +
>   net/dsa/dsa.c                      |  40 +++++
>   net/dsa/dsa_priv.h                 |  53 +++++-
>   net/dsa/port.c                     | 160 +++++++++++++-----
>   net/dsa/slave.c                    | 261 +++++++++++++++++++++++------
>   7 files changed, 609 insertions(+), 156 deletions(-)
> 

-- 
Florian
