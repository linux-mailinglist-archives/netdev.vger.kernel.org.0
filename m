Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751E76E8773
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDTB1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTB1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D919B5;
        Wed, 19 Apr 2023 18:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710E7641B5;
        Thu, 20 Apr 2023 01:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C98C433EF;
        Thu, 20 Apr 2023 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681954034;
        bh=JAFjUrJMnv8cikWR/XW1+hs4l0JVb3ksyTOqOw/X9yY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KT1yIXD0TsWdMUwAWO810zqLOGwa/eC1gQfBFYG2sWNAKlo7kpSw+p5jkBp8dIlp/
         1DdQCrayVVgacux4G0csT2Esb8jz/72Wnr1FR9dUjOJ732B6KW3mYuslNhXms6Hld4
         49i3s+h/TKiY1eCzXZ4N+UZbUpWN0j3jB1fS0YXESatS5wErF1C56xv/Pr4u7ZABWA
         nMp9tIFPZe7rAe29dS7LETt823H6jK9do3B92EAQX6eDzDniSH/kxLI3OakN1HenbH
         0H7OYPSv4BDyogIt/fpCglo9nvuxx1kQxqMu4JhkxNFs18dNFw7aLoGitkgUV0q960
         J2PJ+BtO2jTyA==
Date:   Wed, 19 Apr 2023 18:27:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: print jiffies when transmit queue time out
Message-ID: <20230419182713.2cd1f81b@kernel.org>
In-Reply-To: <20230419115632.738730-1-yajun.deng@linux.dev>
References: <20230419115632.738730-1-yajun.deng@linux.dev>
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

On Wed, 19 Apr 2023 19:56:32 +0800 Yajun Deng wrote:
> Although there is watchdog_timeo to let users know when the transmit queue
> begin stall, but dev_watchdog() is called with an interval. The jiffies
> will always be greater than watchdog_timeo.
> 
> To let users know the exact time the stall started, print jiffies when
> the transmit queue time out.

Please add an explanation of how this information is useful in practice.
