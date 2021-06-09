Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7953A204E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFIWm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhFIWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4386D613F4;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278425;
        bh=zWC0pQDcIKsW6MIYVJ/lpHWyYi4fzDSlTqhkuyeX5lk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+2zkiVyDmV1UHJhVKMOSSg5D6FjKxFL3ljivG+1qLnGhZVco4L+XlSRiU/vIy02b
         TvfbGRXWjte92ZGZ2g0+hZpWIm1ze7jlwHOgfTjsbmwU0GER6hNP1InaeMwwiKg6nz
         TiXYoMhiKYbYOgAc51tpHUUj+MdaPftUZr+P3ZjSLAKFmV7kWfe+bfgnpwYFpZvIIu
         dhqI0xK8UtUBZ2zss1gyDwCMfdM3atalHaXdtUq2tleF2wHBZ3OOXdkBAke62/gXBa
         MFceqGCFgVXQJfSml/YnjIEbj9JvhUcxf7bxL3pI0iEHRAax8jh3/M6j6bzbuJACWo
         s0T7nDKtyF3yQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 345B360A16;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: rmnet: Always subtract MAP header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842521.25473.11032833713381811263.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:25 +0000
References: <20210609143249.2279285-1-kristian.evensen@gmail.com>
In-Reply-To: <20210609143249.2279285-1-kristian.evensen@gmail.com>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, sharathv@codeaurora.org,
        stranche@codeaurora.org, subashab@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 16:32:49 +0200 you wrote:
> Commit e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5
> checksum offload") broke ingress handling for devices where
> RMNET_FLAGS_INGRESS_MAP_CKSUMV5 or RMNET_FLAGS_INGRESS_MAP_CKSUMV4 are
> not set. Unless either of these flags are set, the MAP header is not
> removed. This commit restores the original logic by ensuring that the
> MAP header is removed for all MAP packets.
> 
> [...]

Here is the summary with links:
  - net: ethernet: rmnet: Always subtract MAP header
    https://git.kernel.org/netdev/net-next/c/8b8701d0b492

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


