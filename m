Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D873662E8
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhDUAKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234446AbhDUAKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9169761428;
        Wed, 21 Apr 2021 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963810;
        bh=M98/mV4ACEJRSScS93rjGBHBjNPw40xcPHUVzCL4wjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T7uNzh2fZE+5pwwJe/L6yuhdAz3kNzDBlII8KUIksQVy1uFAgOIZt4sFipwNRi7HR
         62/iGARUhziodB2GJM91zbfsBALpnKbbx/4NfghbIhQ7xosMom/axzw9meFLaqIt8G
         Vw4hJyJeTgggtSx9nFuAYuLNnO5qHO7zhIejDlfktXJ+YvVeNz/x6Gk0OyxaY8piMw
         apmOK53uStgz+XSJlLR1nHO/tDvbiTS8i0IktDt3L0mZ9+sWk/GY9krbRQ7PiqTeXR
         W2K/0FWKfnzlKKY9cHy5WaVb8h38Maz118MtwhrEuV705fDQSHQynzQQpGlctv/OB7
         Ag7eXsD/nnJNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A86060A3C;
        Wed, 21 Apr 2021 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: mana: remove redundant initialization of variable
 err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896381056.7038.9449243097792804835.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:10:10 +0000
References: <20210420122730.379835-1-colin.king@canonical.com>
In-Reply-To: <20210420122730.379835-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 13:27:30 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is
> never read and it is being updated later with a new value.  The
> initialization is redundant and can be removed
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] net: mana: remove redundant initialization of variable err
    https://git.kernel.org/netdev/net-next/c/55cdc26a91ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


