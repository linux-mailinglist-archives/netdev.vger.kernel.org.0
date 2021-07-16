Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8F3CBB82
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhGPSDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPSC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 14:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AB6D60FE7;
        Fri, 16 Jul 2021 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626458404;
        bh=HR0EPu4I4fAtF+CH9meyfNw4H8tGQn+xG98MPHGMjio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=meNyz9C58E0I8utMVyNbYBUcYW5FstgDc8Ka7dGCyjqBuBXJKEJ+hMJL7Eh7NIfZb
         fogRpI95K1dylhd5yCbsGdHMuDCxo+mc6wRjPI59AwIIs+JbMKZDxP4QGLLUn+I8H8
         hR3A7gUyMahx14tNI+uAoK8fUBS20N2wN/oT7zFhIcJNPshqDiArc5Si0Kb/KS1IMX
         yE+hD6q/OoXzCk3MEKa4pWRTRl6j57Rvr/X2KHE3poZB7jndq29KkNw+wZaC3xEfy6
         M/cEiopoaCpFGCsAEOef9gMMgqDvwOxpMAQsA7ud4RTMjGJTGblfJrx017aHkT53YY
         ZXgRYkoPSii8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BEB26097A;
        Fri, 16 Jul 2021 18:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: switchdev: Simplify 'mlxsw_sp_mc_write_mdb_entry()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162645840450.5805.1190880775942278823.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 18:00:04 +0000
References: <fbc480268644caf24aef68a3b893bdaef71d7306.1626251484.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <fbc480268644caf24aef68a3b893bdaef71d7306.1626251484.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Jul 2021 10:32:33 +0200 you wrote:
> Use 'bitmap_alloc()/bitmap_free()' instead of hand-writing it.
> This makes the code less verbose.
> 
> Also, use 'bitmap_alloc()' instead of 'bitmap_zalloc()' because the bitmap
> is fully overridden by a 'bitmap_copy()' call just after its allocation.
> 
> While at it, remove an extra and unneeded space.
> 
> [...]

Here is the summary with links:
  - net: switchdev: Simplify 'mlxsw_sp_mc_write_mdb_entry()'
    https://git.kernel.org/netdev/net-next/c/a99f030b2488

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


