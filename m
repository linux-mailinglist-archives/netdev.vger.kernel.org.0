Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6488137AFF
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 02:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgAKB5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 20:57:04 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56626 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727943AbgAKB5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 20:57:04 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BBB6A48F3719B66B1AB3;
        Sat, 11 Jan 2020 09:57:02 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 11 Jan 2020
 09:56:59 +0800
Subject: Re: [PATCH net-next] sfc: remove duplicated include from ef10.c
To:     Edward Cree <ecree@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20200110013517.37685-1-yuehaibing@huawei.com>
 <422eff3d-05ea-d967-ff1b-448b6dc9dcb5@solarflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <db6af9a7-3229-edf0-d650-af4287e32661@huawei.com>
Date:   Sat, 11 Jan 2020 09:56:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <422eff3d-05ea-d967-ff1b-448b6dc9dcb5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/10 19:57, Edward Cree wrote:
> On 10/01/2020 01:35, YueHaibing wrote:
>> Remove duplicated include.
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Edward Cree <ecree@solarflare.com>
> but you seem to have come up with a strange CC list, full of bpf maintainers
>  rather than sfc driver maintainers; check your submission scripts?  (AFAIK
>  the MAINTAINERS file has the right things in.)

Thanks, I will check this.
> 
> -Ed
>> ---
>>  drivers/net/ethernet/sfc/ef10.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
>> index dc037dd927f8..fa460831af7d 100644
>> --- a/drivers/net/ethernet/sfc/ef10.c
>> +++ b/drivers/net/ethernet/sfc/ef10.c
>> @@ -16,7 +16,6 @@
>>  #include "workarounds.h"
>>  #include "selftest.h"
>>  #include "ef10_sriov.h"
>> -#include "rx_common.h"
>>  #include <linux/in.h>
>>  #include <linux/jhash.h>
>>  #include <linux/wait.h>
>>
>>
>>
> 
> 
> .
> 

