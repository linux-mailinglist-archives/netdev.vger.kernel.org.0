Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C30334CAC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhCJXkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhCJXkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AAED864FC8;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419611;
        bh=TX7W2NqZLjAhMiI5mqX7/+1Ks9mRsyBvqCKlKNUta6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PA+MN1bAfZOxJNqZ4b5kYjstPFSBjcYB8TVqhjuZhRIINM7UV7VurFg+Cif33iVb5
         dZbdlwld8zwouSlpajylWPuw02KC1DQa6tqm8d16/c8mcBJSNvaVbQoWJOfxMKW9wP
         kBTQpczkpVeXpQuBHzpkMvYC1lI/sB0wxo9JWBX+pKK+jlE5Teh+zD4oTpJpR21UWJ
         8OP/oMNkGdslEZ7yNcA5sRQx3kL64vWvKA1/pMGcJ90Df/dblRnH0ZJH4Vu0BuoCg5
         +ct11zpeSP/lHQSuC9PbHhe10DneZVeE9ZAXUbyjyw8jNQWjP5XUif1QLJ8j8CgdIz
         20vG8zTmYBJOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E1F5609D2;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: pxa168_eth: Fix a potential data race in
 pxa168_eth_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961164.10035.17270257580357319149.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:11 +0000
References: <20210310081046.505747-1-andrianov@ispras.ru>
In-Reply-To: <20210310081046.505747-1-andrianov@ispras.ru>
To:     Pavel Andrianov <andrianov@ispras.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 11:10:46 +0300 you wrote:
> pxa168_eth_remove() firstly calls unregister_netdev(),
> then cancels a timeout work. unregister_netdev() shuts down a device
> interface and removes it from the kernel tables. If the timeout occurs
> in parallel, the timeout work (pxa168_eth_tx_timeout_task) performs stop
> and open of the device. It may lead to an inconsistent state and memory
> leaks.
> 
> [...]

Here is the summary with links:
  - net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
    https://git.kernel.org/netdev/net/c/0571a753cb07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


