Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9645F569
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhKZTvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbhKZTtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:49:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFC1C061763;
        Fri, 26 Nov 2021 11:30:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E784B82888;
        Fri, 26 Nov 2021 19:30:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B014601FA;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955009;
        bh=3CkHFrBFn6+SVE+VeAVXyGbr7aUkt6F/FUirzSh3pp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WkvSiAkxqyATVL88R7cYnkB4s827Akmjo4QqUtjimj6JQC6/p8Oco7ejT9ib279Ll
         /UVtz6Ax/tEEYMymuREiXuatHlwWlUAJgu9HzctZNQ7XUyWiYXzMZmzim6QFseN+Md
         U7Iimh8+dw9TNljyD72fKVeG+8Cb9irOWan+luv5AMHDNGFoy34D2jkYNlm0jRXmcm
         xplUPmByO5sMx8uQ45CwHSko4C2wEDhldvYgpqrPkJsU5fFi3raYYNHYhSRmuioq63
         rRGpSzAAPXZniLWKqwy8TsPVwuq26B/y2RIswpjq4IyFqizwPyt+nYcYvuwpF7N2In
         AA4FDFoKz8AmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E0E6609D5;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: fix filter names in the documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795500951.14661.956922983509077010.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:30:09 +0000
References: <20211126031921.2466944-1-kuba@kernel.org>
In-Reply-To: <20211126031921.2466944-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 19:19:21 -0800 you wrote:
> All the filter names are missing _PTP in them.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/timestamping.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] ptp: fix filter names in the documentation
    https://git.kernel.org/netdev/net/c/cbb91dcbfb75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


