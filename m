Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233F3131383
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgAFOU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 09:20:58 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbgAFOU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 09:20:58 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0CDA09A57A8BF1DACDFD;
        Mon,  6 Jan 2020 22:20:56 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 6 Jan 2020
 22:20:45 +0800
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     <klassert@kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <jakub.kicinski@netronome.com>,
        <hslester96@gmail.com>, <mst@redhat.com>, <yang.wei9@zte.com.cn>,
        <willy@infradead.org>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
References: <20200106125337.40297-1-yukuai3@huawei.com>
 <20200106131329.GH22387@unicorn.suse.cz>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <77169545-c903-db6b-7a8c-7361caa27dc5@huawei.com>
Date:   Mon, 6 Jan 2020 22:20:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200106131329.GH22387@unicorn.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/6 21:13, Michal Kubecek wrote:
>> @@ -1605,7 +1605,6 @@ vortex_up(struct net_device *dev)
>>   	window_write32(vp, config, 3, Wn3_Config);
>>   
>>   	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
>> -		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
>>   		mdio_read(dev, vp->phys[0], MII_LPA);
>>   		vp->partner_flow_ctrl = ((mii_reg5 & 0x0400) != 0);
>>   		vp->mii.full_duplex = vp->full_duplex;
> Here you removed the read, as you did in previous version of the patch.

Sorry about the stupit mistake.

Yu Kuai

