Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BB84847
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfHGIzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:55:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727733AbfHGIzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 04:55:24 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0F55E792C2D0D19DC382;
        Wed,  7 Aug 2019 16:55:23 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 7 Aug 2019
 16:55:13 +0800
Subject: Re: [PATCH] net: stmmac: Fix the miscalculation of mapping from rxq
 to dma channel
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
References: <1565165849-16246-1-git-send-email-zhangshaokun@hisilicon.com>
 <BN8PR12MB3266D248C58DB7ABE6238A49D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
CC:     yuqi jin <jinyuqi@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <5baf1da1-31b6-3707-684a-8983b6ac2252@hisilicon.com>
Date:   Wed, 7 Aug 2019 16:55:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266D248C58DB7ABE6238A49D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

Thanks your quick reply.

On 2019/8/7 16:24, Jose Abreu wrote:
> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Date: Aug/07/2019, 09:17:29 (UTC+00:00)
> 
>> From: yuqi jin <jinyuqi@huawei.com>
>>
>> XGMAC_MTL_RXQ_DMA_MAP1 will be configured if the number of queues is
>> greater than 3, but local variable chan will shift left more than 32-bits.
>> Let's fix this issue.
> 
> This was already fixed in -net. Please see [1]
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/co
> mmit/drivers/net/ethernet/stmicro/stmmac?id=e8df7e8c233a18d2704e37ecff475
> 83b494789d3
> 
> ---
> Thanks,
> Jose Miguel Abreu
> 
> 

