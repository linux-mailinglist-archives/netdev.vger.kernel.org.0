Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC132B6C09
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgKQRkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKQRkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:40:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605634805;
        bh=isC+ZMPy8vrTfLk5FQO7sPnueNGMy5sxIVeKiKLxok0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y1I/7r7LaBhyNGXpohh3gtxYTrRHje5pkzwjiJq+xde5NbFpgqzVmiX4/OE20pHF1
         a0Ko8PqUdsxL51RcJZjyrEfNKIsAmJKBDrS0YLs9bJ24n8Ut4HIPbvnyALQHbxU5cT
         Fk55zb/cLakJ+KbYhfac/zsRJl745OuOIpepjIUk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] r8169: remove nr_frags argument from
 rtl_tx_slots_avail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160563480543.5414.13457893056796331375.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 17:40:05 +0000
References: <3d1f2ad7-31d5-2cac-4f4a-394f8a3cab63@gmail.com>
In-Reply-To: <3d1f2ad7-31d5-2cac-4f4a-394f8a3cab63@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Nov 2020 17:03:14 +0100 you wrote:
> The only time when nr_frags isn't SKB_MAX_FRAGS is when entering
> rtl8169_start_xmit(). However we can use SKB_MAX_FRAGS also here
> because when queue isn't stopped there should always be room for
> MAX_SKB_FRAGS + 1 descriptors.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] r8169: remove nr_frags argument from rtl_tx_slots_avail
    https://git.kernel.org/netdev/net-next/c/83c317d7b36b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


