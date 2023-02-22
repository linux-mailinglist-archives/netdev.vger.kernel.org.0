Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38369ECE9
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjBVChf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBVChe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:37:34 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F22033472;
        Tue, 21 Feb 2023 18:37:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VcEEUPh_1677033448;
Received: from 30.221.149.248(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VcEEUPh_1677033448)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 10:37:29 +0800
Message-ID: <8742afeb-afbf-3079-21e7-a52b32ff3ecd@linux.alibaba.com>
Date:   Wed, 22 Feb 2023 10:37:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 0/2] net/smc: Introduce BPF injection capability
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1676964305-1093-1-git-send-email-alibuda@linux.alibaba.com>
 <89600917-ec58-3a30-dea7-bae2d67cc838@linux.alibaba.com>
 <Y/Twbebt2p1TEsrl@corigine.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <Y/Twbebt2p1TEsrl@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/23 12:25 AM, Simon Horman wrote:
> On Tue, Feb 21, 2023 at 03:29:59PM +0800, D. Wythe wrote:
>>
>> Sorry for forgot to cc the maintainer of BPF,
>> please ignore this. I will resend a new version.
> 
> net-next is closed.
> 
> You'll need to repost it, either as an RFC, or wait until after
> v6.3-rc1 has been tagged.

I had repost it to bpf-next, but thank you for your reminding!

Best wishes.
D. Wythe
