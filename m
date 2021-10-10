Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5894282A0
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhJJR0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 13:26:11 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:35058 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhJJR0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 13:26:10 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 111BD20981A5
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
 <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <5b1fda6d-5be2-6d3d-a90e-cf1509a35191@omp.ru>
Date:   Sun, 10 Oct 2021 20:24:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/21 1:56 PM, Biju Das wrote:

[...]
>>>>> Update EMAC configuration mode comment from "PAUSE prohibition"
>>>>> to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>>>> Promiscuous".
>>>>>
>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>>>> ---
>>>>> v1->v2:
>>>>>    * No change
>>>>> V1:
>>>>>    * New patch.
>>>>> ---
>>>>>    drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>>>> index 9a770a05c017..b78aca235c37 100644
>>>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>>>> @@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct
>>>>> net_device
>>>> *ndev)
>>>>>    	/* Receive frame limit set register */
>>>>>    	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
>>>>>
>>>>> -	/* PAUSE prohibition */
>>>>> +	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>>>> +Promiscuous */
>>>>
>>>>      Promiscuous mode, really? Why?!
>>>
>>> This is TOE related,
> 
> I meant the context here is TOE register related. That is what I meant.
> 
>>
>>     The promiscuous mode is supported by _all_ Ethernet controllers, I
>> think.
>>
>>> and is recommendation from BSP team.
>>
>>     On what grounds?
> 
> The reference implementation has this on. Any way it is good catch. 
> I will turn it off and check.
> 
> by looking at the RJ LED's there is not much activity and packet statistics also show not much activity by default.
> 
> How can we check, it is overloading the controller? So that I can compare with and without this setting

   Maybe it doesn't get overloaded that simply, but definitely the promiscuous mode is not the thing
for the normal driver use...

>>> If you think it is wrong.
>>> I can take this out. Please let me know. Currently the board is booting
>> and everything works without issues.
>>
>>     Please do take it out. It'll needlessly overload the controller when
>> there's much traffic on the local network.
> 
> 
> I can see much activity only on RJ45 LED's when I call tcpdump or by setting IP link set eth0 promisc on.
> Otherwise there is no traffic at all.

   Sounds like the kernel initially sets the RX mode with IFF_PROMISC = 0 and thus clear ECMR.PRM but I don't
see where it does this? Could you instrument ravb_set_tx_mode() plz?

> Regards,
> Biju

[...]

MBR, Sergey
