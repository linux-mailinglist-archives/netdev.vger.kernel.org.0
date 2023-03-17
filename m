Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D49E6BDF07
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCQCpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCQCpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:45:05 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6EA36474;
        Thu, 16 Mar 2023 19:45:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ve15jQT_1679021099;
Received: from 30.221.112.207(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0Ve15jQT_1679021099)
          by smtp.aliyun-inc.com;
          Fri, 17 Mar 2023 10:45:00 +0800
Message-ID: <ce3ee223-2535-f355-419b-8d8856dd20b0@linux.alibaba.com>
Date:   Fri, 17 Mar 2023 10:44:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v4] net/smc: Use percpu ref for wr tx reference
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
 <20230315003440.23674405@kernel.org>
From:   Kai <KaiShen@linux.alibaba.com>
In-Reply-To: <20230315003440.23674405@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/23 3:34 PM, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 06:04:25 +0000 Kai wrote:
>> Signed-off-by: Kai <KaiShen@linux.alibaba.com>
> 
> Kai Shen ?
> 
>>
> 
> You're missing a --- separator here, try to apply this patch with
> git am :/
> 
>> v1->v2:
>> - Modify patch prefix
>>
>> v2->v3:
>> - Make wr_reg_refcnt a percpu one as well
>> - Init percpu ref with 0 flag instead of ALLOW_REINIT flag
>>
>> v3->v4:
>> - Update performance data, this data may differ from previous data
>>    as I ran cases on other machines
>> ---
Will fix, thanks
