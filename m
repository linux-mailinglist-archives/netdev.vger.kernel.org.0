Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A624C24ACFB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 04:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHTCYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 22:24:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9789 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726578AbgHTCYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 22:24:04 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EA9B2982E81175518C99;
        Thu, 20 Aug 2020 10:24:00 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.108) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 10:23:57 +0800
Subject: Re: [PATCH v2] net: stmmac: Fix signedness bug in
 stmmac_probe_config_dt()
To:     Andrew Lunn <andrew@lunn.ch>
References: <20200818143952.50752-1-yuehaibing@huawei.com>
 <20200818151500.51548-1-yuehaibing@huawei.com>
 <20200818170448.GH2330298@lunn.ch>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <ajayg@nvidia.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <07d81dd7-f59a-b7ca-64e9-ac1ab9aa4758@huawei.com>
Date:   Thu, 20 Aug 2020 10:23:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200818170448.GH2330298@lunn.ch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/19 1:04, Andrew Lunn wrote:
> On Tue, Aug 18, 2020 at 11:15:00PM +0800, YueHaibing wrote:
>> The "plat->phy_interface" variable is an enum and in this context GCC
>> will treat it as an unsigned int so the error handling is never
>> triggered.
>>
>> Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Hi YueHaibing
> 
> Please take a look at:
> 
> commit 0c65b2b90d13c1deaee6449304dd367c5d4eb8ae
> Author: Andrew Lunn <andrew@lunn.ch>
> Date:   Mon Nov 4 02:40:33 2019 +0100
> 
>     net: of_get_phy_mode: Change API to solve int/unit warnings
> 
> You probably want to follow this basic idea.
> 

Thanks, will rework following this.

>     Andrew
> 
> .
> 

