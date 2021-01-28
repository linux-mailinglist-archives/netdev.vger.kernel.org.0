Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8840F306AA4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhA1Bpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhA1Bok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:44:40 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3D7C0613ED
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:44:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 11so2951128pfu.4
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qKGgI+rDu5HLppW27O7UF+Qh89a7R4zBfq2cBMz2xNM=;
        b=GEy9QYAGvwU2Cwri8TC1Nw27Ie4myZk+TtJABLTtacnar2ATa9tMHSe6iZkK0Q3p+3
         h1m3hFy5uxoHlInOaBAUjXynKsPIccYyotEtE7bKa7Og2mklHVR+DnElE8v8N7cpD5hy
         T9bbFAk59OMa7EekC0Ed+W/2ILD0nszeHgV5/Fvwhaj2xocxV0U6qZr7DWqbA6jYtVsc
         PmrGQbrB8i90sUZx9257aZFRXaDKnSDhkaZZCZlwHY1u6iXW7ygYy97Pv9ANT+mNHGPE
         1Lp7FKOVbSCxzeXHZpPwO9+UzUZqmc8/alxkmIFReUs1kY6C5hr4eMjqc7pFW7/qhiyx
         qgvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qKGgI+rDu5HLppW27O7UF+Qh89a7R4zBfq2cBMz2xNM=;
        b=eLsZin5au1fKyVDBytWA3zSKlHLEbzpISefXOG0UfLNLjBN1iU8svOjcMGmKcOFImf
         hsO25kphlmqI6xAnxBQnZVrgbe/TQasgWRg41lwCJ5EVWf/gU4Wi7n4Y+Oi+xzWpZfur
         hU/ZQD/1hCHAy4w3kdctDcDMXnZjSxB14EvUoWMyXKyXHbwQ4AM4jfR24BH9QFwy/zXY
         MvGWRmoWiwESRcHCO6cwmAc9m4bBx9q9uwRiQrmpj12FTRT3n7FlLt79NYeLTLe7wDa7
         cUDY2U9GqYyo/MPspM9JiLnsmrOgeTJDFCJAPjZ9lTmHEBAZLytiuzADynn0IW00JhCp
         LgCg==
X-Gm-Message-State: AOAM530tkyO65QQDvhqQQdSU3Gl7tgKkSjqlTpGwqzqJbhrECdlwcspM
        dhQkk6E2BdrHcleBue7aPnY=
X-Google-Smtp-Source: ABdhPJx4JwKQEVbubWqUvb1ArsUkQK/hGt0QvDEzu9m5SRHRiq3BjLQgadRXU6kDMVsmwtYm2ROU1g==
X-Received: by 2002:a62:1d46:0:b029:1b7:fe6e:4bb4 with SMTP id d67-20020a621d460000b02901b7fe6e4bb4mr13528335pfd.4.1611798239779;
        Wed, 27 Jan 2021 17:43:59 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p64sm3501311pfb.201.2021.01.27.17.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:43:59 -0800 (PST)
Subject: Re: [PATCH net-next 4/4] Revert "net: ipv4: handle DSA enabled master
 network devices"
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e2b7f311-e422-ed6f-e010-464028f29e74@gmail.com>
Date:   Wed, 27 Jan 2021 17:43:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127010028.1619443-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:00 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit 728c02089a0e3eefb02e9927bfae50490f40e72e.
> 
> Since 2015 DSA has gained more integration with the network stack, we
> can now have the same functionality without explicitly open-coding for
> it:
> - It now opens the DSA master netdevice automatically whenever a user
>   netdevice is opened.
> - The master and switch interfaces are coupled in an upper/lower
>   hierarchy using the netdev adjacency lists.
> 
> In the nfsroot example below, the interface chosen by autoconfig was
> swp3, and every interface except that and the DSA master, eth1, was
> brought down afterwards:
> 
> [    8.714215] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    8.978041] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    9.246134] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    9.486203] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    9.512827] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
> [    9.521047] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow control off
> [    9.530382] device eth1 entered promiscuous mode
> [    9.535452] DSA: tree 0 setup
> [    9.539777] printk: console [netcon0] enabled
> [    9.544504] netconsole: network logging started
> [    9.555047] fsl_enetc 0000:00:00.2 eth1: configuring for fixed/internal link mode
> [    9.562790] fsl_enetc 0000:00:00.2 eth1: Link is Up - 1Gbps/Full - flow control off
> [    9.564661] 8021q: adding VLAN 0 to HW filter on device bond0
> [    9.637681] fsl_enetc 0000:00:00.0 eth0: PHY [0000:00:00.0:02] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
> [    9.655679] fsl_enetc 0000:00:00.0 eth0: configuring for inband/sgmii link mode
> [    9.666611] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
> [    9.676216] 8021q: adding VLAN 0 to HW filter on device swp0
> [    9.682086] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
> [    9.690700] 8021q: adding VLAN 0 to HW filter on device swp1
> [    9.696538] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii link mode
> [    9.705131] 8021q: adding VLAN 0 to HW filter on device swp2
> [    9.710964] mscc_felix 0000:00:00.5 swp3: configuring for inband/qsgmii link mode
> [    9.719548] 8021q: adding VLAN 0 to HW filter on device swp3
> [    9.747811] Sending DHCP requests ..
> [   12.742899] mscc_felix 0000:00:00.5 swp1: Link is Up - 1Gbps/Full - flow control rx/tx
> [   12.743828] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control off
> [   12.747062] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
> [   12.755216] fsl_enetc 0000:00:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   12.766603] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
> [   12.783188] mscc_felix 0000:00:00.5 swp2: Link is Up - 1Gbps/Full - flow control rx/tx
> [   12.785354] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   12.799535] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
> [   13.803141] mscc_felix 0000:00:00.5 swp3: Link is Up - 1Gbps/Full - flow control rx/tx
> [   13.811646] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
> [   15.452018] ., OK
> [   15.470336] IP-Config: Got DHCP answer from 10.0.0.1, my address is 10.0.0.39
> [   15.477887] IP-Config: Complete:
> [   15.481330]      device=swp3, hwaddr=00:04:9f:05:de:0a, ipaddr=10.0.0.39, mask=255.255.255.0, gw=10.0.0.1
> [   15.491846]      host=10.0.0.39, domain=(none), nis-domain=(none)
> [   15.498429]      bootserver=10.0.0.1, rootserver=10.0.0.1, rootpath=
> [   15.498481]      nameserver0=8.8.8.8
> [   15.627542] fsl_enetc 0000:00:00.0 eth0: Link is Down
> [   15.690903] mscc_felix 0000:00:00.5 swp0: Link is Down
> [   15.745216] mscc_felix 0000:00:00.5 swp1: Link is Down
> [   15.800498] mscc_felix 0000:00:00.5 swp2: Link is Down
> [   15.858143] ALSA device list:
> [   15.861420]   No soundcards found.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
