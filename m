Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665464506A1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhKOOYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236402AbhKOOXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:23:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FC5863241;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986011;
        bh=BEckmEs8ebSXSPj7rCFkGY7oQDcOQbeQK8wbEtkvWzc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K2QdhECxDEKTyxsJD1jP4x/rQ641wZI3hOk6pVxzrcuZrazdAghsDDoz5AIbdd0jc
         wkR0EllOaAo5wajhBGk57xjPd4Ei8GhlTsj8dKNQeDIfLP1wlklgTX6U1BRoEFMuHF
         wOFOClIfploloCWx7Ux+oJc3bZ+F7bH8aui0aRB50pgGEI5+K1ir2Qq91e88fgJlxN
         PqqT64ze42GcNEBSCZD7LAMljAywwd3liVgFYtWCTv4wgpdCh1zYqoW5ilftTwg4cY
         7A28CvtfeALxHDXo9OOTr5rzT5kXQX7UH2h1uZqwHDs7zH+EuHkI75Pvbb7x1KO2HN
         nTOayoooFv/eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 817DB60A3B;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: use ARRAY_SIZE instead of ARRAY_LEN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698601152.19991.13935763255754161880.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:20:11 +0000
References: <20211115050026.5622-1-guozhengkui@vivo.com>
In-Reply-To: <20211115050026.5622-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, moyufeng@huawei.com,
        huangguangbin2@huawei.com, sean.anderson@seco.com,
        huangdaode@huawei.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com,
        colomar.6.4.3@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 13:00:10 +0800 you wrote:
> ARRAY_SIZE defined in <linux/kernel.h> is safer than self-defined
> macros to get size of an array such as ARRAY_LEN used here. Because
> ARRAY_SIZE uses __must_be_array(arr) to ensure arr is really an array.
> 
> Reported-by: Alejandro Colomar <colomar.6.4.3@gmail.com>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> 
> [...]

Here is the summary with links:
  - hinic: use ARRAY_SIZE instead of ARRAY_LEN
    https://git.kernel.org/netdev/net-next/c/9ed941178ce9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


