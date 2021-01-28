Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F80306AE3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA1CBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhA1CAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BDFE64DA1;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611799211;
        bh=8fiCDHHgv91eOWUnHS0rupHR4AFo5iztWZ9eN1WOJeg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NqdIirkyVHIhzU/XezZiGYHmEUF/ztmqfh+MS9KIZXpGWz5lq83W8seARqpKY9IKb
         ilXNrKeT4RUMn4LhNM3rXcDGU27M9kXj8KDqH99UMfxj0FufkdVcvD/Xl+y4ZGRDQz
         5YP4teFbcOe3BSI/qjAOMmlbzY/5/A4mr7K37y8SO5njr5e2MciSnKZSzmj2xXrI3k
         roT9fE2A2mfny++5aMyX0YlsGEixMvPwyFsWEtbniveiym7vFDoVkmNnqpaj4Kketh
         M79vaSfEakczEzTSEf55O4qrXEcq7qjizjQDaY0EVgFk9tAo7Vt9UE4ngNUJRwYsFb
         Ztf8hFnTxxFXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7540E6531E;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_dynset: honor stateful expressions in
 set definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179921147.8807.13557541538567921003.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:00:11 +0000
References: <20210127132512.5472-2-pablo@netfilter.org>
In-Reply-To: <20210127132512.5472-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 27 Jan 2021 14:25:10 +0100 you wrote:
> If the set definition contains stateful expressions, allocate them for
> the newly added entries from the packet path.
> 
> Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h | 2 ++
>  net/netfilter/nf_tables_api.c     | 5 ++---
>  net/netfilter/nft_dynset.c        | 6 ++++++
>  3 files changed, 10 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net,1/3] netfilter: nft_dynset: honor stateful expressions in set definition
    https://git.kernel.org/netdev/net/c/fca05d4d61e6
  - [net,2/3] netfilter: nft_dynset: add timeout extension to template
    https://git.kernel.org/netdev/net/c/0c5b7a501e74
  - [net,3/3] netfilter: nft_dynset: dump expressions when set definition contains no expressions
    https://git.kernel.org/netdev/net/c/ce5379963b28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


