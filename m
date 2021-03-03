Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6A132C48C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392613AbhCDAPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhCCRBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 12:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A55B064EDF;
        Wed,  3 Mar 2021 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614790807;
        bh=GlpLp6hgSgh1lfq00GHEJic23eMw+Dv0Nw+gC2Vh1a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r+a0FajFHHOV4ZuIu/k25ny2bGkzo0Fo/HbtmumalLEXz07gXjiRVY3xCd2HjT6s4
         O8STBYvFkyal1arOdDVKDuaxBcoA9N6xSFPp734beajFo6tWKUEE2e4QWmgg+W1zP9
         j1g6RWHOyw9BEEWWi+jRgcw7EdhLtXAQ/TRZSsDRj7E+kki90pmbAb2gj+ZzxX/T1p
         bM4Z5pmR1RNgTIxnjNCO5rC8hgcO73zUsMhpJ0fvI51X1i+ujuNU2GE3UOh4i1t1UL
         XAjmNVHpAbl/UemlRO3hN73OKmDL6M1LJQSRiX1ti8Fub3IL4x9Ak4CR3G3dVJ78sY
         V19/RkhvxqxLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BEFA609EA;
        Wed,  3 Mar 2021 17:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: networking: drop special stable handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161479080763.4362.12115440673038425798.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 17:00:07 +0000
References: <20210303024643.1076846-1-kuba@kernel.org>
In-Reply-To: <20210303024643.1076846-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Mar 2021 18:46:43 -0800 you wrote:
> Leave it to Greg.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdev-FAQ.rst       | 72 ++-----------------
>  Documentation/process/stable-kernel-rules.rst |  6 --
>  Documentation/process/submitting-patches.rst  |  5 --
>  3 files changed, 6 insertions(+), 77 deletions(-)

Here is the summary with links:
  - [net] docs: networking: drop special stable handling
    https://git.kernel.org/netdev/net/c/dbbe7c962c3a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


