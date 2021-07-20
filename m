Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08173CFC6C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbhGTN6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239346AbhGTNt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B6C361164;
        Tue, 20 Jul 2021 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791404;
        bh=78XjQsCzhlaT3mBhK/Ro8B8ZJf2cQCvL0CHQthkVkGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GsLjpYBNbJboVGAOH57xtuYn94qhGqgQpjaZb/NWKLcHg8OD1mQeYRXfKaDnYTuMd
         8IBfcHb1GJDfXcgQXts7BK8nXsO60hEaX/w0KTnUuIvQ/6VKgtFZ7fmPv7q3JZ4zWe
         O95+uxwXsKSiADq+mVjiFChFjUAXKFJnWQTPcRwqN7VfDhueCTzBLM+NVocML9aJcN
         KQGmBYUDYs9X0zQGI2fCggNiH5d1+jkiSOVDP6arEVVslDHslTqw0YjC8jPvHbTU5g
         sWDzK62OXZHW9d+Ee+ZLoCpPZlrz6LqTMbGPxg4CZPtArCyAPBUvBylCJKSCMe7Eki
         bRR9FbUtW+lBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6DEAC60A0B;
        Tue, 20 Jul 2021 14:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix another slab-out-of-bounds in
 fib6_nh_flush_exceptions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140444.23944.9629868012437771549.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:04 +0000
References: <6f48619a725daf4bfaea7dad94504f722ab1b4f6.1626786511.git.pabeni@redhat.com>
In-Reply-To: <6f48619a725daf4bfaea7dad94504f722ab1b4f6.1626786511.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, lixiaoyan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 15:08:40 +0200 you wrote:
> While running the self-tests on a KASAN enabled kernel, I observed a
> slab-out-of-bounds splat very similar to the one reported in
> commit 821bbf79fe46 ("ipv6: Fix KASAN: slab-out-of-bounds Read in
>  fib6_nh_flush_exceptions").
> 
> We additionally need to take care of fib6_metrics initialization
> failure when the caller provides an nh.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions
    https://git.kernel.org/netdev/net/c/8fb4792f091e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


