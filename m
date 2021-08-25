Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734E23F73DD
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbhHYK6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:58:52 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:37006 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbhHYK6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:58:51 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 8A79C235BBFB
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 00/13] Add Factorisation code to support Gigabit
 Ethernet driver
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <prabhakar.mahadev-lad.rj@bp.renesas.com>, <andrew@lunn.ch>,
        <sergei.shtylyov@gmail.com>, <geert+renesas@glider.be>,
        <aford173@gmail.com>, <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <Chris.Paterson2@renesas.com>, <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <162988740967.13655.14613353702366041003.git-patchwork-notify@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <02fc27c2-a816-d60d-6611-162f3b70444a@omp.ru>
Date:   Wed, 25 Aug 2021 13:57:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <162988740967.13655.14613353702366041003.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 25.08.2021 13:30, patchwork-bot+netdevbpf@kernel.org wrote:

 > This series was applied to netdev/net-next.git (refs/heads/master):
 >
 > On Wed, 25 Aug 2021 08:01:41 +0100 you wrote:
    Now this is super fast -- I didn't even have the time to promise 
reviewing... :-/

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
 >    - [net-next,01/13] ravb: Remove the macros NUM_TX_DESC_GEN[23]
 >      https://git.kernel.org/netdev/net-next/c/c81d894226b9
 >    - [net-next,02/13] ravb: Add multi_irq to struct ravb_hw_info
 >      https://git.kernel.org/netdev/net-next/c/6de19fa0e9f7
 >    - [net-next,03/13] ravb: Add no_ptp_cfg_active to struct ravb_hw_info
 >      https://git.kernel.org/netdev/net-next/c/8f27219a6191
 >    - [net-next,04/13] ravb: Add ptp_cfg_active to struct ravb_hw_info
 >      https://git.kernel.org/netdev/net-next/c/a69a3d094de3
 >    - [net-next,05/13] ravb: Factorise ravb_ring_free function
 >      https://git.kernel.org/netdev/net-next/c/bf46b7578404
 >    - [net-next,06/13] ravb: Factorise ravb_ring_format function
 >      https://git.kernel.org/netdev/net-next/c/1ae22c19e75c
 >    - [net-next,07/13] ravb: Factorise ravb_ring_init function
 >      https://git.kernel.org/netdev/net-next/c/7870a41848ab
 >    - [net-next,08/13] ravb: Factorise ravb_rx function
 >      https://git.kernel.org/netdev/net-next/c/d5d95c11365b
 >    - [net-next,09/13] ravb: Factorise ravb_adjust_link function
 >      https://git.kernel.org/netdev/net-next/c/cb21104f2c35
 >    - [net-next,10/13] ravb: Factorise ravb_set_features
 >      https://git.kernel.org/netdev/net-next/c/80f35a0df086
 >    - [net-next,11/13] ravb: Factorise ravb_dmac_init function
 >      https://git.kernel.org/netdev/net-next/c/eb4fd127448b
 >    - [net-next,12/13] ravb: Factorise ravb_emac_init function
 >      https://git.kernel.org/netdev/net-next/c/511d74d9d86c
 >    - [net-next,13/13] ravb: Add reset support
 >      https://git.kernel.org/netdev/net-next/c/0d13a1a464a0

    Will have to do a post-merge review again. And I expect more issues here 
than in a previous patch set...

 > You are awesome, thank you!

MBR, Sergey
