Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B637645E69C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357909AbhKZDpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235958AbhKZDnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:43:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EDA861058;
        Fri, 26 Nov 2021 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637898010;
        bh=/aPaDeQeDopk0whcvWBRjljNt9uMKg7tQtfoKe+NwA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SOw5BImxJblHvbP/efI4jfiNL0JyumV94rh1H6a6MtCUQ59QFnNbwupcYMoflzLGH
         3rXD5dW4ky3ch8GqacVywj0X4ihCE1kWbnXsDdmPxN+VoAezIOFB9FspOeA90e4h6X
         E5T2zr5f830brGnzGhE/nIxxFca4t7EBTIoqDX3oONfeCkoEvprHd3R91mbt/5MtF1
         ED40Vw/nisrbJBDL1ksEeWZsV6yeLxwL4JONtc3cOl5N+EgAMLw8yDV7E3bvvvoPiX
         OFHNLkvK9l23wEY3dnBsNjqgEGxDE7PaUF5FRdRXdR4iUt9cLHufV7dUNhrD/VZlFz
         uoTrFEQ51X37A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F379609B9;
        Fri, 26 Nov 2021 03:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/9] tls: splice_read fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789801005.11827.6777069980777661670.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:40:10 +0000
References: <20211124232557.2039757-1-kuba@kernel.org>
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 15:25:48 -0800 you wrote:
> As I work my way to unlocked and zero-copy TLS Rx the obvious bugs
> in the splice_read implementation get harder and harder to ignore.
> This is to say the fixes here are discovered by code inspection,
> I'm not aware of anyone actually using splice_read.
> 
> Jakub Kicinski (9):
>   selftests: tls: add helper for creating sock pairs
>   selftests: tls: factor out cmsg send/receive
>   selftests: tls: add tests for handling of bad records
>   tls: splice_read: fix record type check
>   selftests: tls: test splicing cmsgs
>   tls: splice_read: fix accessing pre-processed records
>   selftests: tls: test splicing decrypted records
>   tls: fix replacing proto_ops
>   selftests: tls: test for correct proto_ops
> 
> [...]

Here is the summary with links:
  - [net,1/9] selftests: tls: add helper for creating sock pairs
    https://git.kernel.org/netdev/net/c/a125f91fe783
  - [net,2/9] selftests: tls: factor out cmsg send/receive
    https://git.kernel.org/netdev/net/c/31180adb0bed
  - [net,3/9] selftests: tls: add tests for handling of bad records
    https://git.kernel.org/netdev/net/c/ef0fc0b3cc2b
  - [net,4/9] tls: splice_read: fix record type check
    https://git.kernel.org/netdev/net/c/520493f66f68
  - [net,5/9] selftests: tls: test splicing cmsgs
    https://git.kernel.org/netdev/net/c/d87d67fd61ef
  - [net,6/9] tls: splice_read: fix accessing pre-processed records
    https://git.kernel.org/netdev/net/c/e062fe99cccd
  - [net,7/9] selftests: tls: test splicing decrypted records
    https://git.kernel.org/netdev/net/c/274af0f9e279
  - [net,8/9] tls: fix replacing proto_ops
    https://git.kernel.org/netdev/net/c/f3911f73f51d
  - [net,9/9] selftests: tls: test for correct proto_ops
    https://git.kernel.org/netdev/net/c/f884a3426291

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


