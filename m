Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43232AE58D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgKKBPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:15:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7203 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbgKKBPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:15:46 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CW6H82fw2zkY6p;
        Wed, 11 Nov 2020 09:15:32 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 09:15:34 +0800
Subject: Re: [PATCH V2 net-next 01/11] net: hns3: add support for configuring
 interrupt quantity limiting
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
 <1604892159-19990-2-git-send-email-tanhuazhong@huawei.com>
 <20201110171312.66a031a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <ddaeb293-68a3-a831-68c7-dd54ba39ef7c@huawei.com>
Date:   Wed, 11 Nov 2020 09:15:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201110171312.66a031a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/11 9:13, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 11:22:29 +0800 Huazhong Tan wrote:
>> +	if (rx_vector->tx_group.coal.ql_enable)
>                         ^^^^^^^^
> 
> Is this supposed to be rx_group, not tx?
> 

yes, will fix it.
thanks.

>> +		hns3_set_vector_coalesce_rx_ql(rx_vector,
>> +					       rx_vector->rx_group.coal.int_ql);
> 
> .
> 

