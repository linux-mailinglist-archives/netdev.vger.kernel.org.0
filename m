Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA0306AB8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhA1Bvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhA1Buw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:50:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E15B64DD7;
        Thu, 28 Jan 2021 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611798611;
        bh=32MjUn6mHt5fzMvDIJFX/mCv58gQXHNqzUZMAQiTwjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FrOW4NICBeTjE7AYlxpeSoRIOoIaI6yohX552f3RJIhkZMUP78LEV4JrYJiQNZQUi
         j+3bHWGsdseDWbOU85CVAguvPqcytJOWnDGaVQnw6ucXf4d+nhKy7HyyaVbyVMl4sD
         jHUrQEnR6F8GQrofGDqP0WyRcm1lpzZw3EEw8rTYXUykhz2Cvgz9ZsG9Vddr55Yzrb
         YAA+zQAGbfohuYodeyOQO1L6FuZAvacT88X/Q6jgkl175U9O0nzEpSH206QHz6HYVK
         m/7VzdKkJd75f6BQ33auWu90tgKUn1O4roA9iZHWAdh9W/6ltEGFkOu2FNXfwps+eh
         fR/7pSF7WD6LA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AC776531E;
        Thu, 28 Jan 2021 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates
 2021-01-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179861116.5251.137213857175167454.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:50:11 +0000
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 14:10:28 -0800 you wrote:
> This series contains updates to the ice, i40e, and igc driver.
> 
> Henry corrects setting an unspecified protocol to IPPROTO_NONE instead of
> 0 for IPv6 flexbytes filters for ice.
> 
> Nick fixes the IPv6 extension header being processed incorrectly and
> updates the netdev->dev_addr if it exists in hardware as it may have been
> modified outside the ice driver.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] ice: fix FDir IPv6 flexbyte
    https://git.kernel.org/netdev/net/c/29e2d9eb8264
  - [net,v2,2/7] ice: Implement flow for IPv6 next header (extension header)
    https://git.kernel.org/netdev/net/c/1b0b0b581b94
  - [net,v2,3/7] ice: update dev_addr in ice_set_mac_address even if HW filter exists
    https://git.kernel.org/netdev/net/c/13ed5e8a9b9c
  - [net,v2,4/7] ice: Don't allow more channels than LAN MSI-X available
    https://git.kernel.org/netdev/net/c/943b881e3582
  - [net,v2,5/7] ice: Fix MSI-X vector fallback logic
    https://git.kernel.org/netdev/net/c/f3fe97f64384
  - [net,v2,6/7] i40e: acquire VSI pointer only after VF is initialized
    https://git.kernel.org/netdev/net/c/67a3c6b3cc40
  - [net,v2,7/7] igc: fix link speed advertising
    https://git.kernel.org/netdev/net/c/329a3678ec69

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


