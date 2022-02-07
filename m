Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5A4AB82D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiBGJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349688AbiBGJut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:50:49 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D97C043181;
        Mon,  7 Feb 2022 01:50:47 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3p8NYi_1644227444;
Received: from 30.225.28.47(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3p8NYi_1644227444)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 17:50:45 +0800
Message-ID: <f1ed4d54-d658-c668-99af-9994a634baf3@linux.alibaba.com>
Date:   Mon, 7 Feb 2022 17:50:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
From:   "D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH net-next v4 3/3] net/smc: Fallback when handshake
 workqueue congested
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644214112.git.alibuda@linux.alibaba.com>
 <6deeca64bfecbd01d724092a1a2c91ca8bce3ce0.1644214112.git.alibuda@linux.alibaba.com>
 <bab2d7f1-c57a-cab4-3963-23721292eece@linux.ibm.com>
In-Reply-To: <bab2d7f1-c57a-cab4-3963-23721292eece@linux.ibm.com>
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


The main communication in v2 series is about adding a dynamic control 
for auto fallback to TCP. I will soon add a new patch to implements this 
in v5 series, or modify it in curret patch. Which one do you recommend?

Look forward to your suggestions.

Thanks.


在 2022/2/7 下午3:56, Karsten Graul 写道:
> On 07/02/2022 07:24, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch intends to provide a mechanism to allow automatic fallback to
>> TCP according to the pressure of SMC handshake process. At present,
>> frequent visits will cause the incoming connections to be backlogged in
>> SMC handshake queue, raise the connections established time. Which is
>> quite unacceptable for those applications who base on short lived
>> connections.
> 
> I hope I didn't miss any news, but with your latest reply to the v2 series you
> questioned the config option in this v4 patch, so this is still work in progress, right?
