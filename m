Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BAD25E52F
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 05:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgIEDAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 23:00:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbgIEDAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 23:00:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 895C5346DECBEDDD2514;
        Sat,  5 Sep 2020 11:00:32 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 5 Sep 2020
 11:00:29 +0800
Subject: Re: [PATCH net-next] net/packet: Remove unused macro BLOCK_PRIV
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John Ogness" <john.ogness@linutronix.de>,
        Mao Wenan <maowenan@huawei.com>, <jrosen@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin King <colin.king@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        "Network Development" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200904130608.19869-1-wanghai38@huawei.com>
 <CA+FuTSfMO4YPGp88HYRPWwRUCg79SVyYicOowCH9oJkKPtmdLA@mail.gmail.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <df2a5c42-3b06-1801-9bf1-8f304d839620@huawei.com>
Date:   Sat, 5 Sep 2020 11:00:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfMO4YPGp88HYRPWwRUCg79SVyYicOowCH9oJkKPtmdLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/9/4 21:26, Willem de Bruijn 写道:
> On Fri, Sep 4, 2020 at 3:09 PM Wang Hai <wanghai38@huawei.com> wrote:
>> BPDU_TYPE_TCN is never used after it was introduced.
>> So better to remove it.
> This comment does not cover the patch contents. Otherwise the patch
> looks good to me.
Thanks for your review, I will revise this comment.
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   net/packet/af_packet.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index da8254e680f9..c430672c6a67 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -177,7 +177,6 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
>>   #define BLOCK_LEN(x)           ((x)->hdr.bh1.blk_len)
>>   #define BLOCK_SNUM(x)          ((x)->hdr.bh1.seq_num)
>>   #define BLOCK_O2PRIV(x)        ((x)->offset_to_priv)
>> -#define BLOCK_PRIV(x)          ((void *)((char *)(x) + BLOCK_O2PRIV(x)))
>>
>>   struct packet_sock;
>>   static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>> --
>> 2.17.1
>>
> .
>

