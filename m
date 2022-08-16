Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1EC59530D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiHPGxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiHPGw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:52:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5478721085A;
        Mon, 15 Aug 2022 20:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D650EB815A6;
        Tue, 16 Aug 2022 03:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A399C433D6;
        Tue, 16 Aug 2022 03:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660619439;
        bh=37qLmVEAM9Iq6CJiDtXaBzISHDDf+Lv6O7mWwx4DaDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HX9/jnt6tBboR53wnB8Tc025a3lN/PLC6/cqTeZD5wSEyuXQ3jwD5a5+sY+Q+3yMM
         a1FSJe18P3TcVh/gwVxzlg+K+3Ml+sPyDhICLENgyVjpqIjqCwJBnX33/B+O3QTtdB
         IewyBAwKqI96HKNdXN1qB7wC8Ir0rdZEgIoPqSKIMPRmcnRQnPUfoLOukRlmmWJay+
         t3Mopz45sI5X2A30HitdhpZYz+gNSVXfGxPKc1zEY7wHMZVjC8+Z7SKY2z+PEuQnyl
         9aN/R2hEG3nHn3d3qJSW27j0TCr2hfzpKFNF9cmlYrLW9d7xsP1GGYSHngkk+s58u+
         BESsDLJj5z8NA==
Date:   Mon, 15 Aug 2022 20:10:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next,0/3] cleanup of qdisc offload function
Message-ID: <20220815201038.4321b77e@kernel.org>
In-Reply-To: <20220816020423.323820-1-shaozhengchao@huawei.com>
References: <20220816020423.323820-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 10:04:20 +0800 Zhengchao Shao wrote:
> Some qdiscs don't care return value of qdisc offload function, so make 
> function void.

How many of these patches do you have? Is there a goal you're working
towards? I don't think the pure return value removals are worth the
noise. They don't even save LoC:

 3 files changed, 9 insertions(+), 9 deletions(-)
