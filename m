Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAB3F8F6E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 22:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhHZUEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:04:11 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:58510 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243492AbhHZUEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 16:04:08 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 58A41209AFD4
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com> <YSfkHtWLyVpCoG7C@lunn.ch>
 <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru> <YSfm7zKz5BTNUXDz@lunn.ch>
 <OS0PR01MB5922871679124DA36EAEF31F86C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <0916b09c-e656-fa2a-54d9-ca0c1301a278@omp.ru>
Date:   Thu, 26 Aug 2021 23:03:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922871679124DA36EAEF31F86C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 10:37 PM, Biju Das wrote:
[...]

>>>>>> Do you agree GAC register(gPTP active in Config) bit in AVB-DMAC
>> mode register(CCC) present only in R-Car Gen3?
>>>>>
>>>>>    Yes.
>>>>>    But you feature naming is totally misguiding, nevertheless...
>>>>
>>>> It can still be changed.
>>>
>>>     Thank goodness, yea!
>>
>> We have to live with the first version of this in the git history, but we
>> can add more patches fixing up whatever is broken in the unreviewed code
>> which got merged.
>>
>>>> Just suggest a new name.
>>>
>>>     I'd prolly go with 'gptp' for the gPTP support and 'ccc_gac' for
>>> the gPTP working also in CONFIG mode (CCC.GAC controls this feature).
>>
>> Biju, please could you work on a couple of patches to change the names.
> 
> Yes. Will work on the patches to change the names as suggested. 

   TIA!
   After some more thinking, 'no_gptp' seems to suit better for the 1st case
Might need to invert the checks tho...

[...]

> Cheers,
> Biju

MBR, Sergey
