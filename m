Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E1642439B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhJFRCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:02:05 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:46292 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhJFRCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 13:02:05 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 0102120A2A5B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
 <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <4eac039d-1a4e-fdfa-37e7-8a774a88c69a@omp.ru>
Date:   Wed, 6 Oct 2021 20:00:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 7:41 PM, Sergey Shtylyov wrote:

>> RZ/G2L E-MAC supports carrier counters.
>> Add a carrier_counter hw feature bit to struct ravb_hw_info
>> to add this feature only for RZ/G2L.
>>
>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> [...]
> 
>> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
>> index 8c7b2569c7dd..899e16c5eb1a 100644
>> --- a/drivers/net/ethernet/renesas/ravb.h
>> +++ b/drivers/net/ethernet/renesas/ravb.h
>> [...]
>> @@ -1061,6 +1065,7 @@ struct ravb_hw_info {
>>  	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
>>  	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
>>  	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
>> +	unsigned carrier_counters:1;	/* E-MAC has carrier counters */

   I thought I'd typed here that this field should be declared next to the 'tx_counters' field. :-)
 
[...]

MBR, Sergey
