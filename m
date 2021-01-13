Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170DD2F42E4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAMEKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAMEKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5752E2312E;
        Wed, 13 Jan 2021 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511009;
        bh=XNGVhzdi/X3V5r1uz1q2XrNcCW0KPxFf+HNYg8L+3c4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WREwutCuDDpr7ljECPpnwuczb1C9EvI7DXTJuPlUw1/i49Xkv3NNcihkPU1WzTov1
         F5Ug9vz5FXJhmUOWYxWoqEb46UxoYJZ2ImEK+u/FY1xuh3ULH+C0dZc0EDIf/TV2Fb
         Q6v2rnCxGmLECY+BuZ0+JXMiN30KIrCl42FZdyXaFVgEPMRUG0xLAQBC1Otd7ylbNK
         QUdPHaQq/RoQZTUg3HP4TReTP55zhkK4S6py24BnHRWG7QCf10DDB3NDBa/ztrWahu
         f8fIsIQwXYGylUBsVXbkezs7z6c3fTETHlP+LNwsabbjh8m/q1eS+DKxI7avZ3htHE
         0CHRkfe/9AZjA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 49CBA60156;
        Wed, 13 Jan 2021 04:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] r8152: Add Lenovo Powered USB-C Travel Hub
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051100929.28597.11266832890595155753.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:10:09 +0000
References: <20210111190312.12589-2-leon@is.currently.online>
In-Reply-To: <20210111190312.12589-2-leon@is.currently.online>
To:     Leon Schuermann <leon@is.currently.online>
Cc:     kuba@kernel.org, oliver@neukum.org, davem@davemloft.net,
        hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 11 Jan 2021 20:03:13 +0100 you wrote:
> This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
> use the cdc_ether driver. However, using this driver, with the system
> suspended the device constantly sends pause-frames as soon as the
> receive buffer fills up. This causes issues with other devices, where
> some Ethernet switches stop forwarding packets altogether.
> 
> Using the Realtek driver (r8152) fixes this issue. Pause frames are no
> longer sent while the host system is suspended.
> 
> [...]

Here is the summary with links:
  - [1/2] r8152: Add Lenovo Powered USB-C Travel Hub
    https://git.kernel.org/netdev/net/c/cb82a54904a9
  - [2/2] r8153_ecm: Add Lenovo Powered USB-C Hub as a fallback of r8152
    https://git.kernel.org/netdev/net/c/2284bbd0cf39

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


