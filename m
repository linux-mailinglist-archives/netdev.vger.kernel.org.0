Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49F63709A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 03:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKXCpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 21:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiKXCo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 21:44:59 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E767AF54;
        Wed, 23 Nov 2022 18:44:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VVYtXTl_1669257893;
Received: from 30.221.149.133(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VVYtXTl_1669257893)
          by smtp.aliyun-inc.com;
          Thu, 24 Nov 2022 10:44:54 +0800
Message-ID: <062f9b7b-4e44-107b-1825-01dfbdd7553d@linux.alibaba.com>
Date:   Thu, 24 Nov 2022 10:44:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next v5 03/10] net/smc: fix SMC_CLC_DECL_ERR_REGRMB
 without smc_server_lgr_pending
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
 <1669218890-115854-4-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1669218890-115854-4-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/22 11:54 PM, D.Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> As commit 4940a1fdf31c ("net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB
> error cause by server") mentioned, it works only when all connection
> creations are completely protected by smc_server_lgr_pending, since we
> already remove this lock, we need to re-fix the issues.
> 
> Fixes: 4940a1fdf31c ("net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---

Hi, all

This PATCH should not be treated as a separate bugfix, I will merge it to the PATCH
who remove the lock in next serial.

Thanks.
