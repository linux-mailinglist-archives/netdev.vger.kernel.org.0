Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14546A659D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 03:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCACg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 21:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCACg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 21:36:28 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21C132E66;
        Tue, 28 Feb 2023 18:36:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VclaLRt_1677638177;
Received: from 30.221.150.55(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VclaLRt_1677638177)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 10:36:18 +0800
Message-ID: <8f2d2c68-cc9a-e19c-0da9-658b22810f10@linux.alibaba.com>
Date:   Wed, 1 Mar 2023 10:36:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH bpf-next v4 0/4] net/smc: Introduce BPF injection
 capability
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
 <20230228150259.6b526bef@kernel.org>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <20230228150259.6b526bef@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/23 7:02 AM, Jakub Kicinski wrote:
> On Wed,  1 Mar 2023 00:38:07 +0800 D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This patches attempt to introduce BPF injection capability for SMC,
>> and add selftest to ensure code stability.
> 
> If you cross-posting to net please make sure you follow netdev rules.
> Don't repost too often.

I'm very sorry, dues to some low-level errors,
so I was anxious to fix such problems.

I will pay more attention in the future!! Thanks for
your advice.

best wishes
D. Wythe


