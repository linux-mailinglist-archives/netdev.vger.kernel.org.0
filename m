Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B2036CDB4
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbhD0VKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239012AbhD0VKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E355E613F5;
        Tue, 27 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619557809;
        bh=TlOXYuXipgjZRvoZpPwj+muhn1wMARmKhSxWor8+Oes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MVSeeaS7RjW7OkFqLBcKksmFZf5O8ZhOWV8R+PLkadqgKReJSMKf/JX/SXBqdxytx
         YuzaWjiEGSbMdPsgw2VemVIewAyQpJMbT6VsFxaDSZI2p+GrzKFLyFrHp9dlegUMoF
         feumi1QRZi/fdNC0R3g0zwNEyQbI50Y/FJuxWWL347G3h5+WD0lvZKXaTShES0x2gp
         /Gb7qnp/50L28Mlmkmo2xy3f9x/WIyUvutTx6SInnfyE2cAhEYu+sjr0sngoKkoiWg
         j7gYkhbDT1inLKdmGCQ3irDBtCt2NaCDJytSZAoByA2DEJ3ChTua/i03e6YG9LQDll
         763mFcdSQnGkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D66DA60A23;
        Tue, 27 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fddi/skfp: fix typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955780987.15707.354248024338816453.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:10:09 +0000
References: <20210426235752.30816-1-qhjin_dev@163.com>
In-Reply-To: <20210426235752.30816-1-qhjin_dev@163.com>
To:     qhjindev <qhjin_dev@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 07:57:52 +0800 you wrote:
> change 'privae' to 'private'
> 
> Signed-off-by: qhjindev <qhjin_dev@163.com>
> ---
>  drivers/net/fddi/skfp/h/smc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - fddi/skfp: fix typo
    https://git.kernel.org/netdev/net-next/c/23c9c2b314ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


