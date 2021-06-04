Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADCC39C2A0
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhFDVmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFDVlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C31A61406;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622842806;
        bh=VOAmegZrrnqcFJsaouuuTgtXOyFUPWlsLFyrwQoRhX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6rW8nCSi+PzQE9rT7XdolYvvIjmycoFwbqxiUI5mi9EKDskrP0lvaT4e7dgWFySs
         G64i5lg0E96/bJIwAf76hyEqH3UGJD3cyS2eChqjiurABxf36bztYRCrglDdn+pjtp
         LeEY3ELkMKRp+QmGbgPCPW9MFZa0k4Tn9kiJMVqWllcjHZNh/wjaOskQMxU5CZQ+/v
         yWmFaXK+O5aq6wT8qpTvTa+b6xnc1Q6ag40EDHFqtytlzW0p7Yxj+8quJS8IhsKlCI
         pfxC2VF3Xz2mZ73QFlQ/bdXVoke8nhoJkqHDCEJ3JOcUIVxzXImhbAREKCfp5+PaTz
         8vkiLkHnzH/Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 072BA60BCF;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-06-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284280602.31903.16802596899153014387.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:40:06 +0000
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Jun 2021 09:24:16 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Sasha utilizes the newly introduced ethtool_sprintf() function, removes
> unused defines, and fixes indentation.
> 
> Muhammad adds support for hardware VLAN insertion and stripping.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] igc: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/220ef1f97ec1
  - [net-next,2/5] igc: Remove unused asymmetric pause bit from igc defines
    https://git.kernel.org/netdev/net-next/c/cca2c030b2a7
  - [net-next,3/5] igc: Remove unused MDICNFG register
    https://git.kernel.org/netdev/net-next/c/6fdef25db3d4
  - [net-next,4/5] igc: Indentation fixes
    https://git.kernel.org/netdev/net-next/c/5cde7beb27af
  - [net-next,5/5] igc: Enable HW VLAN Insertion and HW VLAN Stripping
    https://git.kernel.org/netdev/net-next/c/8d7449630e34

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


