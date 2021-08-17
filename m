Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755CD3EEA6C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhHQKAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234593AbhHQKAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 06:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2C7560F41;
        Tue, 17 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629194405;
        bh=PudhEcvDgkdHBy3oPJ4fV09CG2trDDyC9FXEw4xkjnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RlZsJdvmHdefh9YuyEPyuy0XR0mISPxiAgXOAWcKO9Vbt18c2H97s/5nQWrvVxW5N
         NrqAjFO97kkAdO8KxF+3j8Dns2BPFIl43XpLSCNyYi6GF3tHg8kcC7wDH9LPedTJ0C
         EPL1CLStMqRzOUa3f4C8Gq6yAMjsFPoIq0wNCYPhtsqKQAu9vYfiXdQRJ/DS2zu+U3
         3uMpVFy1mxQMMvZaUToj143LFLo+EZOnU9v8OwRa1+b/6oQZds5/7O997KMZxhylE5
         ANJ/bIKkvQDQKRoPuXci6w65tVB8gtk+y01Qt2LeFsP9E4zhdTS8XX+T6T4DXWHvJ4
         8lLi4YXB+rqvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7C8E60A25;
        Tue, 17 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: improved IOAM tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162919440581.3819.17944234726166748000.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 10:00:05 +0000
References: <20210816171638.17965-1-justin.iurman@uliege.be>
In-Reply-To: <20210816171638.17965-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 19:16:38 +0200 you wrote:
> As previously discussed with David Ahern, here is a refactored and improved
> version of the IOAM self-test. It is now more complete and more robust. Now,
> all tests are divided into three categories: OUTPUT (evaluates the IOAM
> processing by the sender), INPUT (evaluates the IOAM processing by the receiver)
> and GLOBAL (evaluates wider use cases that do not fall into the other two
> categories). Both OUTPUT and INPUT tests only use a two-node topology (alpha and
> beta), while GLOBAL tests use the entire three-node topology (alpha, beta,
> gamma). Each test is documented inside its own handler in the (bash) script.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: improved IOAM tests
    https://git.kernel.org/netdev/net-next/c/752be2976405

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


