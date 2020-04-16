Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3231AC70A
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394719AbgDPOsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:48:25 -0400
Received: from m12-15.163.com ([220.181.12.15]:41115 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388313AbgDPOsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 10:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=ZQh8z
        vaxY75qRenaS2+9ZBLOwyTNAytPW3k4i9ijrVc=; b=GK1YygrFtatATaJVoO56P
        hng3VrGOv784QI2W6ZXsWS85QE0uNQ82LuIwqO8IUE4yUfg8mKXPfWYtmMvb/Mee
        15U89pwYTYbABP4ezatVClCBPfRAFZ8QOiHhz9s3PQXPDne87fhfmS8Fwyk4u/yA
        5jukIUYgiNye2pbmEhbdps=
Received: from [192.168.0.6] (unknown [125.82.10.107])
        by smtp11 (Coremail) with SMTP id D8CowAAnNupBb5he2_OiDg--.557S2;
        Thu, 16 Apr 2020 22:44:18 +0800 (CST)
Subject: Re: [PATCH v2] net/mlx5: add the missing space character
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>,
        "kw@linux.com" <kw@linux.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200403042659.9167-1-xianfengting221@163.com>
 <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
From:   Hu Haowen <xianfengting221@163.com>
Message-ID: <fae7a094-62e8-d797-a89b-23faf0eb374e@163.com>
Date:   Thu, 16 Apr 2020 22:44:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: D8CowAAnNupBb5he2_OiDg--.557S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4xtFWrXF15ArW3Gw4rXwb_yoW8ZF18pF
        s5Jay7Ca1ktryUXa1xZF48Z3s5Cws5Ka48WF4fK3s5Xr1kt3WfGr15KrW5CFnI9r1fJ3ya
        qFnrZFW7Aw15WaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jKApnUUUUU=
X-Originating-IP: [125.82.10.107]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiQwMIAFc7OSCDLgAAsQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/9 3:42 AM, Saeed Mahameed wrote:
> On Fri, 2020-04-03 at 12:26 +0800, Hu Haowen wrote:
>> Commit 91b56d8462a9 ("net/mlx5: improve some comments") did not add
>> that missing space character and this commit is used to fix it up.
>>
>> Fixes: 91b56d8462a9 ("net/mlx5: improve some comments")
>>
> Please re-spin and submit to net-next once net-next re-opens,
> avoid referencing the above commit since this patch is a stand alone
> and has nothing to do with that patch.. just have a stand alone commit
> message explaining the space fix.

Sorry for my late reply. Because I'm a kernel newbie, I know nothing
about the basic methods and manners in the kernel development. Thanks
a lot for your patience on my mistake, pointing it out and fixing it
up.

Btw, did net-next re-open and did my changes get into the mainline?


>
> i fixed the commit message of the previous patch, so the Fixes tag is
> unnecessary
>
>> Signed-off-by: Hu Haowen <xianfengting221@163.com>
>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
>> index c9c9b479bda5..31bddb48e5c3 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
>> @@ -676,7 +676,7 @@ static void mlx5_fw_tracer_handle_traces(struct
>> work_struct *work)
>>   	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
>>   	start_offset = tracer->buff.consumer_index *
>> TRACER_BLOCK_SIZE_BYTE;
>>   
>> -	/* Copy the block to local buffer to avoid HW override while
>> being processed*/
>> +	/* Copy the block to local buffer to avoid HW override while
>> being processed */
>>   	memcpy(tmp_trace_block, tracer->buff.log_buf + start_offset,
>>   	       TRACER_BLOCK_SIZE_BYTE);
>>   

