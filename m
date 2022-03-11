Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD84D5676
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiCKAVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238861AbiCKAVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:21:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59765199D5F;
        Thu, 10 Mar 2022 16:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95687B80C75;
        Fri, 11 Mar 2022 00:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21337C340EC;
        Fri, 11 Mar 2022 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646958010;
        bh=vsQPYWinnoL+iiFfGo8DBUV7k4LX6WDcPJkSZadSiEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U/CNGhcl0Q2G+0lbuyON1og5IR2U/tz43PKdgkCnAP6zsi2CIgWCRVvC3bU94z2Tj
         +yXPevkfQrmVzxM/6/RZtl+NbJCY5CA7Cf/saW8hoWHw2VeUIL0Su4EaTI11D+abRn
         DZuimTRse2ia2NJTcmGuve+3T/JK6LWikcSa1Dwx0POjvVZ3A6lf7wXPyEq2MYNojH
         YsUqVvdaoMb1LRmX0Rz+rRBILx+gIoFI0qx8XkmDcuE/5Clf/lIj39TMK3cx0AR2MV
         mc6GJ6qSp0dM/C76Y5GpIKAarrhVhellblq13jZGIdp0CRpfZVcLu7py3oz9S8UPVx
         TOFfagD8qGlvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE7B0E5D087;
        Fri, 11 Mar 2022 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695800997.16598.9462680209736026298.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 00:20:09 +0000
References: <YikmmXsffE+QajTB@linutronix.de>
In-Reply-To: <YikmmXsffE+QajTB@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kuba@kernel.org, toke@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, mingo@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
        kafai@fb.com, songliubraving@fb.com, rostedt@goodmis.org,
        tglx@linutronix.de, yhs@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 9 Mar 2022 23:13:45 +0100 you wrote:
> Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
> pointer. This pointer is dereferenced in trace_mem_connect() which leads
> to segfault.
> 
> The trace points (mem_connect + mem_disconnect) were put in place to
> pair connect/disconnect using the IDs. The ID is only assigned if
> __xdp_reg_mem_model() does not return NULL. That connect trace point is
> of no use if there is no ID.
> 
> [...]

Here is the summary with links:
  - [net,v3] xdp: xdp_mem_allocator can be NULL in trace_mem_connect().
    https://git.kernel.org/netdev/net/c/e0ae713023a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


