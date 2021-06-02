Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A08397DA2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhFBAVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhFBAVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E7E1613B9;
        Wed,  2 Jun 2021 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622593203;
        bh=QHcB1ZBQ5gr8P8Rpu5DLl7l78+m4kuBhy96eS5I64NQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tHwmPNwX22BH9lEaJYzlauKaG4An9/Y5lm1DDMww7N9Y/lGa8X34wWU+H51BklGcI
         vNdnITLxqC6nZCj+hh7BMxDdo33VY9cl1H/626zmUC1LqqmjJUzDq3ruckZmhkoUnS
         gh7tA8qkAtaUuNBb6tlV/2vw2qsJvsjkm1dx53Hv+4gQ1g+PMm8s6bSahp417xkJoW
         Q9hgeO96nK9yHgj1xJ/bCe5DCDboNLP85KxfnIKDftKqcVLY86ZSZM3yThdWf6POmD
         2FgmtilaZlf8prIJlJMz2VCYxENNY2jhBi9Du1O4/BdCJRmAaEckoMCSRr+7a6YImp
         RZyJKgZjddYlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32E3660953;
        Wed,  2 Jun 2021 00:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: nfc mailing lists are subscribers-only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259320320.27820.4965226473943122963.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:20:03 +0000
References: <c923aee4b8d21261af2c9f0fdbdd8e3c796da65c.camel@perches.com>
In-Reply-To: <c923aee4b8d21261af2c9f0fdbdd8e3c796da65c.camel@perches.com>
To:     Joe Perches <joe@perches.com>
Cc:     krzysztof.kozlowski@canonical.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 01 Jun 2021 09:38:58 -0700 you wrote:
> It looks as if the MAINTAINERS entries for the nfc mailing list
> should be updated as I just got a "rejected" bounce from the nfc list.
> 
> -------
> Your message to the Linux-nfc mailing-list was rejected for the following
> reasons:
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: nfc mailing lists are subscribers-only
    https://git.kernel.org/netdev/net/c/b000372627ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


