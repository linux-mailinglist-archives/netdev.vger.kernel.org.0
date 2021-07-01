Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAD63B98AD
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 00:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhGAWwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 18:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232807AbhGAWwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 18:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 481AB61410;
        Thu,  1 Jul 2021 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625179804;
        bh=iJj7zNbtg6r2vhfx7N2UmNz+ZPPdRbIsf+lDQmFfCNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dFTk3CL+UdOpiwl3JmEWjhOMWOGfomO1VHrlsLjD1u8Afo2jsQaeBhhmItPTxLCgE
         DJwOoRm4WSCBtD/SIC9blWRUBDn4bo5fjBZWFjTnbb8G912v04BtsWLXYp1WUdUJuL
         gKg6zS7AE9gfMbBpogpviPBYkqDSP4cbqJSWBnlRI+wTM9YYcznIyc7F5wmNAlP02+
         MYBq0qrcmY7T7XHVxUCQCIY/Aw67WxcsZKtTG0JTZi80OXqGjsa5VLf1v+dEgMTOnd
         BbOK4Ga/dftf1dytuQmj5S4EUvUR7P56A/AY3tZw6hIffj1ZjXA7TSdC00bhSaPd1+
         IcTqIg1O2uwuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A7DE6095D;
        Thu,  1 Jul 2021 22:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] gve: Fix an error handling path in 'gve_probe()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517980423.10975.3143449977252562474.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 22:50:04 +0000
References: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 22:18:24 +0200 you wrote:
> If the 'register_netdev() call fails, we must release the resources
> allocated by the previous 'gve_init_priv()' call, as already done in the
> remove function.
> 
> Add a new label and the missing 'gve_teardown_priv_resources()' in the
> error handling path.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] gve: Fix an error handling path in 'gve_probe()'
    https://git.kernel.org/netdev/net/c/2342ae10d127
  - [net,v2,2/2] gve: Propagate error codes to caller
    https://git.kernel.org/netdev/net/c/6dce38b4b7ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


