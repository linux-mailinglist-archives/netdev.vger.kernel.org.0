Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686E0480E3F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhL2AaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:30:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45638 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhL2AaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D32EAB81733
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ACC7C36AE7;
        Wed, 29 Dec 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737810;
        bh=OrprPypLJyG6eSQFocrGuXuWUyWvT0/k83DjskmKzRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GK5Etf/d87igeBHwYiv1mbFmDtsLXXvZDyhsw5Ven0DTiSzphci/qB2VgzWwJ8tdy
         VbHMHbnn2YEh6X6WyCbWp4WLbv+9ndnJgW4FQOrmvzHsBg5VjLBH9/WdsWGFJDwtuB
         twQRbnwtCH9kOW48/x1DQfixzjTKNYUSXOtXeC/lf4hX2WwHuWvAG+68CsBsrt/YXu
         nr85eEf73RIwwzwbzzfkzf/W1YT3GjXsFOj0QTbbv+pOUQmaHJiyDMxoVlTkA7S39u
         3VoPAU+rrvz77e7YdTZDnJQOrxKWpkK2ZX3EvyDW/Jo+qzpJBKKIYln1YyqiD2Cq43
         ozb95MexZz50Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73C7FC395E8;
        Wed, 29 Dec 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-12-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073781045.19054.1666958543731419554.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:30:10 +0000
References: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 28 Dec 2021 10:24:19 -0800 you wrote:
> This series contains updates to igc driver only.
> 
> Vinicius disables support for crosstimestamp on i225-V as lockups are being
> observed.
> 
> James McLaughlin fixes Tx timestamping support on non-MSI-X platforms.
> 
> [...]

Here is the summary with links:
  - [net,1/2] igc: Do not enable crosstimestamping for i225-V models
    https://git.kernel.org/netdev/net/c/1e81dcc1ab7d
  - [net,2/2] igc: Fix TX timestamp support for non-MSI-X platforms
    https://git.kernel.org/netdev/net/c/f85846bbf43d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


