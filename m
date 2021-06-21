Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2F23AF66D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhFUTwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhFUTwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 31470610EA;
        Mon, 21 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624305004;
        bh=LTu42IgWK7x0Vd2zcq8YWTyThlj7M+1haeYTFewSHwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DeNJFopm45BuvjL4CQhuMdUWv8HLPKKMGOdgcCEi7b5EIPNazoH0zeKZkB/ZHVxVk
         FKe4B0gwY7VlL2wDk7mtrxu4V4ut/JDRcLk91dLkuq3C+Y/+CmYHiYU7jmO+/hYEkh
         /QECtnXgg5XV4Z1ZTUHsxk6dWgXuFbuVnpYSctjv4lcaCiG/v/cZQTU2efQj68nI/T
         bLzKLasYMheBtDgUmwTXEouo5He9izEtf4PkP5N2lm11gVxo1tbUnOipVl6LLroTlr
         KfUy1JUwfErt9k+nV/FxO8SdJIEhLvNrpzPl5CUnnAmjdKnBAFVQRnyLCqJXyIJrEx
         st5cFF8eX8zaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27FA16094F;
        Mon, 21 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: prevent oversized sendfile() hangs by ignoring
 MSG_MORE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430500415.22375.14566545403811647647.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:50:04 +0000
References: <20210618203406.1437414-1-kuba@kernel.org>
In-Reply-To: <20210618203406.1437414-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, davejwatson@fb.com,
        ilyal@mellanox.com, aviadye@mellanox.com, vfedorenko@novek.ru,
        seth.forshee@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 13:34:06 -0700 you wrote:
> We got multiple reports that multi_chunk_sendfile test
> case from tls selftest fails. This was sort of expected,
> as the original fix was never applied (see it in the first
> Link:). The test in question uses sendfile() with count
> larger than the size of the underlying file. This will
> make splice set MSG_MORE on all sendpage calls, meaning
> TLS will never close and flush the last partial record.
> 
> [...]

Here is the summary with links:
  - [net] tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
    https://git.kernel.org/netdev/net/c/d452d48b9f8b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


