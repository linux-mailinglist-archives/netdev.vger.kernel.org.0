Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4016F425244
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241120AbhJGLwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhJGLwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 07:52:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 083CB61248;
        Thu,  7 Oct 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633607408;
        bh=a8HbgBguOSpxtduPGdpnOpcONjdtvYCaNBfEWAkhfL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZFqR30L9zqfNS2RiPGWWAyWHaiat3EohdMs5E3L+3xz28vdkUIixyqUGJ2ovP5aYi
         YnCfemrPUgE7xOka08DU3/W10SUxhmbxxvnVob7ZxH6GC4dfRV+uP4kwprNZbObTIb
         N+uGJza/0Qv2i/udlX6Pfaslatcx+izheYD2HnQHY3qU7CU57mxoONCWgvdIhsyLDD
         gI27Da5WWZbdj1yAxsOOID0LfnMBeWfplKLkQbu13KSVEe0ePv6wHw8VDq5Qk5onpn
         deDaUOMDkgR6/GubF3YZbzuCqkWRBBB94pELz8AQgJpe2l5HP70XcsottYha0fSTvn
         C/Vj+dWQGrIYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF09E6094F;
        Thu,  7 Oct 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2021-10-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163360740797.32014.7980172626328683543.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 11:50:07 +0000
References: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  6 Oct 2021 09:56:56 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Jiri Benc expands an error check to prevent infinite loop for i40e.
> 
> Sylwester prevents freeing of uninitialized IRQ vector to resolve a
> kernel oops for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/3] i40e: fix endless loop under rtnl
    https://git.kernel.org/netdev/net/c/857b6c6f665c
  - [net,2/3] i40e: Fix freeing of uninitialized misc IRQ vector
    https://git.kernel.org/netdev/net/c/2e5a20573a92
  - [net,3/3] iavf: fix double unlock of crit_lock
    https://git.kernel.org/netdev/net/c/54ee39439acd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


