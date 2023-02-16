Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F8F698B55
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 05:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBPEO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 23:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPEO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 23:14:27 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07D932CED;
        Wed, 15 Feb 2023 20:14:24 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VbmlacN_1676520860;
Received: from 30.221.149.236(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VbmlacN_1676520860)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 12:14:22 +0800
Message-ID: <10e6ffcd-c24c-2d2d-bb71-af2b1a7844ab@linux.alibaba.com>
Date:   Thu, 16 Feb 2023 12:14:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net] net/smc: fix application data exception
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     kgraul@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1669450950-27681-1-git-send-email-alibuda@linux.alibaba.com>
 <ca058775-5fa2-e770-ef32-588bcb84ac6e@linux.ibm.com>
 <20230215093110.11ea76e8@kernel.org>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <20230215093110.11ea76e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/23 1:31 AM, Jakub Kicinski wrote:
> On Wed, 15 Feb 2023 10:27:55 +0100 Wenjia Zhang wrote:
>> Hi David,
>>
>> Thank you for remembering me again about this patch. I did forget to
>> answer you, sorry!
>>
>> My consideration was if memzero_explicit() is necessary in this case.
>> But sure, it makes sense, especiall when the dereferencing is in
>> somewhere else.
>>
>> Thank you for the fix!
>>
>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> 
> Thanks! David, please repost if you'd like the patch to be applied to
> the networking tree. The original posting is too old to use.

Thank you for your reminder.  I will repost it after rebasing.
D. Wythe
