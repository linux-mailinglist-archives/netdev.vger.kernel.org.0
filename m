Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04F698D11
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBPGeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPGeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:34:06 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E9E410A0;
        Wed, 15 Feb 2023 22:34:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VbnCzRk_1676529237;
Received: from 30.221.149.236(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VbnCzRk_1676529237)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 14:33:59 +0800
Message-ID: <2dc9a310-b858-2e55-149b-e9f962498cd4@linux.alibaba.com>
Date:   Thu, 16 Feb 2023 14:33:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] net/smc: fix application data exception
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1676528975-20423-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1676528975-20423-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/23 2:29 PM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a certain probability that following
> exceptions will occur in the wrk benchmark test:
> 
> Running 10s test @ http://11.213.45.6:80
>    8 threads and 64 connections
>    Thread Stats   Avg      Stdev     Max   +/- Stdev
>      Latency     3.72ms   13.94ms 245.33ms   94.17%
>      Req/Sec     1.96k   713.67     5.41k    75.16%
>    155262 requests in 10.10s, 23.10MB read
> Non-2xx or 3xx responses: 3
> 

Please ignore this patch,
There are some problems with the format of this patch. Sorry!

D. Wythe
