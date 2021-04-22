Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E56C3687F2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhDVUar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239499AbhDVUao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7EC75613FA;
        Thu, 22 Apr 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619123409;
        bh=enM0rovdB1qilMqAmQhxHxL8yzo1B9KVuh5FnWQYdQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJ/0f54WLk5v4BtYkA9SBC/gxN1njGZ46DqVWLBqvNFsb1gQN+DTUaR8RdW1dulDb
         sTsi1lvxEbN65mbNi4CJQrdfQ2UJ9acskIK5SrhobB7IenfVUDXdp0RjjkUUhdVvLG
         sbmMj7xDPjuiYt26xecQLhP6Rf6DOHrzpk1/oKLk9avuh0xGNGakxQ02bOBwdqR411
         reD8sQSUq8Bm4IDlP0uIQzvbCCfBqQRE80YlfLKoL6QwdrmSeh6Ex32E0tDnTvCDVo
         n+F+pyuEiuoiHb0YAxP1sK3RInh3Wx3mzM1gu+yeUWWKxfCf8TRybHWucSYM3tB/fF
         kGH6LInoLFBWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74CC460A52;
        Thu, 22 Apr 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: phy: marvell: fix set downshift params
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912340947.26269.15531453661865141776.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 20:30:09 +0000
References: <20210422104644.9472-1-fido_max@inbox.ru>
In-Reply-To: <20210422104644.9472-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Apr 2021 13:46:42 +0300 you wrote:
> Changing downshift params without software reset has no effect,
> so call genphy_soft_reset() after change downshift params.
> 
> Maxim Kochetkov (2):
>   net: phy: marvell: fix m88e1011_set_downshift
>   net: phy: marvell: fix m88e1111_set_downshift
> 
> [...]

Here is the summary with links:
  - [1/2] net: phy: marvell: fix m88e1011_set_downshift
    https://git.kernel.org/netdev/net/c/990875b299b8
  - [2/2] net: phy: marvell: fix m88e1111_set_downshift
    https://git.kernel.org/netdev/net/c/e7679c55a724

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


