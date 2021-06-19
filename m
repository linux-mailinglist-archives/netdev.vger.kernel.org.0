Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABA43ADB83
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbhFSTcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 15:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhFSTcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 15:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0C4F60E08;
        Sat, 19 Jun 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624131003;
        bh=44te2zktC7sJxqYNg9H5C4Bd+o+5Z9lbhNTfooBw+Wk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dGzTNs3uJz1bMe6hKu7IEQmuo21jG+Tx6uICFz6qmHKxUDlpQ8f4wUvkBvjejjjr/
         hQ+/N1ghw6y4/XMOc0LyS2yQDatTVqRhoVouliTCt5FE1NwSsNFONscQa5FaCnXSf7
         E7B1u5WVEhN8k/FX8BdxviDFLFBVpWQzRptXi+R++eBsfPeHX5IylTjO1O9+qKQosH
         uiTobH+FV5Cz1wWJz4t9RQjZp1a/MEwMvF/ATKrVR63SI9Q2AzDfZGQfGWa4ucepTu
         9ASWQ1owsOuPpflQlt0gRxEa65WUp+ONcKR9l6SSmJSBKrNISoIDntiXficH288dxZ
         6nKqKmm3UoR4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9036D609F6;
        Sat, 19 Jun 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: aeroflex: fix UAF in greth_of_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162413100358.3389.13847175679674551696.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Jun 2021 19:30:03 +0000
References: <20210618145731.32194-1-paskripkin@gmail.com>
In-Reply-To: <20210618145731.32194-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     andreas@gaisler.com, davem@davemloft.net, kuba@kernel.org,
        kristoffer@gaisler.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 17:57:31 +0300 you wrote:
> static int greth_of_remove(struct platform_device *of_dev)
> {
> ...
> 	struct greth_private *greth = netdev_priv(ndev);
> ...
> 	unregister_netdev(ndev);
> 	free_netdev(ndev);
> 
> [...]

Here is the summary with links:
  - net: ethernet: aeroflex: fix UAF in greth_of_remove
    https://git.kernel.org/netdev/net/c/e3a5de6d81d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


