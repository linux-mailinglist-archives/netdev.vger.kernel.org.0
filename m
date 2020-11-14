Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0895C2B2A0A
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKNAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKNAkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314405;
        bh=w6h8b7hS2kWy4OnBfJIh/gLH+gVgP9ATvgxn7m4SlxQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C1vU04tBi0DkxFC9Hl3CEnd3wSRORSoAsZ6ZV+R1odrDp2GnnK28/OoZQnUZJY7it
         wDfNEm5/cEsOepKfzzoTpXaylLPqmtiAyjehC/kbH0xqSOIpwxciw34Wzl+5yeicg0
         sVz3aUFyd16qTS9socoEVFG8rNRY+a6UzmlbRd0k=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use READ_ONCE in rtl_tx_slots_avail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160531440548.7757.3577585103411501268.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 00:40:05 +0000
References: <5676fee3-f6b4-84f2-eba5-c64949a371ad@gmail.com>
In-Reply-To: <5676fee3-f6b4-84f2-eba5-c64949a371ad@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Nov 2020 22:14:27 +0100 you wrote:
> tp->dirty_tx and tp->cur_tx may be changed by a racing rtl_tx() or
> rtl8169_start_xmit(). Use READ_ONCE() to annotate the races and ensure
> that the compiler doesn't use cached values.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] r8169: use READ_ONCE in rtl_tx_slots_avail
    https://git.kernel.org/netdev/net-next/c/95f3c5458dfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


