Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542CA4CA06B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbiCBJSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiCBJSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:18:03 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6ECAD13E;
        Wed,  2 Mar 2022 01:17:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V62Au2h_1646212635;
Received: from 30.225.24.118(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V62Au2h_1646212635)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 17:17:16 +0800
Message-ID: <6bd627a7-08d0-ae62-edf3-a293fe4f5e7b@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 17:17:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1646140644-121649-1-git-send-email-alibuda@linux.alibaba.com>
 <82bd43af-1d90-4395-b868-4a045bf4a47b@linux.alibaba.com>
 <20220302075146.GA29189@e02h04389.eu6sqa>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220302075146.GA29189@e02h04389.eu6sqa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/2 3:51 pm, D. Wythe wrote:

> We should always be willing to improve the success rate of the SMC
> connection, creating a new group is not a side effect of this patch, it
> actually dues to the state bewteen connections that can not achieve
> clock synchronization. In fact, it can happen in any times.
> 
> Thanks.

OK, I understand. Thanks.
