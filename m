Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFE1AFF5F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 03:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDTBFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 21:05:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725949AbgDTBFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 21:05:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 131943B4B51D164DD656;
        Mon, 20 Apr 2020 09:04:58 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 09:04:48 +0800
Subject: Re: [PATCH net-next 01/10] net: hns3: split out
 hclge_fd_check_ether_tuple()
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <shenjian15@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
 <1587192429-11463-2-git-send-email-tanhuazhong@huawei.com>
 <20200418.201746.783676213458110248.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <d6cdcc43-94a9-318c-fec1-b26b0eb70015@huawei.com>
Date:   Mon, 20 Apr 2020 09:04:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200418.201746.783676213458110248.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/4/19 11:17, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Sat, 18 Apr 2020 14:47:00 +0800
> 
>> +static int hclge_fd_check_spec(struct hclge_dev *hdev,
>> +			       struct ethtool_rx_flow_spec *fs,
>> +			       u32 *unused_tuple)
>> +{
>> +	int ret = 0;
> 
> There is no code path that uses 'ret' without it first being
> assigned.  If I let this code in, then someone is going to
> submit a fixup patch removing the initialization.
> 

Yes, will modify it.
Thanks.

> .
> 

