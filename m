Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CABC6E2018
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjDNKA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDNKAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD0F76B4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7951B64583
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D15EC433EF;
        Fri, 14 Apr 2023 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681466417;
        bh=JTg/l7O4D0Tqqjo+nfR0i1wE0to/OKbIC8VxulHLCjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EF7vhlL5fVAciw1k2CYhpDssVfRMNOe+0CS8Rh1V8ZKUAI2fKeSCvZrQ1UIZ5A4Fk
         mtVZzrkb8VxPvVzVmZ1Te+dGSEImnAGAZjlgwX5YWsPOQ+PSKqtNqtHBWnu1by38DA
         CtCslk3KSBNDm6NnOFCWCepyP7O40gY+hb+c38dK9HVGODqtqNUbQOpv8LrthjGdGU
         mbe/bldV1HxXDaGYEklu5UbpMU0CW30oKhUwEJar29X6fhEtoZaox8yHmm7vBnIqYT
         2S6qHj5CDx/i1ZtOY1lR5Uxcm9pUzU0YJFn6NU+GJm7kkAGZDeEv04CYCBg4nrvO5C
         QiDL+clL8XxgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75A07E29F3B;
        Fri, 14 Apr 2023 10:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: sched: sch_qfq: prevent slab-out-of-bounds in
 qfq_activate_agg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168146641747.17210.6250104828316736381.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 10:00:17 +0000
References: <ZDfbCsDa6oLKzsed@pr0lnx>
In-Reply-To: <ZDfbCsDa6oLKzsed@pr0lnx>
To:     Gwangun Jung <exsociety@gmail.com>
Cc:     pabeni@redhat.com, jhs@mojatatu.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Apr 2023 19:35:54 +0900 you wrote:
> If the TCA_QFQ_LMAX value is not offered through nlattr, lmax is determined by the MTU value of the network device.
> The MTU of the loopback device can be set up to 2^31-1.
> As a result, it is possible to have an lmax value that exceeds QFQ_MIN_LMAX.
> 
> Due to the invalid lmax value, an index is generated that exceeds the QFQ_MAX_INDEX(=24) value, causing out-of-bounds read/write errors.
> 
> The following reports a oob access:
> 
> [...]

Here is the summary with links:
  - [net,v3] net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg
    https://git.kernel.org/netdev/net/c/3037933448f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


