Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44A3F1C3B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbhHSPIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:08:47 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:46174 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbhHSPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:08:46 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 1CEE920FAAD5
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v3 0/9] Add Gigabit Ethernet driver support
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <sergei.shtylyov@gmail.com>, <geert+renesas@glider.be>,
        <s.shtylyov@omprussia.ru>, <aford173@gmail.com>, <andrew@lunn.ch>,
        <ashiduka@fujitsu.com>, <yoshihiro.shimoda.uh@renesas.com>,
        <yangyingliang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <Chris.Paterson2@renesas.com>,
        <biju.das@bp.renesas.com>,
        <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
 <162937140695.9830.1977811163674506658.git-patchwork-notify@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9b060154-aed4-1e11-68ac-6468e5f4f136@omp.ru>
Date:   Thu, 19 Aug 2021 18:08:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <162937140695.9830.1977811163674506658.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 2:10 PM, patchwork-bot+netdevbpf@kernel.org wrote:

[...]
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Wed, 18 Aug 2021 20:07:51 +0100 you wrote:
>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
>> similar to the R-Car Ethernet AVB IP.
>>
>> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
>> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
>> (DMAC).
>>
>> [...]
> 
> Here is the summary with links:
>   - [net-next,v3,1/9] ravb: Use unsigned int for num_tx_desc variable in struct ravb_private
>     https://git.kernel.org/netdev/net-next/c/cb537b241725
>   - [net-next,v3,2/9] ravb: Add struct ravb_hw_info to driver data
>     https://git.kernel.org/netdev/net-next/c/ebb091461a9e
>   - [net-next,v3,3/9] ravb: Add aligned_tx to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/68ca3c923213
>   - [net-next,v3,4/9] ravb: Add max_rx_len to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/cb01c672c2a7
>   - [net-next,v3,5/9] ravb: Add stats_len to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/25154301fc2b
>   - [net-next,v3,6/9] ravb: Add gstrings_stats and gstrings_size to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/896a818e0e1d
>   - [net-next,v3,7/9] ravb: Add net_features and net_hw_features to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/8912ed25daf6
>   - [net-next,v3,8/9] ravb: Add internal delay hw feature to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/8bc4caa0abaf
>   - [net-next,v3,9/9] ravb: Add tx_counters to struct ravb_hw_info
>     https://git.kernel.org/netdev/net-next/c/0b81d6731167
> 
> You are awesome, thank you!

   Are we in such a haste? I was just going to review these patches today...

MBR, Sergey
