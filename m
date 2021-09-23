Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76434164D7
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbhIWSMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:12:13 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:60420 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242639AbhIWSMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 14:12:12 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru AC19D20A77A9
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 04/18] ravb: Enable aligned_tx and tx_counters for
 RZ/G2L
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-5-biju.das.jz@bp.renesas.com>
 <61e541a7-338c-a9d1-0504-f2f7baf0ffed@omp.ru>
Organization: Open Mobile Platform
Message-ID: <6bb71719-54df-252f-0d55-8c02f84a9624@omp.ru>
Date:   Thu, 23 Sep 2021 21:10:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <61e541a7-338c-a9d1-0504-f2f7baf0ffed@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 9:05 PM, Sergey Shtylyov wrote:

>    Somehow this patch haven't reached my OMP email -- I got it only thru
>  the linux-renesas-soc list... :-/
> 
>> RZ/G2L need 4byte address alignment like R-Car Gen2 and
>> it has tx_counters like R-Car Gen3. This patch enable
>> these features for RZ/G2L.
>>
>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
[...]
>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
>> index 54c4d31a6950..d38fc33a8e93 100644
>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> @@ -2114,6 +2114,8 @@ static const struct ravb_hw_info rgeth_hw_info = {
>>  	.set_feature = ravb_set_features_rgeth,
>>  	.dmac_init = ravb_dmac_init_rgeth,
>>  	.emac_init = ravb_rgeth_emac_init,
>> +	.aligned_tx = 1,
>> +	.tx_counters = 1,
> 
>    Mhm, I don't see a connection between those 2 (other than they're both for RX). And anyway, this prolly

  TX, of/c. :-)

> should be a part of the previous patch...
> 
> [...]

MBR, Sergey
