Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1353A36A9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFJVwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhFJVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E500C61407;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361805;
        bh=zH2qFq8E2MGgdNzSZehWDiTjxwridrd/ASKz2wgUt24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mgUK1DhOHs/Jtm/8o6Fe9sCS4LJwQol2mOHwpTl2QDdIZ9xa4qt7V+m1wDuJcJXyQ
         tFkwVEnw8x/bz2s7qNgd0Le9CsT+/GMkJ5SrYFXj8e65V1Eo1Na15HTng9rCgG3/bM
         DZmjXHj3PDNs7Ao+H6wfLuuBRPBDyXJgTuDD2j6T0pjxnkSPgXRzuWCMLQax+g3zjY
         ISmh53uTWHXwBrLvzHjzOqs16Yygyix+pI+ptcWAH2IhLkbwO4tsQNZopFY+6U8Eio
         usi++tCXA+kFU6HhPuV25A8nst5WbB+2o+ekOeNiu4mMG8k1RItEHpVqLHAlggx+Ed
         GVDCXzrV1Pmzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3E6060CD8;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: annotate data race in sock_error()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180586.29138.5139087497742210346.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:05 +0000
References: <20210610142737.1350210-1-eric.dumazet@gmail.com>
In-Reply-To: <20210610142737.1350210-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 07:27:37 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sock_error() is known to be racy. The code avoids
> an atomic operation is sk_err is zero, and this field
> could be changed under us, this is fine.
> 
> Sysbot reported:
> 
> [...]

Here is the summary with links:
  - [net] net: annotate data race in sock_error()
    https://git.kernel.org/netdev/net/c/f13ef10059cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


