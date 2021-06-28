Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2153B6A3E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbhF1VXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237870AbhF1VXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AAE061D05;
        Mon, 28 Jun 2021 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915257;
        bh=d62YUehR648ryfSQi5zGZA1nOJ5SgKDrrNUKmEeB3+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ta+Opjq6KukODlZAVWiITwoJ1DmjyXZQZOJYxdOofhkrJIgI8Zn1gRoIqxm9mjdgo
         eacZmRz9LhTAkgzy488BbwTdvnmps74Sa2Qm40H0JGSVxWioiCPrAE3xT8No90od6x
         H7SxiTaCcRuF2KXO40rikCzBS/i2d4zfQUmO0igL6oHY9JnxtfuI6aAhjDWSWfu9uP
         RtvAQVIFdDhP76TvzPNssiPyWF8rfQiKB5rUy8eVZnyrkAb8mULblgIAXljJ4cDWmT
         bM8FL1QLIcgra41tYPVTwBRfIInnm//I0Xfk/UmyN+2sGmM4XtNIxhAgvj9Kn2ahM5
         U0/wXVPSqTSMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2CB0260ACA;
        Mon, 28 Jun 2021 21:20:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/6] net/mlx5: Compare sampler flow destination ID in
 fs_core
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491525717.9606.14068720863849150027.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:20:57 +0000
References: <20210626074417.714833-2-saeed@kernel.org>
In-Reply-To: <20210626074417.714833-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 26 Jun 2021 00:44:12 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> When comparing sampler flow destinations,
> in fs_core, consider sampler ID as well.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net/mlx5: Compare sampler flow destination ID in fs_core
    https://git.kernel.org/netdev/net-next/c/6f8515568e69
  - [net-next,2/6] net/mlx5: DR, Add support for flow sampler offload
    https://git.kernel.org/netdev/net-next/c/1ab6dc35e914
  - [net-next,3/6] net/mlx5: Increase hairpin buffer size
    https://git.kernel.org/netdev/net-next/c/6cdc686aa316
  - [net-next,4/6] net/mlx5: SF, Improve performance in SF allocation
    https://git.kernel.org/netdev/net-next/c/5bd8cee2b9c5
  - [net-next,5/6] net/mlx5e: kTLS, Add stats for number of deleted kTLS TX offloaded connections
    https://git.kernel.org/netdev/net-next/c/e8c827614530
  - [net-next,6/6] net/mlx5e: Add IPsec support to uplink representor
    https://git.kernel.org/netdev/net-next/c/5589b8f1a2c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


