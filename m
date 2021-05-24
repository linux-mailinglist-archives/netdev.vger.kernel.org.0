Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E038DEC4
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhEXBJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:09:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3916 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhEXBJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 21:09:11 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FpJsH0VrrzBtrf;
        Mon, 24 May 2021 09:04:51 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 09:07:41 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 09:07:40 +0800
Subject: Re: [PATCH net-next] ethernet: ucc_geth: Use kmemdup() rather than
 kmalloc+memcpy
To:     Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
CC:     <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>, <rasmus.villemoes@prevas.dk>,
        <kuba@kernel.org>, <davem@davemloft.net>, <leoyang.li@nxp.com>
References: <20210523075616.14792-1-yuehaibing@huawei.com>
 <20210523152937.Horde.5kC0kzvaP3No5BC63LlZ_A7@messagerie.c-s.fr>
 <YKpmKln1Z/UvZgZQ@lunn.ch>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <cb42d735-e540-2ea4-2cd2-fc3e1bccd526@huawei.com>
Date:   Mon, 24 May 2021 09:07:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YKpmKln1Z/UvZgZQ@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/23 22:26, Andrew Lunn wrote:
> On Sun, May 23, 2021 at 03:29:37PM +0200, Christophe Leroy wrote:
>> YueHaibing <yuehaibing@huawei.com> a écrit :
>>
>>> Issue identified with Coccinelle.
>>>
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>  drivers/net/ethernet/freescale/ucc_geth.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c
>>> b/drivers/net/ethernet/freescale/ucc_geth.c
>>> index e0936510fa34..51206272cc25 100644
>>> --- a/drivers/net/ethernet/freescale/ucc_geth.c
>>> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
>>> @@ -3590,10 +3590,10 @@ static int ucc_geth_probe(struct
>>> platform_device* ofdev)
>>>  	if ((ucc_num < 0) || (ucc_num > 7))
>>>  		return -ENODEV;
>>>
>>> -	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
>>> +	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info),
>>> +			  GFP_KERNEL);
>>
>> Can you keep that as a single line ? The tolerance is 100 chars per line now.
> 
> Networking prefers 80. If it fits a single 80 char line, please use a single line.
> Otherwise please leave it as it is.

Ok, will send v2.
> 
> 	   Andrew
> .
> 
