Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1148B27E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343751AbiAKQoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:44:44 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:60212 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240793AbiAKQoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:44:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1agp6U_1641919481;
Received: from 30.39.146.113(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1agp6U_1641919481)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jan 2022 00:44:42 +0800
Message-ID: <eecadb47-92f3-c4cc-64d2-3954474e3c5f@linux.alibaba.com>
Date:   Wed, 12 Jan 2022 00:44:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net 3/3] net/smc: Resolve the race between SMC-R link
 access and clear
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
 <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
 <fa057e34-7626-2b19-2c2e-acd4999e7fe5@linux.alibaba.com>
 <b1882268-d8bb-eee9-8238-e30962928034@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <b1882268-d8bb-eee9-8238-e30962928034@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/12 00:02, Karsten Graul wrote:
> On 11/01/2022 16:49, Wen Gu wrote:
>>
>> OK, I will correct this as well.
>>
>> And similarly I want to move smc_ibdev_cnt_dec() and put_device() to
>> __smcr_link_clear() as well to ensure that put link related resources
>> only when link is actually cleared. What do you think?
> 
> I think that's a good idea, yes.

Thank you.

Not in a hurry, just want to ask should I send a v2 with these changes
or continue to wait for subsequent review of v1?

Thanks,
Wen Gu
