Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE694224AC4
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGRKtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:49:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbgGRKtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 06:49:17 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5AE354AD968F3CDAAEA0;
        Sat, 18 Jul 2020 18:49:15 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 18:49:12 +0800
Subject: Re: [PATCH] net: dsa: felix: Make some symbols static
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200718100158.31878-1-wanghai38@huawei.com>
 <20200718104027.ugsdw42jfcpewfl6@skbuf>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <dea3b332-8af7-b8db-6182-702b91ceeae4@huawei.com>
Date:   Sat, 18 Jul 2020 18:49:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200718104027.ugsdw42jfcpewfl6@skbuf>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reminding me, I'll do it.

ÔÚ 2020/7/18 18:40, Vladimir Oltean Ð´µÀ:
> On Sat, Jul 18, 2020 at 06:01:58PM +0800, Wang Hai wrote:
>> Fix sparse build warning:
>>
>> drivers/net/dsa/ocelot/felix_vsc9959.c:560:19: warning:
>>   symbol 'vsc9959_vcap_is2_keys' was not declared. Should it be static?
>> drivers/net/dsa/ocelot/felix_vsc9959.c:640:19: warning:
>>   symbol 'vsc9959_vcap_is2_actions' was not declared. Should it be static?
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
> Please update your tree.
>
> commit 3ab4ceb6e9639e4e42d473e46ae7976c24187876
> Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date:   Sat Jun 20 18:43:36 2020 +0300
>
>      net: dsa: felix: make vcap is2 keys and actions static
>
>      Get rid of some sparse warnings.
>
>      Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
>
>>   drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> index 1dd9e348152d..2067776773f7 100644
>> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> @@ -557,7 +557,7 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
>>   	{ .offset = 0x111,	.name = "drop_green_prio_7", },
>>   };
>>   
>> -struct vcap_field vsc9959_vcap_is2_keys[] = {
>> +static struct vcap_field vsc9959_vcap_is2_keys[] = {
>>   	/* Common: 41 bits */
>>   	[VCAP_IS2_TYPE]				= {  0,   4},
>>   	[VCAP_IS2_HK_FIRST]			= {  4,   1},
>> @@ -637,7 +637,7 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
>>   	[VCAP_IS2_HK_OAM_IS_Y1731]		= {182,   1},
>>   };
>>   
>> -struct vcap_field vsc9959_vcap_is2_actions[] = {
>> +static struct vcap_field vsc9959_vcap_is2_actions[] = {
>>   	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
>>   	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
>>   	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
>> -- 
>> 2.17.1
>>
> Thanks,
> -Vladimir
>
> .
>

