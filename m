Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090A56AFEA8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCHF6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCHF6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:58:23 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C88B7C975;
        Tue,  7 Mar 2023 21:58:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdO9hJB_1678255096;
Received: from 30.221.150.20(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VdO9hJB_1678255096)
          by smtp.aliyun-inc.com;
          Wed, 08 Mar 2023 13:58:17 +0800
Message-ID: <6f918827-c037-ab5d-b3bf-2cd2617e737b@linux.alibaba.com>
Date:   Wed, 8 Mar 2023 13:58:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v4 0/4] net/smc: Introduce BPF injection
 capability
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
 <25cee0eb-a1f9-9f0b-9987-ca6e79e6b752@linux.alibaba.com>
 <f1e87004-4654-8204-2771-32ed13467202@linux.dev>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <f1e87004-4654-8204-2771-32ed13467202@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Martin

I'm very sorry to see your comments on v2  just now...

I just checked the email and found that your reply was filtered out by 
my email terminal. 😭

Thank you very much for your comments. I will try to modify it according 
to your suggestions.

Best wishes.

D. Wythe


On 3/8/23 12:44 AM, Martin KaFai Lau wrote:
> On 3/6/23 7:05 PM, D. Wythe wrote:
>> I wondering if there are any more questions about this PATCH, This 
>> patch seems 
> May be start with the questions on v2 first.
>
>> to have been hanging for some time.
>>
>> If you have any questions, please let me know.
>>
>>
>> Thanks,
>>
>> D. Wythe
>>
>>
>> Do you have any questions about this PATCH?  If you have any other 
>> questions, please let me know.
>>
