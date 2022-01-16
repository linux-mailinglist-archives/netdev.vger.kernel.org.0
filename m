Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3770848FB53
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiAPHSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 02:18:04 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:37474 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbiAPHSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 02:18:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1wL1M2_1642317480;
Received: from 30.39.162.39(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1wL1M2_1642317480)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 16 Jan 2022 15:18:01 +0800
Message-ID: <5ebaaf18-bfdc-b59f-c541-7e32fb2e50fb@linux.alibaba.com>
Date:   Sun, 16 Jan 2022 15:18:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Fix hung_task when removing SMC-R devices
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1642167444-107744-1-git-send-email-guwen@linux.alibaba.com>
 <20220115102947.GB13341@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220115102947.GB13341@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/15 6:29 pm, dust.li wrote:
> On Fri, Jan 14, 2022 at 09:37:24PM +0800, Wen Gu wrote:
>> A hung_task is observed when removing SMC-R devices.
> 
> Good catch, thank you !
> 
> Update the comments of smc_smcr_terminate_all as well ?
> 

OK, will do. Thank you!

Thanks,
Wen Gu

>>
>> Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
>> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> 
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> 

