Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F8FFD44
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 04:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKRDPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 22:15:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfKRDPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 22:15:48 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B8A8CBE601950308EB5E;
        Mon, 18 Nov 2019 11:15:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.12) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 11:15:39 +0800
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     David Ahern <dsahern@gmail.com>, <dsahern@kernel.org>,
        <shrijeet@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hujunwei4@huawei.com>, <xuhanbing@huawei.com>
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
 <fde95f03-72ee-b4e9-7f14-b98e3227f0f4@gmail.com>
From:   "wangxiaogang (F)" <wangxiaogang3@huawei.com>
Message-ID: <517baa2a-2c42-7790-e225-02d22c5ed90b@huawei.com>
Date:   Mon, 18 Nov 2019 11:15:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fde95f03-72ee-b4e9-7f14-b98e3227f0f4@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/11/15 21:14, David Ahern wrote:
> On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
>> From: XiaoGang Wang <wangxiaogang3@huawei.com>
>>
>> Recently we get a crash when access illegal address (0xc0),
>> which will occasionally appear when deleting a physical NIC with vrf.
>>
> 
> How long have you been running this test?
> 
> I am wondering if this is fallout from the recent adjacency changes in
> commits 5343da4c1742 through f3b0a18bb6cb.
> 
> 
> 
> 
> 
Thank you so much for the reply, our kernel version is linux 4.19.
this problem happened once in our production environment.

