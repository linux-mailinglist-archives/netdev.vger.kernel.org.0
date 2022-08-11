Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E427358F738
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiHKFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiHKFN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:13:59 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CACB86C1B;
        Wed, 10 Aug 2022 22:13:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VLxoqJb_1660194832;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VLxoqJb_1660194832)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 13:13:53 +0800
Date:   Thu, 11 Aug 2022 13:13:51 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] net/smc: optimize the parallelism of
 SMC-R connections
Message-ID: <YvSQD8ddmHbnLlpU@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
 <20220810202845.164eb470@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810202845.164eb470@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 08:28:45PM -0700, Jakub Kicinski wrote:
> On Thu, 11 Aug 2022 01:47:31 +0800 D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > This patch set attempts to optimize the parallelism of SMC-R connections,
> > mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> > occur after thoses optimization.
> 
> net-next is closed until Monday, please see the FAQ.
> 
> Also Al Viro complained about the SMC ULP:
> 
> https://lore.kernel.org/all/YutBc9aCQOvPPlWN@ZenIV/
> 
> I didn't see any responses, what the situation there?

Sorry for the late reply. I am working on it and will give out the
details as soon as possible.

Tony Lu
