Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C183F7C90
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242466AbhHYTLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:11:45 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:47758 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhHYTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:11:44 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 0DC0620B61B5
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 02/13] ravb: Add multi_irq to struct ravb_hw_info
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
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-3-biju.das.jz@bp.renesas.com>
 <e68993e6-add4-dcd1-3ae2-0f4b3f768d3e@omp.ru>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <dd335a74-cadd-1a38-4c7c-36656bade19b@omp.ru>
Date:   Wed, 25 Aug 2021 22:10:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e68993e6-add4-dcd1-3ae2-0f4b3f768d3e@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 9:49 PM, Sergey Shtylyov wrote:
> On 8/25/21 10:01 AM, Biju Das wrote:
> 
>> R-Car Gen3 supports separate interrupts for E-MAC and DMA queues,
>> whereas R-Car Gen2 and RZ/G2L have a single interrupt instead.
>>
>> Add a multi_irq hw feature bit to struct ravb_hw_info to enable
> 
>    So you have 'multi_irq' in the patch subject/description but 'multi_irqs'?

   "in the patch diff", I meant to type.

> Not very consistent...
> 
>> this only for R-Car Gen3.
>>
>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

MBR, Sergey
