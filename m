Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B0306A23
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhA1BOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhA1BLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EDEB464DDC;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611796212;
        bh=WsEQ0oVLURRcrMvca7K1auGRwZUAfXwGQd5GyqLCco0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X4kJ60XEvFhhICJFdbCq6cCtel8eYZKKjClnSSDgz1C+zxS+J9lJMM4WHSYK8Adzm
         Y9S/DozZCChINrTmwh3oH8eTRRCG4BjZcX8JBAMCfx923c0zRuieTS+XubWyUB1wek
         tXYi1+OIOx/JD3rJNKl6r26nGKK1IjXi03m2ybGq+WIEFJDXWoS4VpJ9iTiR7b75FX
         V0jrfLzthPUhca7iZv5rBT2ahrjZAMeyzEQxAwnMmuYmgOR/RlqpafyM+hVj6TtQNg
         +XJkb3+t1s4rSHIYZJ4+/2NjNFwH/Nlv8ihdvsN00Pkf+zT3lflSOTyHOmazFuWBfL
         GB/gpbvhoAJuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9DE56531E;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sysctl: remove redundant #ifdef CONFIG_NET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179621188.21299.6314892122372378958.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:10:11 +0000
References: <20210125231421.105936-1-masahiroy@kernel.org>
In-Reply-To: <20210125231421.105936-1-masahiroy@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk, rdna@fb.com,
        davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        maheshb@google.com, nicolas.dichtel@6wind.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 08:14:21 +0900 you wrote:
> CONFIG_NET is a bool option, and this file is compiled only when
> CONFIG_NET=y.
> 
> Remove #ifdef CONFIG_NET, which we know it is always met.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: sysctl: remove redundant #ifdef CONFIG_NET
    https://git.kernel.org/netdev/net-next/c/69783429cd13

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


