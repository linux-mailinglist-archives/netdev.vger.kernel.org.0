Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C34C9140
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 18:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiCARPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbiCARPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:15:04 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8003C55BEC
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 09:14:23 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q11so13967452pln.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 09:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8pvR7fUjo4Is6/Cb3MD2W3icUriTB3Mu3szxa0yANuU=;
        b=iFWxLFlcY62qYauPEdLelyqx8YSPv5XbGGJw4PiU/D1ZeOofyQkcba0JJL6MpIY4hs
         zP8Nc9MgbWwG+YbU7ShQ9epNKcRg0k1TsIZ7hJ6KruP+1IPvhCF+0kdSsJCGpdx7h+Y5
         3Th68ZLi7XpS3VEUTqJQTavu9Tog9GSC927y0d6rV7AWj8cEP/IZ9G9wI5vnYeLyIZ0s
         L32uW1lc9DiV/irB7gaVTHdZEGnbtwBXEbHM12055iAUlS22aLuYBrGHnXQRXRAlH8a8
         lm2FmZSajKOHN+QRxkAL5NlUZ3DcH/Gz2Rppp/VxV1Zvn3Lb/9io27kr/e+GEGnwatyU
         pBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8pvR7fUjo4Is6/Cb3MD2W3icUriTB3Mu3szxa0yANuU=;
        b=B1XwGGV58gnJ06E2zDJiz+cFsPNAzpRen8Y2rV6zLBwN80FahpsTv7jEjUk9Oy6FMS
         KLG4W+l8fWea8YMDSb5sVDr66BdelTOhKvU51KYVJGgTJQ3sMW7v28u0fSaggDgMayFt
         axLHbYspXO+eSQ2EvBGU8cj9UP6w/9Yl/CluDiRCadUA1/uYLFV0exvdJkucvFPKt0kB
         H4r5cpchfpAhddwMRreRQdsaSH2FYOnh34LsWCir/SLRKxfE7dF1HHC1O3CoJ3xELQzP
         H5T4aQWeMNsHO4MRCHXSoan1MyC2f9VU0Bz0jBie4vEhSqsKfUhZnw8bfpV0XUYD8iUd
         9LFw==
X-Gm-Message-State: AOAM532WfNP5IgDmBw5C8uVehgXzm9yD8JgVF7PuFrcpObaE7lNCDs0i
        YmB2EYBZy/3coZYgFDIuAco=
X-Google-Smtp-Source: ABdhPJwVxEz2nr/kIQ/JUUBwHw9O3E+GvBp2x6RVNi2bHapWKL5zhBebzHW+jF5cM/YSG6udR5GeYw==
X-Received: by 2002:a17:902:aa8e:b0:14f:fa5e:fe80 with SMTP id d14-20020a170902aa8e00b0014ffa5efe80mr26829127plr.84.1646154862837;
        Tue, 01 Mar 2022 09:14:22 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o11-20020a056a0015cb00b004ce19332265sm18189408pfu.34.2022.03.01.09.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:14:22 -0800 (PST)
Message-ID: <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
Date:   Tue, 1 Mar 2022 09:14:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 0/3] bridge: dsa: switchdev: mv88e6xxx: Implement
 local_receive bridge flag
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
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



On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
> Greetings,
> 
> This series implements a new bridge flag 'local_receive' and HW
> offloading for Marvell mv88e6xxx.
> 
> When using a non-VLAN filtering bridge we want to be able to limit
> traffic to the CPU port to lessen the CPU load. This is specially
> important when we have disabled learning on user ports.
> 
> A sample configuration could be something like this:
> 
>         br0
>        /   \
>     swp0   swp1
> 
> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
> ip link set swp0 master br0
> ip link set swp1 master br0
> ip link set swp0 type bridge_slave learning off
> ip link set swp1 type bridge_slave learning off
> ip link set swp0 up
> ip link set swp1 up
> ip link set br0 type bridge local_receive 0
> ip link set br0 up
> 
> The first part of the series implements the flag for the SW bridge
> and the second part the DSA infrastructure. The last part implements
> offloading of this flag to HW for mv88e6xxx, which uses the
> port vlan table to restrict the ingress from user ports
> to the CPU port when this flag is cleared.

Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
right now, but Vladimir recently picked up what I had attempted before 
which was to allow removing the CPU port (via the bridge master device) 
from a specific group of VLANs to achieve that isolation.

> 
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>

I don't believe this tag has much value since it was presumably carried 
over from an internal review. Might be worth adding it publicly now, though.

> 
> Regards,
> Mattias Forsblad (3):
>    net: bridge: Implement bridge flag local_receive
>    dsa: Handle the local_receive flag in the DSA layer.
>    mv88e6xxx: Offload the local_receive flag
> 
>   drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
>   include/linux/if_bridge.h        |  6 +++++
>   include/net/dsa.h                |  6 +++++
>   include/net/switchdev.h          |  2 ++
>   include/uapi/linux/if_bridge.h   |  1 +
>   include/uapi/linux/if_link.h     |  1 +
>   net/bridge/br.c                  | 18 +++++++++++++
>   net/bridge/br_device.c           |  1 +
>   net/bridge/br_input.c            |  3 +++
>   net/bridge/br_ioctl.c            |  1 +
>   net/bridge/br_netlink.c          | 14 +++++++++-
>   net/bridge/br_private.h          |  2 ++
>   net/bridge/br_sysfs_br.c         | 23 ++++++++++++++++
>   net/bridge/br_vlan.c             |  8 ++++++
>   net/dsa/dsa_priv.h               |  1 +
>   net/dsa/slave.c                  | 16 ++++++++++++
>   16 files changed, 145 insertions(+), 3 deletions(-)
> 

-- 
Florian
