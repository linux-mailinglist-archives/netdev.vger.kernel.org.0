Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B6441FDA6
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhJBSUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:20:55 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:34584 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbhJBSUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:20:54 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B05912084EBC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-3-biju.das.jz@bp.renesas.com>
 <232c6ad6-c35b-76c0-2800-e05ca2631048@omp.ru>
 <OS0PR01MB59225BB8DF5AE4811158563786AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <88414688-cf04-0dc9-4583-b860a04791c2@omp.ru>
Date:   Sat, 2 Oct 2021 21:19:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59225BB8DF5AE4811158563786AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   Damn, DaveM continues ignoring my review efforts... :-( will finish reviewing the series anyway.

On 10/2/21 10:53 AM, Biju Das wrote:

>> Subject: Re: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
>> "ptp_cfg_active" variables
>>
>> On 10/1/21 6:06 PM, Biju Das wrote:
>>
>>> Rename the variable "no_ptp_cfg_active" with "gptp" and
>>
>>    This shouldn't be a rename but the extension of the meaning instead...
> 
> This is the original ptp support for both R-Car Gen3 and R-Car Gen2 without config in active mode. Later we added feature support active in config mode for R-Car Gen3 by patch[1].
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/ethernet/renesas/ravb_main.c?h=v5.15-rc3&id=f5d7837f96e53a8c9b6c49e1bc95cf0ae88b99e8

   And? Do you think I don't remember the driver development history? :-)

>>> "ptp_cfg_active" with "ccc_gac" to match the HW features.
>>>
>>> There is no functional change.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> RFc->v1:
>>>  * Renamed the variable "no_ptp_cfg_active" with "gptp" and
>>>    "ptp_cfg_active" with "ccc_gac
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  4 ++--
>>>  drivers/net/ethernet/renesas/ravb_main.c | 26
>>> ++++++++++++------------
>>>  2 files changed, 15 insertions(+), 15 deletions(-)
>>
>> [...]
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 8f2358caef34..dc7654abfe55 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -1274,7 +1274,7 @@ static int ravb_set_ringparam(struct net_device
>> *ndev,
>>>  	if (netif_running(ndev)) {
>>>  		netif_device_detach(ndev);
>>>  		/* Stop PTP Clock driver */
>>> -		if (info->no_ptp_cfg_active)
>>> +		if (info->gptp)
>>
>>    Where have you lost !info->ccc_gac?
> 
>   As per patch[1], the check is for R-Car Gen2. Why do you need additional check
> as per the current driver?

   Because the driver now supports not only gen2, but also gen3, and RZ/G2L, finally.

> I see below you are proposing to enable both "gptp" and "ccc_gac" for R-Car Gen3,

   Yes, this is how the hardware evolved. gPTP hardware can (optionally) be active outside
the config mode, otherwise there's no difference b/w gen2 and gen3.

> According to me it is a feature improvement for R-Car Gen3 in which, you can have
> 
> 1) gPTP support active in config mode
> 2) gPTP support not active in config mode

   Right.

> But the existing driver code just support "gPTP support active in config mode" for R-Car Gen3.

   And?

> Do you want me to do feature improvement as well, as part of Gbethernet support?

   I thought we agreed on this patch in the previous iteration, To be more clear, by asking
to remove the "double negation", I meant using:

	if (info->gptp && !info->ccc_gac)

versus your:

	if (!info->no_gptp && !info->ccc_gac)

> Please let me know your thoughts.
> 
> The same comments applies to all the comments you have mentioned below.
> 
> Regards,
> Biju

[...]

MBR, Sergey
