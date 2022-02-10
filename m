Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578174B0414
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiBJDrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:47:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiBJDrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:47:18 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3423BFF;
        Wed,  9 Feb 2022 19:47:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V424t6H_1644464836;
Received: from 30.225.28.114(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V424t6H_1644464836)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 11:47:16 +0800
Message-ID: <8134101f-31f0-849a-a59d-877fd210ac0a@linux.alibaba.com>
Date:   Thu, 10 Feb 2022 11:47:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v6 5/5] net/smc: Add global configure for auto
 fallback by netlink
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
 <64348e3dcd0b74ed638e895fa217d03df9bec854.1644413637.git.alibuda@linux.alibaba.com>
 <1a1a740c-7dcf-4921-0a05-a727e2a5170e@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <1a1a740c-7dcf-4921-0a05-a727e2a5170e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/2/10 上午12:21, Karsten Graul 写道:
> On 09/02/2022 15:11, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> Although we can control SMC auto fallback through socket options, which
>> means that applications who need it must modify their code. It's quite
>> troublesome for many existing applications. This patch modifies the
>> global default value of auto fallback through netlink, providing a way
>> to auto fallback without modifying any code for applications.
>>
> 
> And of course also in this patch: no "auto fallback" in comments or as part
> of variable names.
> 

I will fix all the wording and the naming issues in next series as soon 
as possible.

> Do you plan to enhance the smc-tools user space part, too?

Yes, I'll enhance the smc-tools later.

Thanks.



