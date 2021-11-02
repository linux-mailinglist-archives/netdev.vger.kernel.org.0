Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5944318B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhKBP1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231721AbhKBP1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DBF860EB4;
        Tue,  2 Nov 2021 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635866686;
        bh=UkpnBxxnc0JtmGTSu3z4d5IPFChohRwK9zXw9/D5//8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T6WbKjGe62eEw6373Iq4w0EneZg+7aRMclMiisVu0hogNu0JoLBGx+3VdiagZgyKG
         SOD27nwjRd0PLh21NZCJX4nR0rVrXoHd8NqnD1adeglqgyqas9qyIakWDCzqNAj9UE
         aiWa1X1PnhwoS54+iBtAHdK+T228ML5UQU1/06tsSvrnMYnor0rfvqzOyvbYRUd+LE
         PpIEwprPxsQvTOr1RAVcMPDytvCsuJzRcHfXZBSIFTobUa/vsmx6fyqo0NSSiciTF8
         dSVYzjmwToGcvqMhriwpUSv3QzRpjWQvXLxqQn50NNon/0hC0ZFjgpXH3QKq4l/Iwi
         6zI0R0i/lcMeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F83160BE4;
        Tue,  2 Nov 2021 15:24:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163586668632.17300.4029101870051803664.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 15:24:46 +0000
References: <20211102054237.3307077-1-kuba@kernel.org>
In-Reply-To: <20211102054237.3307077-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, kvalo@codeaurora.org,
        miriam.rachel.korenblit@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Mon,  1 Nov 2021 22:42:36 -0700 you wrote:
> Hi Linus!
> 
> Networking changes for the 5.16 merge window.
> 
> We have a small conflict/adjacent change between our:
> 
>   dc52fac37c87 ("iwlwifi: mvm: Support new TX_RSP and COMPRESSED_BA_RES versions")
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.16
    https://git.kernel.org/netdev/net/c/fc02cb2b37fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


