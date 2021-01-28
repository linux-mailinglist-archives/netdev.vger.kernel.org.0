Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60385306ADC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhA1CBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhA1CAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BEA860C41;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611799211;
        bh=XGX39uN1KfuyxwkOxuU/yF3gZe976IqbWYsVyi2BGJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K2pkvGilNYcJ2pKbuzMEGQgWHhQE47aiT/DOctW2sM6UwwcGel1Nm8hqkTDuZ97Fd
         Do6lOBJPx+eeW28FnmxvGCM5hLw/PxMsHen10Pngh7coixcRjmBSouerdGVQ+VsSpa
         xIN6XuHwQGKrIH+N4wTK1oNAA71LADlX8SxrKGQ3/F3JUqYJuNtwH7GSbot1ckSWYs
         CV1zWAKoY9SiczNh85G/89ji85NYvlg30oD8UHfptgGcIDftsmLjIawncoeF5HJ8l2
         961fA/b43I6y2G+11TcxXwZCoYxZVOH0B+kZx7NUIU60Jn/i0k73PX765lpiuCIMeU
         NWYLNbr2YlUSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A6AF6531F;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add missing header for bonding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179921156.8807.7083028215562803748.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:00:11 +0000
References: <20210127021844.4071706-1-kuba@kernel.org>
In-Reply-To: <20210127021844.4071706-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 18:18:44 -0800 you wrote:
> include/net/bonding.h is missing from bonding entry.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] MAINTAINERS: add missing header for bonding
    https://git.kernel.org/netdev/net/c/b770753c7b08

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


