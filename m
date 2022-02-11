Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B554B2246
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346089AbiBKJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:41:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiBKJlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:41:45 -0500
Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6021010A2;
        Fri, 11 Feb 2022 01:41:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V48bC1f_1644572495;
Received: from 30.225.28.189(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V48bC1f_1644572495)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 17:41:36 +0800
Message-ID: <3903a665-d3ac-3030-0a41-b774af317776@linux.alibaba.com>
Date:   Fri, 11 Feb 2022 17:41:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v7 0/5] net/smc: Optimizing performance in
 short-lived scenarios
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644481811.git.alibuda@linux.alibaba.com>
 <7fe9fd06-21cb-1701-d8e7-318b7f29d650@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <7fe9fd06-21cb-1701-d8e7-318b7f29d650@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/10 下午10:59, Karsten Graul 写道:
> On 10/02/2022 10:11, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch set aims to optimizing performance of SMC in short-lived
>> links scenarios, which is quite unsatisfactory right now.
> 
> This series looks good to me.
> 
> Thank you for the valuable contribution to the SMC module and the good discussion!
> 
> For the series:
> Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>


My pleasure. Thank for all suggestions and reviews in all the series.

Best Wishes.
