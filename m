Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C8E218E75
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgGHRlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:41:51 -0400
Received: from out0-158.mail.aliyun.com ([140.205.0.158]:41820 "EHLO
        out0-158.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHRlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594230109; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=yl9JDLphDwcddxjlNKoi37QdiFk2Nvp/0iyEICPtlZw=;
        b=g2zl0DaClyBjB1E238EsOnCB4KGGTRGectDj2uaO7MogOlkpFnzOb2tU75MMCSsx4RsZLcBLUJkNXdoGyBU0BPH7NhM2L7SKNeJyc9YS/C+OFJTB23u21B8ZAY/bSuFqNEv3FFQR32YmZAuDj83nw/CR4cN6GEkozX4A8Y/7JJ8=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03312;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-JpxBb_1594230107;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-JpxBb_1594230107)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 01:41:48 +0800
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
 <e71cfd58-f639-24a7-ffb8-ebe3d74422a2@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <68b95143-53ee-b56d-3452-50fca82e8cd9@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 01:41:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e71cfd58-f639-24a7-ffb8-ebe3d74422a2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 9:55 AM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 9:38 AM, YU, Xiangning wrote:
>> Unlike other irq APIs, irq_work_queue_on is not exported. It makes sense to
>> export it so other modules could use it.
>>
>> Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
>> ---
>>  kernel/irq_work.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
>> index eca83965b631..e0ed16db660c 100644
>> --- a/kernel/irq_work.c
>> +++ b/kernel/irq_work.c
>> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>>  	return true;
>>  #endif /* CONFIG_SMP */
>>  }
>> -
>> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
>>  
>>  bool irq_work_needs_cpu(void)
>>  {
>>
> 
> 
> ??? You no longer need this change, right ???
> 

Hi Eric,

I didn't find any change about this function from upstream repo. Just double checked, if we don't include this change and ltb is compiled as a module, we will get an undefined symbol. Did I miss anything?

Thanks,
- Xiangning
