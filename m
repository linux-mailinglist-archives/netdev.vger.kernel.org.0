Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C54445691
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhKDPws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhKDPwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 11:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 77A6F611C0;
        Thu,  4 Nov 2021 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636041008;
        bh=hM6EMr+/zo7tlpeD+XwPKNUGbGdKyjFEelQapB02dU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ugewNBWn5JK2fqsbUNIFFbW9BRx6a6xSeMCu57Ok4XvKdS54jZSROpAKVkSt0j9qT
         KJPyTU9ux2QpRnSQ27vXnZlfrCR2SoEa9Ofva29xZNhlob+tuR6U0F8Xxk3s4TX4oc
         IZeXxaNPBT8nvHC3/oVls6PkRjsV7OemeDQ+bc5lgmRJ6CDUbcfuJgKoqKAJHtWZKy
         x5VuvVccePlnl+hevhn9/G3xQXbF7bLDbKpv+f35yQ/9fFZVKzs/sLOUqDoPvEAOPD
         rLU1QpodsuCqcvJ6URQ91mJJCYmYJWKNvOkMWBC7qkcWzB2dZTsz2dw57avGeN3TjF
         uQyqW7n5coXzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A92F60A02;
        Thu,  4 Nov 2021 15:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 5.16 v6 0/5] iplink_can: cleaning,
 fixes and adding TDC support.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163604100843.17275.15257731307928203029.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Nov 2021 15:50:08 +0000
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  4 Nov 2021 01:44:23 +0900 you wrote:
> The main purpose is to add commandline support for Transmitter Delay
> Compensation (TDC) in iproute. Other issues found during the
> development of this feature also get addressed.
> 
> This patch series contains four patches which respectively:
> 
>   1. Correct the bittiming ranges in the print_usage function and add
>   the units to give more clarity: some parameters are in milliseconds,
>   some in nano seconds, some in time quantum and the newly TDC
>   parameters introduced in this series would be in clock period.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,5.16,v6,1/5] iplink_can: fix configuration ranges in print_usage() and add unit
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8316df6e6db4
  - [iproute2-next,5.16,v6,2/5] iplink_can: code refactoring of print_ctrlmode()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=fd5e958c494c
  - [iproute2-next,5.16,v6,3/5] iplink_can: use PRINT_ANY to factorize code and fix signedness
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=67f3c7a5cc0d
  - [iproute2-next,5.16,v6,4/5] iplink_can: print brp and dbrp bittiming variables
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0f7bb8d842b1
  - [iproute2-next,5.16,v6,5/5] iplink_can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0c263d7c36ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


