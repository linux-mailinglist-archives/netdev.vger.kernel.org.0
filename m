Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A7495C8F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 10:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379675AbiAUJLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 04:11:24 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45112 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234763AbiAUJLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 04:11:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2R2RdZ_1642756280;
Received: from 30.225.24.42(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V2R2RdZ_1642756280)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 17:11:21 +0800
Message-ID: <17bc5600-efbf-17c9-571c-ab9e2ff21ffd@linux.alibaba.com>
Date:   Fri, 21 Jan 2022 17:11:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Transitional solution for clcsock race issue
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1642086177-130611-1-git-send-email-guwen@linux.alibaba.com>
 <ad5c1c9b-5d9e-cd0f-88c7-4420bc9ed0e5@linux.alibaba.com>
 <d001482c-669d-de3e-34c3-324793c48442@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <d001482c-669d-de3e-34c3-324793c48442@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/1/21 4:46 pm, Karsten Graul wrote:
> On 21/01/2022 08:05, Wen Gu wrote:
>> On 2022/1/13 11:02 pm, Wen Gu wrote:
>> Sorry for bothering, just wonder if this patch needs further improvements?
> 
> Can you resend the patch and add the Fixes: tag? This should be done for all patches sent to the net tree.
> 

Thanks for your reminding. I will do this in my following patches.

> Other than that as discussed before:
> 
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>

Thanks,
Wen Gu
