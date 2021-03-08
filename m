Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94649331AD8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 00:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhCHXKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 18:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhCHXKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 18:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B028160C3D;
        Mon,  8 Mar 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615245007;
        bh=xbGpHXfggTI/Ebq8WUHZ1hxOgcbsxF09cw40IR0zTcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M66O0aes8tKOr7XyAqk2DZj6e0e8DHfRalersBR81vlp23kEZh1eLUcVSviZXjy+9
         QSQhiUTphGH3IjglvMpQX3Ljb2BNld+kHnpXSHAq4uetzVFzBJ3H5c+32wfKixZEs0
         c4ZM77JfTxoEWkvj+ceOlTcDqO1gcm1TD82NVW5pivnmGn2RqFME1AdPR0x9QZnUim
         dbN4FgIa5hvoTGu5o0BHr9ftHX7z5Cmu4Rs4pfrLIhe9HQRxaSvpb77pQtf2dr9Gvy
         Bd/RlS9RVVDVSmd/5UreYdgrVg59OIE2tEnFbPzeGTwfHlviN6L4fAYv6n1JDOhnbk
         KDePti1x9h/zw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9EFB1609DA;
        Mon,  8 Mar 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: fix length of ADD_ADDR with port sub-option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161524500764.8251.2830359116864468951.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 23:10:07 +0000
References: <66b3a2eec724af07ffdb04fefc6c7d50b85f296b.1615191605.git.dcaratti@redhat.com>
In-Reply-To: <66b3a2eec724af07ffdb04fefc6c7d50b85f296b.1615191605.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, stable@vger.kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  8 Mar 2021 10:00:04 +0100 you wrote:
> in current Linux, MPTCP peers advertising endpoints with port numbers use
> a sub-option length that wrongly accounts for the trailing TCP NOP. Also,
> receivers will only process incoming ADD_ADDR with port having such wrong
> sub-option length. Fix this, making ADD_ADDR compliant to RFC8684 §3.4.1.
> 
> this can be verified running tcpdump on the kselftests artifacts:
> 
> [...]

Here is the summary with links:
  - [net] mptcp: fix length of ADD_ADDR with port sub-option
    https://git.kernel.org/netdev/net/c/27ab92d9996e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


