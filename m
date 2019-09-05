Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44922A9A64
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfIEGNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:13:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfIEGNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 02:13:10 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45A661537CE83;
        Wed,  4 Sep 2019 23:13:09 -0700 (PDT)
Date:   Wed, 04 Sep 2019 23:13:05 -0700 (PDT)
Message-Id: <20190904.231305.424341683281003706.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCHv2 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <70ae3f79-0c57-97d4-ebec-1378782605c8@oracle.com>
References: <1567322773-5183-2-git-send-email-yanjun.zhu@oracle.com>
        <20190904.152218.250246841354408872.davem@davemloft.net>
        <70ae3f79-0c57-97d4-ebec-1378782605c8@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 23:13:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Thu, 5 Sep 2019 10:48:01 +0800

> 
> On 2019/9/5 6:22, David Miller wrote:
>> From: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Date: Sun,  1 Sep 2019 03:26:13 -0400
>>
>>> +static inline void nv_get_stats(int cpu, struct fe_priv *np,
>>> +				struct rtnl_link_stats64 *storage)
>>   ...
>>> +static inline void rx_missing_handler(u32 flags, struct fe_priv *np)
>>> +{
>> Never use the inline keyword in foo.c files, let the compiler decide.
> 
> Thanks a lot for your advice. I will pay attention to the usage of
> inline in the
> 
> source code.
> 
> If you agree, I will send V3 about this soon.

Of course "I agree" with my own feedback.  Please just make V3 with
the inline keywords removed.
