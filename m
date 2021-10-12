Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47342A2C3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbhJLLCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhJLLCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A929F60E78;
        Tue, 12 Oct 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634036407;
        bh=ocp2cDkCWAq1+tt4baPmUGIMB8tD8PiYVLvb/YKs2wY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N8mulI7ELu/YAvxxP7S7nGEl/gWYwgbn3ugC4YjBpZbTAx/1t8jjixApzd1KsObAR
         DamXSxNUrKluhr7r+IbF2o5F7DpMcdjtRluuY7oIXNSR10mz5bKzZxkuvPZZHM2PSj
         Omuuw4lqNiioW76mX4gQ7TcBL+7fmgKwJzgR83B8vFHhJTjvvYFXAzuPtNRdrweXlB
         YPfpTc21B1/9ydv6BekhPz5vAJW37gR6Ne0r3kl2dqirNnh/V+8YvsX60tnb4/kytf
         Kz9pQkI2Ql++INpSg1G5l9Q6urNG8zJCWRjhIYNp+XxthoEEqNqLYwJMl8vshGiz8p
         PAB408f2fULpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E7C360173;
        Tue, 12 Oct 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Correct the IOAM behavior for undefined trace type
 bits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403640764.2059.6657843677004836514.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 11:00:07 +0000
References: <20211011180412.22781-1-justin.iurman@uliege.be>
In-Reply-To: <20211011180412.22781-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 20:04:10 +0200 you wrote:
> (@Jakub @David: there will be a conflict for #2 when merging net->net-next, due
> to commit [1]. The conflict is only 5-10 lines for #2 (#1 should be fine) inside
> the file tools/testing/selftests/net/ioam6.sh, so quite short though possibly
> ugly. Sorry for that, I didn't expect to post this one... Had I known, I'd have
> made the opposite.)
> 
> Modify both the input and output behaviors regarding the trace type when one of
> the undefined bits is set. The goal is to keep the interoperability when new
> fields (aka new bits inside the range 12-21) will be defined.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv6: ioam: move the check for undefined bits
    https://git.kernel.org/netdev/net/c/2bbc977ca689
  - [net,2/2] selftests: net: modify IOAM tests for undef bits
    https://git.kernel.org/netdev/net/c/7b1700e009cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


