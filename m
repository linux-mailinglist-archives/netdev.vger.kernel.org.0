Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7D2AAEA2
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 01:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgKIA60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 19:58:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7156 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728937AbgKIA6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 19:58:25 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CTt085QjVz15SQX;
        Mon,  9 Nov 2020 08:58:16 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 08:58:16 +0800
Subject: Re: [PATCH net-next 10/11] net: hns3: add ethtool priv-flag for EQ/CQ
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
 <1604730681-32559-11-git-send-email-tanhuazhong@huawei.com>
 <20201107094721.648db60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <4ca0514b-23b1-3934-2152-a7ab5d1bfa3e@huawei.com>
Date:   Mon, 9 Nov 2020 08:58:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201107094721.648db60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/8 1:47, Jakub Kicinski wrote:
> On Sat, 7 Nov 2020 14:31:20 +0800 Huazhong Tan wrote:
>> +static void hns3_update_cqe_mode(struct net_device *netdev, bool enable, bool is_tx)
> 
> Wrap this to 80 characters, please.
> 

Will fix it.
Thanks

> .
> 

