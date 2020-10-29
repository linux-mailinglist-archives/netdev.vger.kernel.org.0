Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE2429F6B0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgJ2VKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgJ2VKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 17:10:37 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604005836;
        bh=B9S0PYHC82HjIc6eRghx3UXS5MiORPfewagDkRGT7Fc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rPbd4efRdfwMEMhu55BceSkg/Ir8HrkvE2X3mn7k8VdFkuqQVzP/O+NZgt16X46et
         dEDgBtimaNtHJwYP3OuWobFR8AZSLJZHkepAfIosC5ExP6wJcIYTDBAKlMJAmQ8Aq5
         oD+mRpXzN0bMHY5qMi7Lfszn3cAEfpVduU1RNj7A=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160400583677.23156.17057572329137636713.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Oct 2020 21:10:36 +0000
References: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Oct 2020 12:43:35 -0700 you wrote:
> The following changes since commit 3cb12d27ff655e57e8efe3486dca2a22f4e30578:
> 
>   Merge tag 'net-5.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-10-23 12:05:49 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc2
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/934291ffb638

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


