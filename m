Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD0F4590BB
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhKVPDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239832AbhKVPDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EB95D60F94;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593210;
        bh=biH42iAtiMWPihyI1AHFoYnYBLNFW9sOi+G4pIBNQto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=luQF4YhdcPmJQzZIlOBuo5PiyGYCYnwDpzz2z/u9e8j3ZK3ZjxwIKIBHF2ACGLQ93
         MVPSBgEs99l34J/14V53oITp1ZfpM2REP43dFq+xxmFi3neHejS9nylQmanavhFviA
         SBonI58k+v9P3Mg9kEh2TvnygJENSDJ6s5KKoUXte17yzdlqi87Knporir7sVviGKs
         BKNMLdrnXKzG7giXsefwGeX1qg/WQrxoAPc+06EypeJn9KPBmINLjcQHY+UQtNjZKk
         CWuxAX0Byxp4ScBotd7lIgoTyr0Whsd0qA+FlfAwpcWI4L94z8JYzTyw+VQdKLawCg
         PJKWVJ16yGg9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCF1360A94;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Use the bitmap API to simplify some functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320990.11926.9744757405183008773.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:09 +0000
References: <5f585ae692e1045b9f12c483cdaf87ee5db9a716.1637521924.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5f585ae692e1045b9f12c483cdaf87ee5db9a716.1637521924.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 20:12:54 +0100 you wrote:
> 'cid_map' is a bitmap. So use 'bitmap_zalloc()' to simplify code,
> improve the semantic and avoid some open-coded arithmetic in allocator
> arguments.
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> [...]

Here is the summary with links:
  - qed: Use the bitmap API to simplify some functions
    https://git.kernel.org/netdev/net-next/c/5e6c7ccd3ea4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


