Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B34CBA91
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiCCJpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiCCJpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:45:09 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D96D178695;
        Thu,  3 Mar 2022 01:44:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V66rSXQ_1646300660;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V66rSXQ_1646300660)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 17:44:20 +0800
Date:   Thu, 3 Mar 2022 17:44:19 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220303094419.GB35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220303201352.43ea21a3@canb.auug.org.au>
 <20220303201536.042e9135@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303201536.042e9135@canb.auug.org.au>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 08:15:36PM +1100, Stephen Rothwell wrote:
>Hi all,
>
>On Thu, 3 Mar 2022 20:13:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the net-next tree, today's linux-next build (htmldocs)
>> produced this warning:
>> 
>> Documentation/networking/smc-sysctl.rst:3: WARNING: Title overline too short.
>> 
>> =========
>> SMC Sysctl
>> =========
>> 
>> Introduced by commit
>> 
>>   12bbb0d163a9 ("net/smc: add sysctl for autocorking")
>
>Also:
>
>Documentation/networking/smc-sysctl.rst: WARNING: document isn't included in any toctree

Thanks for your reminder ! I'll send a patch to fix this warnings soon.

