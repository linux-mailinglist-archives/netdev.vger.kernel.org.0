Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3208A369CD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfFFCHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:07:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfFFCHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 22:07:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E212CDB862CEC8925A1E;
        Thu,  6 Jun 2019 10:07:14 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 10:07:05 +0800
Subject: Re: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
To:     David Miller <davem@davemloft.net>
CC:     <edumazet@google.com>, <netdev@vger.kernel.org>,
        <mingfangsen@huawei.com>, <zhoukang7@huawei.com>,
        <wangxiaogang3@huawei.com>
References: <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
 <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
 <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
 <20190605.184902.257610327160365131.davem@davemloft.net>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <3792c359-98b3-c312-d87a-204a846a3c11@huawei.com>
Date:   Thu, 6 Jun 2019 10:06:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190605.184902.257610327160365131.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Date: Wed, 5 Jun 2019 18:49:49 +0800
> 
>> small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
>> func is never used in the func, so we can remove it.
>>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> Applied, thanks.
> 

Hi, David Miller.
So sorry for forgetting to sign partner's name who find the cleanup together.
I have sent v2 patch with my partner's signature.

I am so sorry for the mistake.



