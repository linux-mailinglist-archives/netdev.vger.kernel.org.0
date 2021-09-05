Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DBE40116D
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 21:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhIETvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 15:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234400AbhIETvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 15:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AB1960F9D;
        Sun,  5 Sep 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630871406;
        bh=WUen2AYBkRSCqZov2myIdmekgMpwiKnOen85YlRPNq4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SC6+lq+APCBBV3XgspY5lxpYCIvPu/CNQOmGGN5R+Brd74fJYpPsEGRys/srVm1LD
         DvXCEDNnydehKOD/rXzez5N6LnQsXz/OQ1x8AYYX86+d4ItZZdjHki/WwS6+6kusqK
         6/0rPdqoEIWDNRm82fCvXVO8i3iA0F02U/3IhAJ4ywy6VpeITuuM7wEU+cvLb9Mzno
         6mfYiYftNSHB1ToKRTHT1ITiokelv8T/+36djfMKZ+50ZNFG7Gcp4+oXrQNeA7CKT9
         U+HtqCKyawz0PF2ud+zXsp2s4xqQ3aFgJCAf7xMT1Eysa/MstyOoIHZ5BHK4r+LUu2
         ZR7rIchhpX9rA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E59F60A49;
        Sun,  5 Sep 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163087140651.29855.15194980262589527468.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 19:50:06 +0000
References: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun,  5 Sep 2021 14:10:54 -0400 you wrote:
> This series includes 3 fixes related to devlink firmware and chip
> versions.  The other 2 patches fix a UDP tunneling issue and an
> error recovery issue.
> 
> Edwin Peer (2):
>   bnxt_en: fix stored FW_PSID version masks
>   bnxt_en: fix read of stored FW_PSID version on P5 devices
> 
> [...]

Here is the summary with links:
  - [net,1/5] bnxt_en: fix stored FW_PSID version masks
    https://git.kernel.org/netdev/net/c/1656db67233e
  - [net,2/5] bnxt_en: fix read of stored FW_PSID version on P5 devices
    https://git.kernel.org/netdev/net/c/beb55fcf950f
  - [net,3/5] bnxt_en: Fix asic.rev in devlink dev info command
    https://git.kernel.org/netdev/net/c/6fdab8a3ade2
  - [net,4/5] bnxt_en: Fix UDP tunnel logic
    https://git.kernel.org/netdev/net/c/7ae9dc356f24
  - [net,5/5] bnxt_en: Fix possible unintended driver initiated error recovery
    https://git.kernel.org/netdev/net/c/1b2b91831983

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


