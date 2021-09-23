Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2EF4161D3
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhIWPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:15:18 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:55014 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241885AbhIWPPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:15:17 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 0C876233E046
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 00/18] Add Gigabit Ethernet driver support
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <64375b5e-a43f-1311-9beb-b5fd30252cc2@omp.ru>
Date:   Thu, 23 Sep 2021 18:13:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 6:11 PM, Sergey Shtylyov wrote:
> Hello!
> 
> On 9/23/21 5:07 PM, Biju Das wrote:
> 
>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
>> similar to the R-Car Ethernet AVB IP.
>>
>> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
>> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
>> (DMAC).
>>
>> With a few changes in the driver we can support both IPs.
>>
>> This patch series aims to add Gigabit ethernet driver support to RZ/G2L SoC.
>>
>> Please provide your valuable comments.
> 
>    Note to Dav: I will, in the coming couple days...

   Sorry, I thought I typed DaveM. :-)

[...]

MBR, Sergey
