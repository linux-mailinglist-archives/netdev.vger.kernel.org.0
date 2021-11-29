Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B254617A7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244340AbhK2OQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhK2OOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:14:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB5C08EADF
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:50:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C66D61451
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:50:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A61E760E96;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190209;
        bh=CRXwGVgqdDCRJGDmHSwAk8814TjqUR/0DH7iDcuT7kw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q2D4GCj9Qof+RsBd2fej8BDD75SnpyK+6nue8yIEnEx+Xb/xZJ9UakVNN4Ddx+GWT
         7EO/bK6G4HEuk72M87DyeO1h8812S/Yl2VEmZ0x86kBjTqC4oy5bF6Wh4b9gkz2p0M
         mV0rswd4+MzE6L157kVfTxH/Cz/2kblGleVBDIPYGOnbUolNq5bRZd3rSRneQEszHY
         pN1lHeb9eP2KayniHZhYFKhb6RAhu9od7dLYkvmwDkTbKlZkvWq3GQadAg8t1KXYOK
         T/anW8yWx7IqRC/mOkKrwu6l784y2+WXldSgEDM4Ny9gBpcA893RMRiKNqnRG8Q1X0
         ePgSWqOgzLLFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FC7060A45;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: mpls: Cleanup nexthop iterator macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819020964.1533.11493629299483124771.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:50:09 +0000
References: <20211129062316.221653-1-bpoirier@nvidia.com>
In-Reply-To: <20211129062316.221653-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, l4stpr0gr4m@gmail.com,
        jiapeng.chong@linux.alibaba.com, netdev@vger.kernel.org,
        roopa@nvidia.com, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 15:23:14 +0900 you wrote:
> From: Benjamin Poirier <benjamin.poirier@gmail.com>
> 
> The mpls macros for_nexthops and change_nexthops were probably copied
> from decnet or ipv4 but they grew a superfluous variable and lost a
> beneficial "const".
> 
> Benjamin Poirier (2):
>   net: mpls: Remove duplicate variable from iterator macro
>   net: mpls: Make for_nexthops iterator const
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: mpls: Remove duplicate variable from iterator macro
    https://git.kernel.org/netdev/net-next/c/69d9c0d07726
  - [net-next,2/2] net: mpls: Make for_nexthops iterator const
    https://git.kernel.org/netdev/net-next/c/f05b0b97335b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


