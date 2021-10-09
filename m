Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A239427E0A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhJIXmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 19:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhJIXmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 19:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C468760F6B;
        Sat,  9 Oct 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633822807;
        bh=jv/ckCSV8DDYau4rG0uKqS9LBWg3WcvzazPRh2YvPTs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f9dfwKO70DLB0x/mG7nsQYz8Hi1FuI2F2wtjI8pHDYi8uD8M/l6a658eucWc8+ZjB
         tYK8OCQz8/7Tx6V/wtvFACo8Q8nWURqdOSJ2cXkpEffGng4HRwqOc7Ez+3Vn0I3m6p
         cIRr/oWTOrDba6JuUsvW3YwyktnTSTgqtLlQLmhz9BWM1fd2UaD8aNPTpnlkXoMdae
         VzI8Evom4jkimdqe8aMPryLeq5WA2mBEdgYuqtXyc25ff2npBbuUDpHv7CZmY7TpBB
         TBtkFaRqfTYo53twVsmo02nce0wx5JkXv2u47cPyg6DQy0yXiZ7m/HlEHY3PyFLoVk
         uvgWC/7YdNGzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B3E0460A3A;
        Sat,  9 Oct 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2 0/2] Support for IOAM encap modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163382280773.7636.1730208567353717070.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 23:40:07 +0000
References: <20211005151020.32533-1-justin.iurman@uliege.be>
In-Reply-To: <20211005151020.32533-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue,  5 Oct 2021 17:10:18 +0200 you wrote:
> v2:
>  - Fix the size of ioam6_mode_types (thanks David Ahern)
>  - Remove uapi diff from patch #1 (already merged inside iproute2-next)
> 
> Following the series applied to net-next (see [1]), here are the corresponding
> changes to iproute2.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2,1/2] Add support for IOAM encap modes
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8fb522cde3a8
  - [iproute2-next,v2,2/2] Update documentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=41020eb0fdae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


