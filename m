Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0DD4BD64C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbiBUG1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 01:27:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345139AbiBUG1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 01:27:40 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBC833A23
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 22:27:16 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V5.8J4c_1645424833;
Received: from 30.225.28.186(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V5.8J4c_1645424833)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 14:27:14 +0800
Message-ID: <472b6970-dbf1-216c-030d-218e23a227dd@linux.alibaba.com>
Date:   Mon, 21 Feb 2022 14:27:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [RFC PATCH net] vrf: fix incorrect dereferencing of skb->cb
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
 <4383fcc3-f7de-8eb3-6746-2f271578a9e0@kernel.org>
 <f9cdf4a8-1e6e-007e-4ccf-9eff9573ef4f@linux.alibaba.com>
 <6beec611-6af4-7a39-7581-a0a56821698d@kernel.org>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <6beec611-6af4-7a39-7581-a0a56821698d@kernel.org>
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



在 2022/2/18 上午11:53, David Ahern 写道:
> On 2/16/22 10:37 PM, D. Wythe wrote:
>> Got your point, this patch is not really appropriate considering
>> that. Another way to complete the test may be to modify the IP address
>> of vrf blue in test script，the default local loopback address is the
>> reason for this failure. What do you think ?

I am trying to work on rfc6724 and its implementation, which is source 
address selection code. I will reply as soon as I have a conclusion.

> Someone needs to dive into the source address selection code and see why
> it fails when crossing vrfs. I found a reminder note:
> ipv6_chk_acast_addr needs l3mdev check. Can you take a look?

Very valuable tips, I'll look it.

Best Wishes.
