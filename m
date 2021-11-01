Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35AB441B84
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhKANMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231880AbhKANMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DDA0560FE8;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772210;
        bh=vH/clyqhqEERJEsBz/fHzo9jIYxPNNBWZI3e1gNCfOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uAf9n8UzxP0NL3x6eqeTSDgW/qyhsyA4mHU8Baw48P85t17oMy/bi17VsW06S1Nri
         vqqpNTKb9wvJEENs4T7MFxqZa8su3cfxkTHYnIh9j2WzKgwJLoMy6Uo6tXaTr2+BCG
         NUhremsTq1Uj7aMshTllKaZaYXRL/Flx6NY8OHvaBEjO/8kWj1YPQELmW2LwB0UHTq
         LZWQTWzEigK3Ug9nE7p86R/1Npeg4WsVIx59SB4SId7Z4dY62bRAP5C2m9zIyoDkUo
         uGp7Qh63x6f2ldiM4QYA7GXQlqKgfi0kvTRiUD4v88b0sBoBsKUg2ZE2DZsAlUWCE/
         wuNkj1x5kGN9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B945660A94;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] netfilter: ebtables: use array_size() helper in
 copy_{from,to}_user()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577220975.25752.12348298706166739820.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:10:09 +0000
References: <20211101083940.51007-2-pablo@netfilter.org>
In-Reply-To: <20211101083940.51007-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon,  1 Nov 2021 09:39:36 +0100 you wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> Use array_size() helper instead of the open-coded version in
> copy_{from,to}_user().  These sorts of multiplication factors
> need to be wrapped in array_size().
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] netfilter: ebtables: use array_size() helper in copy_{from,to}_user()
    https://git.kernel.org/netdev/net-next/c/241eb3f3ee42
  - [net-next,2/5] netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
    https://git.kernel.org/netdev/net-next/c/b7b1d02fc439
  - [net-next,3/5] netfilter: nft_meta: add NFT_META_IFTYPE
    https://git.kernel.org/netdev/net-next/c/56fa95014a04
  - [net-next,4/5] netfilter: nf_tables: convert pktinfo->tprot_set to flags field
    https://git.kernel.org/netdev/net-next/c/b5bdc6f9c24d
  - [net-next,5/5] netfilter: nft_payload: support for inner header matching / mangling
    https://git.kernel.org/netdev/net-next/c/c46b38dc8743

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


