Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB0851D1A2
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386362AbiEFGv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiEFGv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:51:27 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676B66ADC;
        Thu,  5 May 2022 23:47:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VCQeAap_1651819656;
Received: from 30.225.28.185(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VCQeAap_1651819656)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 14:47:41 +0800
Message-ID: <67b00a33-155b-03b8-cb74-7d0095187ca9@linux.alibaba.com>
Date:   Fri, 6 May 2022 14:47:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] net/smc: Fix smc-r link reference count
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1651814548-83231-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1651814548-83231-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/5/6 下午1:22, D. Wythe 写道:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> The following scenarios exist:
> 
> lnk->refcnt=1;
> smcr_link_put(lnk);
> lnk->refcnt=0;
> 				smcr_link_hold(lnk);
> __smcr_link_clear(lnk);
> 				do_xxx(lnk);
> 
> This patch try using refcount_inc_not_zero() instead refcount_inc()
> to prevent this race condition. Therefore, we need to always check its
> return value, and respond with an error when it fails.
> 
> Fixes: 20c9398d3309 ("net/smc: Resolve the race between SMC-R link access and clear")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Wrong subject prefix here, please ignore this patch, we will send 
another revison later.

Thanks.
D. Wythe
