Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35BD3AF629
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFUTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFUTcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 777926128C;
        Mon, 21 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303805;
        bh=bDewSHSacD6GwjhHwx4LauGBa+CTE05QIHKwzhrFlbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FIz5Uq94KWwhXZBkrcQvW+/I/eqZWVNRxk1umnyAyRPY/OYSTputEku5v2gDoDycL
         1OUYbj8Q/k8gpmGVWwT6BsMV1D8LbOkJiJH4LFIxM8EN+NAnwpUjHL+i9AMPL5ZJJk
         lJ5fzuRjmeWXSF4omScDm3tSBHt0ljTaEy96E/8GXtUgLa+nrOm9y5iA2XjxY6DtOg
         Si08fffm07sjdc06Tio5cDKY+HFhCiFjJxjwmKzQW3kspYlXcTtIXj82JZNeY2z6kF
         DwJ6XAm4EX3RQdoeNLHNh4JXCP8GmQoelQV4Di/34Tb4QJEDjyJ5hKwD9ahgUNbuxj
         GtBbJ24TgkIKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 726CD60A02;
        Mon, 21 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] af_unix: take address assignment/hash insertion into a
 new helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430380546.11970.3084777865355706900.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:30:05 +0000
References: <20210619035033.2347136-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20210619035033.2347136-1-viro@zeniv.linux.org.uk>
To:     Al Viro <viro@ZenIV.linux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 03:50:26 +0000 you wrote:
> Duplicated logics in all bind variants (autobind, bind-to-path,
> bind-to-abstract) gets taken into a common helper.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  net/unix/af_unix.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Here is the summary with links:
  - [1/8] af_unix: take address assignment/hash insertion into a new helper
    https://git.kernel.org/netdev/net-next/c/185ab886d3fb
  - [2/8] unix_bind(): allocate addr earlier
    https://git.kernel.org/netdev/net-next/c/c34d4582518f
  - [3/8] unix_bind(): separate BSD and abstract cases
    https://git.kernel.org/netdev/net-next/c/aee515170576
  - [4/8] unix_bind(): take BSD and abstract address cases into new helpers
    https://git.kernel.org/netdev/net-next/c/fa42d910a38e
  - [5/8] fold unix_mknod() into unix_bind_bsd()
    https://git.kernel.org/netdev/net-next/c/71e6be6f7d2b
  - [6/8] unix_bind_bsd(): move done_path_create() call after dealing with ->bindlock
    https://git.kernel.org/netdev/net-next/c/56c1731b280d
  - [7/8] unix_bind_bsd(): unlink if we fail after successful mknod
    https://git.kernel.org/netdev/net-next/c/c0c3b8d380a8
  - [8/8] __unix_find_socket_byname(): don't pass hash and type separately
    https://git.kernel.org/netdev/net-next/c/be752283a2a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


