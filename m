Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43B82DA6D8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgLODbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgLODar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003006;
        bh=YWuNYNBtlolEkCo3WBmvfKp6aH78j3ZKeQgFN55kEIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UCG+YhSOLgt5WOqFT3P5mppBfeJH1BZxjgCC9P0E35H5cq26uenU8Lse+ZrTCbYJL
         wuz1rkYIzhTjOnetqSd5gTUKOHhhf3qeCFnUhNWg7SE8gOBopRLbXTFoudLYwRM7VP
         veNzaSaeJyMMACCxvvVp4IMEFsroiBE2Cz0RkR4NwrDR0DIMe6xQko4+0MqWYYGabp
         x9e9lsyMEY+3QwNuczPt6mE4VsRbGFQVKpAEZmk+DM0uL9cgjw4Fapox2s98slO69j
         1A5fZsVKPVR5cKwlxKy3QxTziFF2fwhq53lKscOP7qz3d05YMqdlwT8/J+Oc1ikVLm
         aWyO/EBVcHE7Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: vxget: clean up sparse warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800300681.31797.16373067427107266399.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:30:06 +0000
References: <20201212234426.177015-1-kuba@kernel.org>
In-Reply-To: <20201212234426.177015-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jdmason@kudzu.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 15:44:26 -0800 you wrote:
> This code is copying strings in 64 bit quantities, the device
> returns them in big endian. As long as we store in big endian
> IOW endian on both sides matches, we're good, so swap to_be64,
> not from be64.
> 
> This fixes ~60 sparse warnings.
> 
> [...]

Here is the summary with links:
  - [net-next] net: vxget: clean up sparse warnings
    https://git.kernel.org/netdev/net-next/c/8163962aadde

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


