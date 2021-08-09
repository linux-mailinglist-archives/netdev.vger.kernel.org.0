Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08EA3E422B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhHIJKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhHIJKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BE51610A1;
        Mon,  9 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628500205;
        bh=kOMjeOeuoHIp5vo536DSDYcDMzK4/C49kDFG/VxXCnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jbKQqvUA6HjQd1nXpEhBTwDM+OEprCEe/R0K6zo5o9q6wVWv4bibHpz6rrcvhg7IC
         J0kvFVEGQGOO5huGLLWS8pbUGIgDHjCY2MTDeVlPBSQJT2us2sA5UWTpwcijpo/lQ5
         5aQEWt4yRy10yXf83Ryjn1Wqt3c62Z14yU5wSOKXNvpkHEawsvOyvxqzFVMCHtJkTq
         1mYdR911Q1lqDThgFoV+3l5HRzQeuD8qfry0kru99DEZZE6k6wRWif78Sl6zI4fHbS
         OQfRMD3ys/ZXeetWwwnLssR8aisGJJseRnYTwA5sEyqq/knEJpoTD6UVvkx+xLq6qi
         CkhBcYY/bq50g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89E4060A24;
        Mon,  9 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] dccp: add do-while-0 stubs for dccp_pr_debug macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850020556.22991.14180369324728108258.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:10:05 +0000
References: <20210808230440.15784-1-rdunlap@infradead.org>
In-Reply-To: <20210808230440.15784-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, dccp@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, gerrit@erg.abdn.ac.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  8 Aug 2021 16:04:40 -0700 you wrote:
> GCC complains about empty macros in an 'if' statement, so convert
> them to 'do {} while (0)' macros.
> 
> Fixes these build warnings:
> 
> net/dccp/output.c: In function 'dccp_xmit_packet':
> ../net/dccp/output.c:283:71: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
>   283 |                 dccp_pr_debug("transmit_skb() returned err=%d\n", err);
> net/dccp/ackvec.c: In function 'dccp_ackvec_update_old':
> ../net/dccp/ackvec.c:163:80: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
>   163 |                                               (unsigned long long)seqno, state);
> 
> [...]

Here is the summary with links:
  - [-net] dccp: add do-while-0 stubs for dccp_pr_debug macros
    https://git.kernel.org/netdev/net/c/86aab09a4870

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


