Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601413ABC93
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhFQTWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233258AbhFQTWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7CF92613F5;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623957613;
        bh=ZbgR8b6YXLNw9PQcwqFqgL6fccZj7CBgoFgLl/R0VIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Soaw1VgfLnHIMdHqEsvrg44jWUsUsSQdjzTtVi+0nnVR6aVVHcMrzsUqMYqGjNRGY
         v1nkWpkExxoBkHSGIcOmY738Vj83lTEQJ7o8dV6CGrbrqp6sMEtb2Tvp5KuF1KYU2Y
         j5qPT/weSbSlxtgghT5qqQdQ4UljCCojSiVYsL7Y12nMpjm90IGrP+2bDXDrYC9n0q
         W6Vo66RiBNVjfKaR5K/Z4vVSU88Sr2VKyeqEeGwFF/ZftwRedq0DrsFEOFum8YJxqw
         95/EeDoXsrg9oLvewb+KMwxrifvoiIhToPYXKwXYuMiSTPVu50GEe2HJgEFB+2iSph
         Ud7d0SSjAdARQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73FF860CD0;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-06-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395761346.22568.2669391089061248789.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 19:20:13 +0000
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 10:01:37 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Jake corrects a couple of entries in the PTYPE table to properly
> reflect the datasheet and removes unneeded NULL checks for some
> PTP calls.
> 
> Paul reduces the scope of variables and removes the use of a local
> variable.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] ice: fix incorrect payload indicator on PTYPE
    https://git.kernel.org/netdev/net-next/c/638a0c8c8861
  - [net-next,2/8] ice: mark PTYPE 2 as reserved
    https://git.kernel.org/netdev/net-next/c/0c526d440f76
  - [net-next,3/8] ice: reduce scope of variables
    https://git.kernel.org/netdev/net-next/c/b6b0501d8d9a
  - [net-next,4/8] ice: remove local variable
    https://git.kernel.org/netdev/net-next/c/c73bf3bd83e8
  - [net-next,5/8] ice: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/b13ad3e08df7
  - [net-next,6/8] ice: remove unnecessary NULL checks before ptp_read_system_*
    https://git.kernel.org/netdev/net-next/c/1e00113413a4
  - [net-next,7/8] net: ice: ptp: fix compilation warning if PTP_1588_CLOCK is disabled
    https://git.kernel.org/netdev/net-next/c/4d7f75fe8006
  - [net-next,8/8] ice: remove redundant continue statement in a for-loop
    https://git.kernel.org/netdev/net-next/c/587b839de733

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


