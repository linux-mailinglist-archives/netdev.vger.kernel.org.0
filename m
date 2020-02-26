Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9237D16F519
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgBZBfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:35:53 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729346AbgBZBfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:35:52 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 88FB42257518F9BF549E;
        Wed, 26 Feb 2020 09:35:49 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Feb 2020
 09:35:39 +0800
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <maowenan@huawei.com>
References: <2e9edf1e-5f4f-95d6-4381-6675cded02ac@huawei.com>
 <c6bbb6ef-2ae5-6450-fb01-1fc9265f0483@huawei.com>
 <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
 <20200225.103927.302026645880403716.davem@davemloft.net>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <38005566-2319-9a13-00d9-5a4f88d4bc46@huawei.com>
Date:   Wed, 26 Feb 2020 09:35:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200225.103927.302026645880403716.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/2/26 2:39, David Miller wrote:
> From: yangerkun <yangerkun@huawei.com>
> Date: Tue, 25 Feb 2020 16:57:16 +0800
> 
>> Ping. And anyone can give some advise about this patch?
> 
> You've pinged us 5 or 6 times already.
Hi,

Thanks for your reply!

I am so sorry for the frequently ping which can make some noise. Wont't 
happen again after this...

Thanks,
Kun.

> 
> Obviously that isn't causing anyone to look more deeply into your
> patch.
> 
> You have to accept the fact that using the same exact strategy over
> and over again to get someone to look at this is not working.
> 
> Please.
> 
> Thank you.
> 
> 

