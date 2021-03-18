Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119B334100C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhCRVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCRVuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5261464F30;
        Thu, 18 Mar 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616104208;
        bh=C2ReViZ29s/Pojl6qoaXRdyzjCGyU9fonV2E8w8IyM8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KfhQlMXBQMhFaK3ewPinLe15c4xSU/lIrM7F7PF54R3ywYIIcm1NGUsFxAJtwaU9Z
         dn+xZVYXDIuAEL757wzjFQ4tN2huFHbKIOplvEV59oh+EPywxPjFvHCfG7WVHD7Oww
         oPjAYs40lD1ehLub4lNcwDI4UY8Dvu3N50LTNp9id13Z0xRDcYouo2yNovb4rSFw+s
         oXcOEOdGzt54qHPrhZ2rTctDSULwFsP9WMs2jTm83WgCl4i3Jmw4ajIbftmSLPf+SL
         PKWoqzHOEdNyIs5SXn1h7XLbauEOxpu/T2mGYnTPNzvC7CUQGKFj0PxT0m7Ls8SQM2
         TZnGdTUPyGc7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 405F760951;
        Thu, 18 Mar 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610420825.23324.1032430215154186888.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:50:08 +0000
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
In-Reply-To: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Mar 2021 04:42:53 +0100 you wrote:
> __dev_alloc_name(), when supplied with a name containing '%d',
> will search for the first available device number to generate a
> unique device name.
> 
> Since commit ff92741270bf8b6e78aa885f166b68c7a67ab13a ("net:
> introduce name_node struct to be used in hashlist") network
> devices may have alternate names.  __dev_alloc_name() does take
> these alternate names into account, possibly generating a name
> that is already taken and failing with -ENFILE as a result.
> 
> [...]

Here is the summary with links:
  - net: check all name nodes in __dev_alloc_name
    https://git.kernel.org/netdev/net/c/6c015a225680

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


