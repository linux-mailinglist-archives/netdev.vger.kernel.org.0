Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C936169F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhDPAAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhDPAAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 20:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C22F610C8;
        Fri, 16 Apr 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618531209;
        bh=F6xOFnuV1QeRbiV3uIfCKl1BWknRu9X4sFBfVi3IJ6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WxX9ctowrEWglqVrgmFYb39gZiwrdBFlhwE0ME1pJRJizOMw/1VM73CRMhKFi+7FH
         s8n4AYSQnVa9ePq3RRbqIqrAe2pPD0bJSh6A38W5KP4d/2QkSezRISE1xpC9KxTP9u
         URXMWBlN1gibn6sNGXgC+vi1I6flVtoJFRtMSdGO7xX2K4gcZq0SjcFXMBrB+HjNrL
         WckSURK+Ms5DFWkd+2NUurmsHvxOwgGsIhNKu2XK+gx3kUgjKW8al7axj/GuU1xTvP
         eVpCaCT/9oGZcxWj4PjbTFQtGLazrSQtz+AWuhUQOxLJ8h9ZZRdZMFEesDSLoVOliR
         TnEOFTARvY2lg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1814D60A0D;
        Fri, 16 Apr 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] chelsio/ch_ktls: chelsio inline tls driver bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853120909.2137.2340381835451346051.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 00:00:09 +0000
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, secdev@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Apr 2021 13:17:44 +0530 you wrote:
> This series of patches fix following bugs in Chelsio inline tls driver.
> Patch1: kernel panic.
> Patch2: connection close issue.
> Patch3: tcb close call issue.
> Patch4: unnecessary snd_una update.
> 
> Vinay Kumar Yadav (4):
>   ch_ktls: Fix kernel panic
>   ch_ktls: fix device connection close
>   ch_ktls: tcb close causes tls connection failure
>   ch_ktls: do not send snd_una update to TCB in middle
> 
> [...]

Here is the summary with links:
  - [net,1/4] ch_ktls: Fix kernel panic
    https://git.kernel.org/netdev/net/c/1a73e427b824
  - [net,2/4] ch_ktls: fix device connection close
    https://git.kernel.org/netdev/net/c/bc16efd24306
  - [net,3/4] ch_ktls: tcb close causes tls connection failure
    https://git.kernel.org/netdev/net/c/21d8c25e3f4b
  - [net,4/4] ch_ktls: do not send snd_una update to TCB in middle
    https://git.kernel.org/netdev/net/c/e8a4155567b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


