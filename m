Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69664AF053
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiBIL5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiBIL4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:56:20 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73442C1038EE;
        Wed,  9 Feb 2022 02:56:37 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4.8Z-0_1644404194;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4.8Z-0_1644404194)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 18:56:35 +0800
Message-ID: <5150791a-b91f-c861-b648-9de78af0b984@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 18:56:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v5 5/5] net/smc: Add global configure for auto
 fallback by netlink
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
 <YgOKc5FW/JRmW1U6@TonyMac-Alibaba>
 <20fc8ef9-6cbc-ac1d-97ad-ab47a2874afd@linux.alibaba.com>
 <YgOPRh34nUWOqh2C@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YgOPRh34nUWOqh2C@TonyMac-Alibaba>
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


Copy that, there are indeed some problems for the container environment.
I'll try work on it.

Thanks.

在 2022/2/9 下午5:54, Tony Lu 写道:
> On Wed, Feb 09, 2022 at 05:41:50PM +0800, D. Wythe wrote:
>> I don't think this is necessary, since we already have socket options. Is
>> there any scenario that the socket options and global switch can not cover?
>>
> When transparently replacing the whole container's TCP connections, we
> cannot touch the user's application, and have to replace their
> connections to SMC. It is common for container environment, different
> containers will run different applications.
> 
> Most of TCP knob is per net-namespace, it could be better for us to do
> it from the beginning.
> 
> Thanks,
> Tony Lu
