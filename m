Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6084A466F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351781AbiAaL4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379363AbiAaLxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:53:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2B6C0797AA
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7687BB82A91
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F687C36AEA;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629211;
        bh=S9PuXRYLscVm9Urry9Sq4McC/RWBbqNUphES+vMxpUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ek35IhZpbs+7NiXFbmSTDCel2bJXIxf1cP4fApm4TLksEeIyMXxnlce/GeQ0omOch
         OjXoLs0goXOw7DxncHfsEsGlfo7C6GAm0sz4LmxJ0+3ytpbSL7so+3UMz5zXzIz+A2
         xzIVjKrApMSH5XiQ+7nOXBwpUZnOqEki3bT2J+cWQL4QoD8K+3FYOIB+w3wuf14XKA
         BmrDGmMqMSpFJmm9rg13EGOFuSJgX4M3cqJTTZRJYoCw/sg0YpOkZydU39YxaPAXNo
         JgFpUVsBJX2ARmO8meUkfzT6FoD8Flx+awnvNCpCGQKdfnKDr/BXsaQlsk5DB/9CHL
         OKE+lXkYXy4kw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F89EE6BB76;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv4: Make ip_idents_reserve static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362921106.6327.10011088770379149896.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:40:11 +0000
References: <20220128235347.40666-1-dsahern@kernel.org>
In-Reply-To: <20220128235347.40666-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 16:53:47 -0700 you wrote:
> ip_idents_reserve is only used in net/ipv4/route.c. Make it static
> and remove the export.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/ip.h | 1 -
>  net/ipv4/route.c | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] ipv4: Make ip_idents_reserve static
    https://git.kernel.org/netdev/net-next/c/47ed9442b2ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


