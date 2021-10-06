Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B17424021
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhJFOcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238878AbhJFOcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FBED611C3;
        Wed,  6 Oct 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530609;
        bh=l1z26AC8WSo2OBi5XvcRCr/0+4p29I2VaT62ACAe7Lc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M0/g34IMlFPTsd+AlH2b7m9fMyDK/qHvEq06Xz3KtFu4RULYHxdMh3vzQ+cdrr029
         YRItHK6xOMaOmxcx7Kkcp2xVRABD9OUtquhSQqMfCid6uLVJcbjawFGgSO090YItA/
         8tMeTIFQDITe4WvWmLrIosbD22CXEwwMktA1SpLs1pzb8KeO1m0EMZ+yjeibBmeLtU
         PHelC/lOCGyBUgXHCzgzUjJW7jR8EF81OEV7f1BW1fhuWFRhEf2zYXMsDRAgry2txt
         0aRfeP26XsDS8AiiotFt8ABD+7zf96j2STk8iAhK9tUkRBTs71MuNb9UhAiwSpKhpw
         WMX6jRpDsyeiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16DB460971;
        Wed,  6 Oct 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: spectrum_buffers: silence uninitialized
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353060908.19239.3639328763351154450.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:30:09 +0000
References: <20211006073347.GB8404@kili>
In-Reply-To: <20211006073347.GB8404@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 6 Oct 2021 10:33:47 +0300 you wrote:
> Static checkers and runtime checkers such as KMSan will complain that
> we do not initialize the last 6 bytes of "cb_priv".  The caller only
> uses the first two bytes so it doesn't cause a runtime issue.  Still
> worth fixing though.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: spectrum_buffers: silence uninitialized warning
    https://git.kernel.org/netdev/net-next/c/9b139a38016f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


