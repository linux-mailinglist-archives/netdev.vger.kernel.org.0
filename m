Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8935A4DC229
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiCQJCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiCQJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:01:59 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB9C1D08D2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:00:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r23so5766419edb.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ioWEXzquDWHeeiOk5WANDAY/UZxcw0vNdnj9B/3BeGo=;
        b=wr0i6WMsc5NWB3lT4XIYdpN/T5oViy8jhC4Qq7OKe5yVPedC/bYw/k+uEswkOh9v0x
         pjvsaTnbVZ7pF/BvztJniNmJGMciCT4MRWLt1FvV8WjCig/o1tWuHfMuRLPtTy/1wqEK
         NXbfqGB1Jht6f7v5IVU+iEUY7qOhDreTXPJbk/nWq1RgVD6Gd2/WccraK1WiWAfNl/q/
         BhBGxR51HX1fzFNOVGrsZ2Y2aB1vqMMnLyYmlBdr42LASGLxkddTIv6Fo5P78Svkxsr2
         9a0PE2Fu9Ed2M/2FhWoUe/ElqJF4ZOY0xUdgpUWSuozSHjFATLQWHPpTzkgc/NL6MWaL
         tt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ioWEXzquDWHeeiOk5WANDAY/UZxcw0vNdnj9B/3BeGo=;
        b=VAlrIFGvZ12PAczsayhDjPVPQ8Gh7eg6+qq8aGD18PejgPZ9Cko52EZT7184LXLT7I
         lCeU5K7KGevcvv3BBAUS/6BriJ8I2Xh4MUpQlPJ02Cwh8JfrItFeUcU8nYpWoEqlZBI2
         cEsT2IwFyr0+9a//1vVp4RkH0yhvfxjYEqNNGq+aEFq6fDXshh5/Z/9kTrux3LmW8bGQ
         hfEelzshnVeNnRTm/+M5iYRetlwbiIFk8qLHSXgbhFqc16PIkpCfOYCE50Nda3n5wexb
         L7tmIidiybyLJd4kKuW9Hex4VFxm0XGIe9cB1xDvcVaYl5cLtS4yDe1uSXfvrZ76NiGw
         6DTw==
X-Gm-Message-State: AOAM532Wpbw80+wgPR5PX2+T2IoIBR4TCgaT9lel4RHh+1MMfluKA5nk
        yDej/ul9vJcKwiR4ARgZ0mDdMQ==
X-Google-Smtp-Source: ABdhPJzKVLUvYg7NMsw+S7EgudGELUf7RQ2oInfgxauvMZhYQL+jFRlVCufjOgBwZCnGL6GaigNkHw==
X-Received: by 2002:a05:6402:4390:b0:416:a29c:660c with SMTP id o16-20020a056402439000b00416a29c660cmr3241202edc.149.1647507639752;
        Thu, 17 Mar 2022 02:00:39 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id g11-20020a170906538b00b006ae38eb0561sm2090779ejo.195.2022.03.17.02.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 02:00:39 -0700 (PDT)
Message-ID: <610eb6cc-4df4-f0fc-462a-b33145334a12@blackwall.org>
Date:   Thu, 17 Mar 2022 11:00:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 00/15] net: bridge: Multiple Spanning Trees
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 17:08, Tobias Waldekranz wrote:
> The bridge has had per-VLAN STP support for a while now, since:
> 
> https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/
> 
> The current implementation has some problems:
> 
> - The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
>   is managed independently. This is awkward from an MSTP (802.1Q-2018,
>   Clause 13.5) point of view, where the model is that multiple VLANs
>   are grouped into MST instances.
> 
>   Because of the way that the standard is written, presumably, this is
>   also reflected in hardware implementations. It is not uncommon for a
>   switch to support the full 4k range of VIDs, but that the pool of
>   MST instances is much smaller. Some examples:
> 
>   Marvell LinkStreet (mv88e6xxx): 4k VLANs, but only 64 MSTIs
>   Marvell Prestera: 4k VLANs, but only 128 MSTIs
>   Microchip SparX-5i: 4k VLANs, but only 128 MSTIs
> 
> - By default, the feature is enabled, and there is no way to disable
>   it. This makes it hard to add offloading in a backwards compatible
>   way, since any underlying switchdevs have no way to refuse the
>   function if the hardware does not support it
> 
> - The port-global STP state has precedence over per-VLAN states. In
>   MSTP, as far as I understand it, all VLANs will use the common
>   spanning tree (CST) by default - through traffic engineering you can
>   then optimize your network to group subsets of VLANs to use
>   different trees (MSTI). To my understanding, the way this is
>   typically managed in silicon is roughly:
> 
>   Incoming packet:
>   .----.----.--------------.----.-------------
>   | DA | SA | 802.1Q VID=X | ET | Payload ...
>   '----'----'--------------'----'-------------
>                         |
>                         '->|\     .----------------------------.
>                            | +--> | VID | Members | ... | MSTI |
>                    PVID -->|/     |-----|---------|-----|------|
>                                   |   1 | 0001001 | ... |    0 |
>                                   |   2 | 0001010 | ... |   10 |
>                                   |   3 | 0001100 | ... |   10 |
>                                   '----------------------------'
>                                                              |
>                                .-----------------------------'
>                                |  .------------------------.
>                                '->| MSTI | Fwding | Lrning |
>                                   |------|--------|--------|
>                                   |    0 | 111110 | 111110 |
>                                   |   10 | 110111 | 110111 |
>                                   '------------------------'
> 
>   What this is trying to show is that the STP state (whether MSTP is
>   used, or ye olde STP) is always accessed via the VLAN table. If STP
>   is running, all MSTI pointers in that table will reference the same
>   index in the STP stable - if MSTP is running, some VLANs may point
>   to other trees (like in this example).
> 
>   The fact that in the Linux bridge, the global state (think: index 0
>   in most hardware implementations) is supposed to override the
>   per-VLAN state, is very awkward to offload. In effect, this means
>   that when the global state changes to blocking, drivers will have to
>   iterate over all MSTIs in use, and alter them all to match. This
>   also means that you have to cache whether the hardware state is
>   currently tracking the global state or the per-VLAN state. In the
>   first case, you also have to cache the per-VLAN state so that you
>   can restore it if the global state transitions back to forwarding.
> 
> This series adds a new mst_enable bridge setting (as suggested by Nik)
> that can only be changed when no VLANs are configured on the
> bridge. Enabling this mode has the following effect:
> 
> - The port-global STP state is used to represent the CST (Common
>   Spanning Tree) (1/15)
> 
> - Ingress STP filtering is deferred until the frame's VLAN has been
>   resolved (1/15)
> 
> - The preexisting per-VLAN states can no longer be controlled directly
>   (1/15). They are instead placed under the MST module's control,
>   which is managed using a new netlink interface (described in 3/15)
> 
> - VLANs can br mapped to MSTIs in an arbitrary M:N fashion, using a
>   new global VLAN option (2/15)
> 
> Switchdev notifications are added so that a driver can track:
> - MST enabled state
> - VID to MSTI mappings
> - MST port states
> 
> An offloading implementation is this provided for mv88e6xxx.
> 
> A proposal for the corresponding iproute2 interface is available here:
> 
> https://github.com/wkz/iproute2/tree/mst
> 

Hi Tobias,
One major missing thing is the selftests for this new feature. Do you
have a plan to upstream them?

Cheers,
 Nik
