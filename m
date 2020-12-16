Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6402DC73B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbgLPTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388789AbgLPTdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:15 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608146407;
        bh=mH9mBnCUrWex7bj9ttc4dVZiI75M1KTG8oxdCcqZKu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aWT+8mAF7D8TvrceHrouYBVwApKuyhyBDMuihF1iNCfRFf9xifuOEsXfOzLRa0xJX
         CgCGvWZ3M3uoz67jr/HW3XsrXI4i6w3E961pGSir8kqYu3ucDANzS7EhIEuwHf143U
         3lqdfXTyQkvDPPF3mze9GHj8H5e39coK4NDta7FgeyCvFYBWTQwCD1K5atS4kyIQoL
         0JTsWOs+Tt/ugDZmFZYX01l/wUiARMJOwT5c7eAAqFWEnPGp1y56PIq9Esl8VJGOcN
         9cluh+3jeO6WooEGHBcouDWE5iHXM/TEKCNwJHarRm12YmxUqrdBkKa5xD4BLKWyqM
         0xbqaoYhidWrA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/connector: Add const qualifier to cb_id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814640710.4483.7206399434775907995.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:20:07 +0000
References: <a9e49c9e-67fa-16e7-0a6b-72f6bd30c58a@infradead.org>
In-Reply-To: <a9e49c9e-67fa-16e7-0a6b-72f6bd30c58a@infradead.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     davem@davemloft.net, kuba@kernel.org, zbr@ioremap.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Dec 2020 21:15:47 -0800 you wrote:
> The connector driver never modifies any cb_id passed to it, so add a const
> qualifier to those arguments so callers can declare their struct cb_id as a
> constant object.
> 
> Fixes build warnings like these when passing a constant struct cb_id:
> 
>   warning: passing argument 1 of ‘cn_add_callback’ discards ‘const’ qualifier from pointer target
> 
> [...]

Here is the summary with links:
  - [v2] net/connector: Add const qualifier to cb_id
    https://git.kernel.org/netdev/net/c/c18e68696fdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


