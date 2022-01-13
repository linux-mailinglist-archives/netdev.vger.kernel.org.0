Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1119A48DA8A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 16:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiAMPPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 10:15:15 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47343 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbiAMPPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 10:15:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1kE-D2_1642086911;
Received: from 30.225.24.75(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1kE-D2_1642086911)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 23:15:12 +0800
Message-ID: <5c506c95-1f18-9f6b-efd1-50e0f6d097da@linux.alibaba.com>
Date:   Thu, 13 Jan 2022 23:15:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
 <ac977743-9696-9723-5682-97ebbcca6828@linux.ibm.com>
 <719f264e-a70d-7bed-0873-ffbba8381841@linux.alibaba.com>
 <5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/12 5:38 pm, Karsten Graul wrote:
> On 11/01/2022 17:34, Wen Gu wrote:
>> Thanks for your reply.
>>
>> On 2022/1/11 6:03 pm, Karsten Graul wrote:
>>> On 10/01/2022 10:38, Wen Gu wrote:
>>>> We encountered a crash in smc_setsockopt() and it is caused by
>>>> accessing smc->clcsock after clcsock was released.
>>>>
>>>
>>> In the switch() the function smc_switch_to_fallback() might be called which also
>>> accesses smc->clcsock without further checking. This should also be protected then?
>>> Also from all callers of smc_switch_to_fallback() ?
>>>
> 
> Lets go with your initial patch (improved to address the access in smc_switch_to_fallback())
> for now because it solves your current problem.
> 

Since the upcoming v2 patch added clcsock check in smc_switch_to_fallback(),
the original subject is inappropriate.

So I sent a new patch named 'net/smc: Transitional solution for clcsock race issue'
instead of a v2.

Thanks,
Wen Gu
