Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847762AE6C4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgKKDEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:04:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7877 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgKKDEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:04:08 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CW8hC66N8z755W;
        Wed, 11 Nov 2020 11:03:55 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 11:03:54 +0800
Subject: Re: [PATCH V2 net-next 09/11] net: hns3: add support for EQ/CQ mode
 configuration
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
 <1604892159-19990-10-git-send-email-tanhuazhong@huawei.com>
 <20201110172525.250da44c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <4ebdbf23-f624-b1fc-c659-7cb6d54e5c9b@huawei.com>
Date:   Wed, 11 Nov 2020 11:03:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201110172525.250da44c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/11 9:25, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 11:22:37 +0800 Huazhong Tan wrote:
>> For device whose version is above V3(include V3), the GL can
>> select EQ or CQ mode, so adds support for it.
>>
>> In CQ mode, the coalesced timer will restart upon new completion,
>> while in EQ mode, the timer will not restart.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Let's see if I understand - in CQ mode the timer is restarted very time
> new frame gets received/transmitted? IOW for a continuous stream of
> frames it will only generate an interrupt once it reaches max_frames?
> 

Hi, Jakub.

This EQ/CQ is related to the GL(gap limiting, interrupt coalesce based 
on the gap time).

More exactly, the coalesced timer will restart when the first new 
completion occurs. Will fix the commit log.

> I think that if you need such a configuration knob we should add this as
> an option to the official ethtool -c/-C interface, now that we have the
> ability to extend the netlink API.
> 

It seems need more jobs to be did later.

Thanks.

> .
> 

