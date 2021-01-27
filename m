Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C8E3050DF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhA0E3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391696AbhA0Au6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:50:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A185E64D76;
        Wed, 27 Jan 2021 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611708609;
        bh=k/+68lFmISA2BJxlPDHySDI4oOvJNinRYXGnLP54p2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H/WNoWmJDQdNKfUZriRhyuwFroOVNUTYZrh+bjQY2T5WqhkZgY7ZN44DMZI2WQLy4
         6ki4OszUX5CacrEViC/RbFSYEj4P0ME6/qzKvePaY5LulGL+b/qaTacEj8O4k2AKjB
         35JvaE+i5bRsxM/FSI2/j2JkrY3AklSLrQKHOs+5qrL9k+aYqXIft83spHGGTzPsDb
         IeZYpPPAWn9mHsPGYJa0ndWCL4f+Du3/zSPLNMpJ+5B/c+wWJgED55sZLtyDGllhpr
         /ekDGHYTUyQm/eOY2u/JI4xnGvFZogEHy/Ewq2Og4uXoUKCPC7sdEFoffAqASlVT3q
         K7aDzj3zKDOEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8FD08652E0;
        Wed, 27 Jan 2021 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add David Ahern to IPv4/IPv6 maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170860958.26229.11312324684708944491.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 00:50:09 +0000
References: <20210122173220.3579491-1-kuba@kernel.org>
In-Reply-To: <20210122173220.3579491-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 22 Jan 2021 09:32:20 -0800 you wrote:
> David has been the de-facto maintainer for much of the IP code
> for the last couple of years, let's make it official.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] MAINTAINERS: add David Ahern to IPv4/IPv6 maintainers
    https://git.kernel.org/netdev/net/c/5cfeb5626d4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


