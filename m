Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80053B3982
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhFXWw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232921AbhFXWwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA5CD613C9;
        Thu, 24 Jun 2021 22:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624575003;
        bh=/o7mHC8UiHdNqD8OncCd0TNsfyIG7RXD+Wqd1ei3thA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f/WUWEaYzgnvDDpjM5Ac0/DsvkjeEJfc27wS/D3AJ594ycvlFNGETW6jtCz4euZ4e
         k1J/idnmLzy8/KkuSveYgQiwKRnl3DfAjPe5DK0Kboat8StJ0Ht68LL4Kj9t8UK9U6
         yJAHKEvXIinD6JZnkVrlfb7bgjqKsGY7Bnszu7fOy7rN9M5Au6hn5ZDQzv+AkbgC5j
         mAXg5a2rd8QGd0iYzh+QfGf8kcVtWBI+3mxBMgik9menui5RDgtYbkdEZrR+rK8ssC
         7OVZw6S9vMVmrEc3tHbJWBUtihSk6tRySEtaX+AleS7y6E65PxS4ZLCURVTgpHnVe+
         fUPo1FtfAKAzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C76A60978;
        Thu, 24 Jun 2021 22:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2021-06-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457500363.3017.14562119396532729689.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:50:03 +0000
References: <20210624204009.3953413-1-stefan@datenfreihafen.org>
In-Reply-To: <20210624204009.3953413-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 22:40:09 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> This time we only have fixes for ieee802154 hwsim driver.
> 
> Sparked from some syzcaller reports We got a potential
> crash fix from Eric Dumazet and two memory leak fixes from
> Dongliang Mu.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2021-06-24
    https://git.kernel.org/netdev/net/c/8bead5c2a255

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


