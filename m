Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0651D45928C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhKVQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240185AbhKVQDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6180760698;
        Mon, 22 Nov 2021 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637596809;
        bh=fcWJJgKL6YazFDSRkB4SLM9DxBdRFZfQ8kwb/awKZOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UWAill8yRnyx2xsNTrqxjFBREbuYSY0SJcDfgL2//ZJvR0ewILTe6XHsmQXTa6lKb
         oQS4kUdkxuhFVTq2OMpZphZJm21UeWOaWJ2f/HOhNV1xdwVr05hyPOvbiC9vbnNOpW
         5nG612ZxgfOGbt2eO80ITmf6GT3L9OVJZOiVWZF+6VA4BSHnOlraBX/8iBQM0bgABE
         BCD3eYAef9Rg22BGdZ5yjKpZES9JsRkz1WHcn7dXq6YMRKnCFR27uuxtTwj9tKvfBJ
         G4Ve3+89TZO0zpoldDTVTHSh+e+n4W7hUwkivouTp12vUdkNaBQ+0e5kzco5jpKv2k
         5kaJDzsDanVYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52D6C60AA4;
        Mon, 22 Nov 2021 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net,
 neigh: Fix crash in v6 module initialization error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759680933.8210.6595261953181261820.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 16:00:09 +0000
References: <20211122150151.16447-1-daniel@iogearbox.net>
In-Reply-To: <20211122150151.16447-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oliver.sang@intel.com, zhijianx.li@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 16:01:51 +0100 you wrote:
> When IPv6 module gets initialized, but it's hitting an error in inet6_init()
> where it then needs to undo all the prior initialization work, it also might
> do a call to ndisc_cleanup() which then calls neigh_table_clear(). In there
> is a missing timer cancellation of the table's managed_work item.
> 
> The kernel test robot explicitly triggered this error path and caused a UAF
> crash similar to the below:
> 
> [...]

Here is the summary with links:
  - [net] net, neigh: Fix crash in v6 module initialization error path
    https://git.kernel.org/netdev/net/c/4177d5b017a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


