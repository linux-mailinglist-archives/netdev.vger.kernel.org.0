Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267E73DFE65
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhHDJwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:52:18 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:51004 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhHDJwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:52:17 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 8E4B520E8374
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
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
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
 <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <de0a9df3-11ac-0630-8933-922012b39264@omp.ru>
Date:   Wed, 4 Aug 2021 12:51:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2021 8:13, Biju Das wrote:
> Hi Sergei,
> 
> Thanks for the feedback
> 
>> Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature
>> to struct ravb_hw_info
>>
>> On 8/2/21 1:26 PM, Biju Das wrote:
>>
>>> R-Car Gen3 supports TX and RX clock internal delay modes, whereas
>>> R-Car
>>> Gen2 and RZ/G2L do not support it.
>>> Add an internal_delay hw feature bit to struct ravb_hw_info to enable
>>> this only for R-Car Gen3.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> v2:
>>>   * Incorporated Andrew and Sergei's review comments for making it
>> smaller patch
>>>     and provided detailed description.
>>> ---
>>>   drivers/net/ethernet/renesas/ravb.h      | 3 +++
>>>   drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
>>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index 3df813b2e253..0d640dbe1eed 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -998,6 +998,9 @@ struct ravb_hw_info {
>>>   	int num_tx_desc;
>>>   	int stats_len;
>>>   	size_t skb_sz;
>>> +
>>> +	/* hardware features */
>>> +	unsigned internal_delay:1;	/* RAVB has internal delays */
>>
>>     Oops, missed it initially:
>>     RAVB? That's not a device name, according to the manuals. It seems to
>> be the driver's name.
> 
> OK. will change it to AVB-DMAC has internal delays.

    Please don't -- E-MAC has them, not AVB-DMAC.

> Cheers,
> Biju

NBR, Sergei
