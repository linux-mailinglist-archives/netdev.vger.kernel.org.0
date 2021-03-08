Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE5331AF6
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhCHXaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 18:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhCHXaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 18:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D32BB6527D;
        Mon,  8 Mar 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615246207;
        bh=8gZXx9QO4EzwmFshOMlCezfnEJ6cCSECVYl2qIl2V+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6Jo1NQ+n0uib6ZLbroLr0q3GqKuuvG69uGF7FwTohxl5YurepHECk+He46sCEGa0
         HpUFoZB3tXBctUdZe8HNw407cYt40e5wq+zhI9y3nqJHtRjEdTM9ndRvUDgniysSCo
         P4qmQFCT8fwVXY9s0ZP96TgDMAsmmpnEcA2ys7ADo3eJpNplzmmL/7k0eMHE6iKgEz
         U/2j91fPpkhXdj/I2jk10hqUrtyITPzjXglrblnQsOflazlCoe7P3AD++W7r41k/LL
         MKR58kNJult8NNAgeNL/8C0R89XUnXHxbMziYehnuDVsBvkRf37P2FkIj0qTkOI9zw
         2I3zjrGI+OZeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2E8F6098E;
        Mon,  8 Mar 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] fix a couple of atm->phy_data related issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161524620779.17053.16108996062074686102.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 23:30:07 +0000
References: <20210308032529.435224-1-ztong0001@gmail.com>
In-Reply-To: <20210308032529.435224-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 22:25:27 -0500 you wrote:
> there are two drivers(zatm and idt77252) using PRIV() (i.e. atm->phy_data)
> to store private data, but the driver happens to populate wrong
> pointers: atm->dev_data. which actually cause null-ptr-dereference in
> following PRIV(dev). This patch series attemps to fix those two issues
> along with a typo in atm struct.
> 
> Tong Zhang (3):
>   atm: fix a typo in the struct description
>   atm: uPD98402: fix incorrect allocation
>   atm: idt77252: fix null-ptr-dereference
> 
> [...]

Here is the summary with links:
  - [1/3] atm: fix a typo in the struct description
    https://git.kernel.org/netdev/net/c/1019d7923d9d
  - [2/3] atm: uPD98402: fix incorrect allocation
    https://git.kernel.org/netdev/net/c/3153724fc084
  - [3/3] atm: idt77252: fix null-ptr-dereference
    https://git.kernel.org/netdev/net/c/4416e98594dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


