Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFEE2C6E59
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgK1CDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:03:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8054 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgK1CAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 21:00:16 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjZRw5C3RzhfxG;
        Sat, 28 Nov 2020 09:59:24 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 09:59:40 +0800
Subject: Re: [PATCH net-next 1/7] net: hns3: add support for RX completion
 checksum
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
 <1606466842-57749-2-git-send-email-tanhuazhong@huawei.com>
 <20201127125251.7d25bb1a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <69e4cf6d-2f87-02c2-af0b-b7c7ba45ebd3@huawei.com>
Date:   Sat, 28 Nov 2020 09:59:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201127125251.7d25bb1a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/28 4:52, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 16:47:16 +0800 Huazhong Tan wrote:
>> In some cases (for example ip fragment), hardware will
>> calculate the checksum of whole packet in RX, and setup
>> the HNS3_RXD_L2_CSUM_B flag in the descriptor, so add
>> support to utilize this checksum.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14: warning: incorrect type in assignment (different base types)
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14:    expected restricted __sum16 [usertype] csum
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14:    got unsigned int
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14: warning: invalid assignment: |=
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14:    left side has type restricted __sum16
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14:    right side has type unsigned int
> 

Will fix it, thanks.

> .
> 

