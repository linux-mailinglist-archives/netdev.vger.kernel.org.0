Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21554B985A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 06:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiBQFhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 00:37:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiBQFha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 00:37:30 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA1615A217
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 21:37:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V4geXlV_1645076231;
Received: from 30.225.28.194(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4geXlV_1645076231)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Feb 2022 13:37:11 +0800
Message-ID: <f9cdf4a8-1e6e-007e-4ccf-9eff9573ef4f@linux.alibaba.com>
Date:   Thu, 17 Feb 2022 13:37:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [RFC PATCH net] vrf: fix incorrect dereferencing of skb->cb
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
 <4383fcc3-f7de-8eb3-6746-2f271578a9e0@kernel.org>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <4383fcc3-f7de-8eb3-6746-2f271578a9e0@kernel.org>
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

在 2022/2/17 上午11:50, David Ahern 写道:
> The packet is recirculated through the VRF device so the cb data should
> be overwritten. The VRF driver does another route lookup within the VRF.
> Address selection should only consider addresses in the domain.
> Something is off in that logic for VRF route leaking. I looked into a
> bit when Michael posted the tests, but never came back to it.

Got your point, this patch is not really appropriate considering
that. Another way to complete the test may be to modify the IP address 
of vrf blue in test script，the default local loopback address is the 
reason for this failure. What do you think ?

Thanks for you comments.

Best Wishes.
