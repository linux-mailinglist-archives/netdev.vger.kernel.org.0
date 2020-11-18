Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DB2B74B1
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgKRDZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:25:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7696 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKRDZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:25:32 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CbSqV6FDfzkWh3;
        Wed, 18 Nov 2020 11:25:10 +0800 (CST)
Received: from [10.174.177.230] (10.174.177.230) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 11:25:25 +0800
Subject: Re: [PATCH net] atl1e: fix error return code in atl1e_probe()
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <leon@kernel.org>, <hkallweit1@gmail.com>, <tglx@linutronix.de>,
        <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1605581875-36281-1-git-send-email-zhangchangzhong@huawei.com>
 <b7b4dcd3-a536-b72f-6a8b-12354c995ee7@wanadoo.fr>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <e7a0300f-056d-f952-c4d6-609b488b3e9c@huawei.com>
Date:   Wed, 18 Nov 2020 11:25:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b7b4dcd3-a536-b72f-6a8b-12354c995ee7@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.230]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/18 4:38, Marion & Christophe JAILLET wrote:
> 
> Le 17/11/2020 à 03:57, Zhang Changzhong a écrit :
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
> Hi, should it have any importance, the Fixes tag is wrong.
> 
> The issue was already there before 85eb5bc33717 which was just a mechanical update.
> 
> just my 2c
> 
> CJ
> 
Thanks for reminding, the correct Fixes tag should be:

Fixes: a6a5325239c2 ("atl1e: Atheros L1E Gigabit Ethernet driver"
