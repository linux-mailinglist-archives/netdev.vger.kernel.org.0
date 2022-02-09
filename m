Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D884AEFAD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiBILJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiBILJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:09:22 -0500
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE70E0828BB;
        Wed,  9 Feb 2022 02:05:58 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4-nLeX_1644399711;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4-nLeX_1644399711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:41:51 +0800
Message-ID: <20fc8ef9-6cbc-ac1d-97ad-ab47a2874afd@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 17:41:50 +0800
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
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YgOKc5FW/JRmW1U6@TonyMac-Alibaba>
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

I don't think this is necessary, since we already have socket options. 
Is there any scenario that the socket options and global switch can not 
cover?

Thanks.

在 2022/2/9 下午5:33, Tony Lu 写道:
> SMC supports net namespace, it would be better to provide a per
> net-namespace switch. Generally, one container has one application, runs
> different workload that is different from others. So the behavior could
> be different, such as high-performance (don't fallback for limit) or TCP
> transparent replacement (limit if needed).
