Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7681D56388
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 09:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfFZHoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 03:44:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19079 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfFZHoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 03:44:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 50A90E953B7628D69444;
        Wed, 26 Jun 2019 15:44:14 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Jun 2019
 15:44:05 +0800
Subject: Re: [PATCH net-next 00/11] net: hns3: some code optimizations &
 bugfixes
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
 <20190622.095323.1495992426494142587.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <573582a3-23fc-8591-f71b-af977ed6fd0e@huawei.com>
Date:   Wed, 26 Jun 2019 15:44:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190622.095323.1495992426494142587.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/22 21:53, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Thu, 20 Jun 2019 16:52:34 +0800
> 
>> This patch-set includes code optimizations and bugfixes for
>> the HNS3 ethernet controller driver.
>>
>> [patch 1/11] fixes a selftest issue when doing autoneg.
>>
>> [patch 2/11 - 3-11] adds two code optimizations about VLAN issue.
>>
>> [patch 4/11] restores the MAC autoneg state after reset.
>>
>> [patch 5/11 - 8/11] adds some code optimizations and bugfixes about
>> HW errors handling.
>>
>> [patch 9/11 - 11/11] fixes some issues related to driver loading and
>> unloading.
> 
> Series applied, thanks.
> 

Hi, david, has this patchset merged into net-next, why I cannot see it 
after pulling net-next? Or is there some problem about this patchset I 
have missed?

> .
> 

