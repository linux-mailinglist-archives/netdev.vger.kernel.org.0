Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B64161CF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241942AbhIWPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:13:32 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:51212 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241865AbhIWPNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:13:31 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru DE20A20A0312
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 00/18] Add Gigabit Ethernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
Date:   Thu, 23 Sep 2021 18:11:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 9/23/21 5:07 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> With a few changes in the driver we can support both IPs.
> 
> This patch series aims to add Gigabit ethernet driver support to RZ/G2L SoC.
> 
> Please provide your valuable comments.

   Note to Dav: I will, in the coming couple days...

> Ref:-
>  * https://lore.kernel.org/linux-renesas-soc/TYCPR01MB59334319695607A2683C1A5E86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com/T/#t
> 
> 
> Biju Das (18):
>   ravb: Rename "ravb_set_features_rx_csum" function to
>     "ravb_set_features_rcar"
>   ravb: Rename the variables "no_ptp_cfg_active" and "ptp_cfg_active"
>   ravb: Initialize GbEthernet dmac
>   ravb: Enable aligned_tx and tx_counters for RZ/G2L
>   ravb: Exclude gPTP feature support for RZ/G2L
>   ravb: Add multi_tsrq to struct ravb_hw_info
>   ravb: Add magic_pkt to struct ravb_hw_info
>   ravb: Add mii_rgmii_selection to struct ravb_hw_info
>   ravb: Add half_duplex to struct ravb_hw_info
>   ravb: Initialize GbEthernet E-MAC
>   ravb: Add rx_2k_buffers to struct ravb_hw_info
>   ravb: Add timestamp to struct ravb_hw_info
>   ravb: Add rx_ring_free function support for GbEthernet
>   ravb: Add rx_ring_format function for GbEthernet
>   ravb: Add rx_alloc helper function for GbEthernet
>   ravb: Add Packet receive function for Gigabit Ethernet
>   ravb: Add carrier_counters to struct ravb_hw_info
>   ravb: Add set_feature support for RZ/G2L
> 
>  drivers/net/ethernet/renesas/ravb.h      |  91 +++-
>  drivers/net/ethernet/renesas/ravb_main.c | 631 ++++++++++++++++++++---
>  2 files changed, 630 insertions(+), 92 deletions(-)

   There's a lot of new code....

MBR, Sergey
