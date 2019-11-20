Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D341103123
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKTB2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:28:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:50442 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727262AbfKTB2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:28:18 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C48BDC9B78963A98D675;
        Wed, 20 Nov 2019 09:28:01 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 20 Nov 2019
 09:27:59 +0800
Subject: Re: [PATCH net] net: dsa: ocelot: add dependency for
 NET_DSA_MSCC_FELIX
To:     David Miller <davem@davemloft.net>
CC:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20191119025128.7393-1-maowenan@huawei.com>
 <20191119.154125.1492881397881625788.davem@davemloft.net>
From:   maowenan <maowenan@huawei.com>
Message-ID: <b541e6bb-020f-c2c4-8921-9f4d140f3bcb@huawei.com>
Date:   Wed, 20 Nov 2019 09:27:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191119.154125.1492881397881625788.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2019/11/20 7:41, David Miller Ð´µÀ:
> From: Mao Wenan <maowenan@huawei.com>
> Date: Tue, 19 Nov 2019 10:51:28 +0800
> 
>> If CONFIG_NET_DSA_MSCC_FELIX=y, and CONFIG_NET_VENDOR_MICROSEMI=n,
>> below errors can be found:
>> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_del':
>> felix.c:(.text+0x26e): undefined reference to `ocelot_vlan_del'
>> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_add':
>> felix.c:(.text+0x352): undefined reference to `ocelot_vlan_add'
>>
>> and warning as below:
>> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
>> Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
>> NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
>> Selected by [y]:
>> NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
>> && NET_DSA [=y] && PCI [=y]
>>
>> This patch add dependency NET_VENDOR_MICROSEMI for NET_DSA_MSCC_FELIX.
>>
>> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> This seems more like a "select" situation, why in the world should the
> user be required to know about NET_VENDOR_MISCROSEMI at all for this
> driver?
thanks.
I will change to 'select' it and send v2.
> 
> And NET_VENDOR_MICROSEMI does _NOT_ enable any code at all, you have
> to enable the individual drivers guarded by NET_VENDOR_MICROSEMI in order
> to resolve the symbols necessary for ocelot.
> 
> I'm not applying this, it isn't correct.
> 
> Thank you.
> 
> .
> 

