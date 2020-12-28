Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4649E2E6C2C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgL1Wzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgL1WUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 104B62226A;
        Mon, 28 Dec 2020 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609194007;
        bh=tfGQI40IV6gNxpQsjOCOexr7MQ64FTop+OrhLe9/FwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C2xc2g3MF3igEo6iZkjTw3xJiWyU33vYbKHcnKRdws3zyohm/CtnSXLDrB38koqFb
         WX2CaHX1timnPRcJgcHQLVmECmYUZLF0U47KwfVeABoUgi+M2zOVMIVOv4ReGVV0yN
         Fs9OOx5OoP1qk02/FR7IHBbUHNceL7gywOu0OmFyDBxp5kf6m3Xi2m494qr4LTjnuP
         eMXcmenDG+pB2GgezkImT1Gr4gHWsXE2tGwcK8Q6Zw4SvVBUZMuS7NUK3fNpeXwBzI
         9mc2tD724jMVtMHx8bmgffnUFDho1+PPg4AG5qkC1SR+u0MS8Gs5MtIxfs1DyzmxI8
         HFAxbzMXetTZw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 02BF160591;
        Mon, 28 Dec 2020 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: Bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160919400700.29691.12531949239256214537.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Dec 2020 22:20:07 +0000
References: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 27 Dec 2020 14:18:16 -0500 you wrote:
> The first patch fixes recovery of fatal AER errors.  The second one
> fixes a potential array out of bounds issue.
> 
> Please queue for -stable.  Thanks.
> 
> Michael Chan (1):
>   bnxt_en: Check TQM rings for maximum supported value.
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Fix AER recovery.
    https://git.kernel.org/netdev/net/c/fb1e6e562b37
  - [net,2/2] bnxt_en: Check TQM rings for maximum supported value.
    https://git.kernel.org/netdev/net/c/a029a2fef5d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


