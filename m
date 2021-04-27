Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1236CEB1
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhD0Wk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235420AbhD0Wky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 18:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DE13611F2;
        Tue, 27 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619563210;
        bh=WpoBdws40s0ptUiWd2wf5ZMreUQMpAaFhxEbKG9nC9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=haI2X0aXC9v7KLVXP3PaHWjZq5gsqATM921KbWk63fVdEUBk+Li+NHVdGlhwQALC2
         y5f9iKtf1v7YLsE1x8IupFiLDy5uXpPyWRnZkpEvds1D7W3D8lKVVuvMD9j38eCigS
         XLCCCYbXlW7nG9oswkPzDbA5SJRl5psLmwm8YqyNS4hVOrXG1+OnILwxYZ4t0i2NHH
         /1l/jZvW2Ft6Vz1Or9NFY7vmu7azuO33NHoEIyw7BD2KiGDY7vEJfzH7EYHvT5q5eb
         mThRv7IuJeZT2QbaEFLWEz7aY/iGH2Quwt//U+eaYflL8WriMqm09EcMAE6DVpLT3K
         p8Uef66V7OMMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 61515609B0;
        Tue, 27 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/7] netfilter: nftables: rename set element data
 activation/deactivation functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161956321039.28898.12248117195922527285.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 22:40:10 +0000
References: <20210427204345.22043-2-pablo@netfilter.org>
In-Reply-To: <20210427204345.22043-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 22:43:39 +0200 you wrote:
> Rename:
> 
> - nft_set_elem_activate() to nft_set_elem_data_activate().
> - nft_set_elem_deactivate() to nft_set_elem_data_deactivate().
> 
> To prepare for updates in the set element infrastructure to add support
> for the special catch-all element.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] netfilter: nftables: rename set element data activation/deactivation functions
    https://git.kernel.org/netdev/net-next/c/f8bb7889af58
  - [net-next,2/7] netfilter: nftables: add loop check helper function
    https://git.kernel.org/netdev/net-next/c/6387aa6e59be
  - [net-next,3/7] netfilter: nftables: add helper function to flush set elements
    https://git.kernel.org/netdev/net-next/c/e6ba7cb63b8a
  - [net-next,4/7] netfilter: nftables: add helper function to validate set element data
    https://git.kernel.org/netdev/net-next/c/97c976d662fb
  - [net-next,5/7] netfilter: nftables: add catch-all set element support
    https://git.kernel.org/netdev/net-next/c/aaa31047a6d2
  - [net-next,6/7] netfilter: nft_socket: fix an unused variable warning
    https://git.kernel.org/netdev/net-next/c/8a7363f84979
  - [net-next,7/7] netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n
    https://git.kernel.org/netdev/net-next/c/7acc0bb490c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


