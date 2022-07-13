Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9F9573745
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiGMNUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiGMNUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:20:44 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65632E06;
        Wed, 13 Jul 2022 06:20:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VJE3WgM_1657718437;
Received: from 30.227.73.183(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJE3WgM_1657718437)
          by smtp.aliyun-inc.com;
          Wed, 13 Jul 2022 21:20:38 +0800
Message-ID: <9c3496de-aa8f-21fa-e3fc-385fafba21e4@linux.alibaba.com>
Date:   Wed, 13 Jul 2022 21:20:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 5/6] net/smc: Allow virtually contiguous sndbufs
 or RMBs for SMC-R
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
 <1657626690-60367-6-git-send-email-guwen@linux.alibaba.com>
 <20220712205442.22a29fcd@kernel.org>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220712205442.22a29fcd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/13 11:54 pm, Jakub Kicinski wrote:

> On Tue, 12 Jul 2022 19:51:29 +0800 Wen Gu wrote:
>> net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
> 
> This one does not build cleanly on 32bit.


Thanks for reminding, I will fix it in v2


Thanks,
Wen Gu
