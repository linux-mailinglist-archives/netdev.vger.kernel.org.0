Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9ED4B05C1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiBJFuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:50:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiBJFuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:50:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664F010F6
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 21:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C7161C2C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B802C340EF;
        Thu, 10 Feb 2022 05:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644472212;
        bh=mplaCPLEKWFfd1M5vT850gNfrpRvfQycYpopQELvULY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9JCMgltCBsBqfqc7k5JmOaGL8tHUBTm6kE7JZ+g1AqiJdUl+XRvUewrLf+Hx/cIK
         AI+uBLOXRR+qeIWnKNGmmLigx8R6yJjjRKRGiV19yR0MKlm+zgn7KLM923TYfop7/W
         3SXyK3jcrV0klmbtjvlK9r8ZyIxmLUGqTE+Pb1PTn/LB4rBGRBeNAiqR1fnAWRxFgR
         QZSB/MEFCZIK84BSEmm1LSHzMb2EalZp49l2OXTf61BZzd2TEPn+ug4QhyrD5/sKk3
         cWo/eMLj6sXOfXvB4QTOcPt0ttpbUnW7MpXEumTQBupk07TbRmNMFCNGlc/f4qQuFl
         myolpZytjm38A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F251E6D458;
        Thu, 10 Feb 2022 05:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164447221225.5409.15203666712109829723.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 05:50:12 +0000
References: <YgQOebeZ10eNx1W6@linutronix.de>
In-Reply-To: <YgQOebeZ10eNx1W6@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, kuniyu@amazon.co.jp,
        eric.dumazet@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        efault@gmx.de, tglx@linutronix.de, yoshfuji@linux-ipv6.org,
        kafai@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 9 Feb 2022 19:56:57 +0100 you wrote:
> Commit
>    9652dc2eb9e40 ("tcp: relax listening_hash operations")
> 
> removed the need to disable bottom half while acquiring
> listening_hash.lock. There are still two callers left which disable
> bottom half before the lock is acquired.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.
    https://git.kernel.org/netdev/net-next/c/4f9bf2a2f5aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


