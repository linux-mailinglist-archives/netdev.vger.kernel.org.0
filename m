Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A33FAA83
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhH2Ju7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234981AbhH2Ju6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 05:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF94760F39;
        Sun, 29 Aug 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630230606;
        bh=gJ3ari2FChJSHC1zxF0US0T5Ilqb1fpHecvMUahAWnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FCb7kkDmM2Ux4eiAA1jm5Lbn4gj5t5ZZ+d9WRkY/Uzj0L60rixAaGCxwpSfPYbTLb
         vjRcivx3gEHQiY+erjf8JA3yWos/tJ527zOVvvsAK6IznPcMFzlboaDF4E1CMjK8zR
         ZQZFk0+GuH5u5V0VkevkCHTkWNQPXQtQ4JaoGNxgDUTpy8pKDARgcoyWwct6QJAlEQ
         DBVxlvgggZxRHL6UnQ8O5yZBiTOuMpEs9aksr4zJlwU4nzXsIQOdlX9ROg4M12XFvy
         4Raocgh4d5PkCUoeRXYAGFQQb2pUEbQ/n63/Q5WA0/JaI1BzJdJx7ySCdYkPclsRxJ
         nRzGDp61WPq+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9B3360A3C;
        Sun, 29 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-08-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023060682.19070.7690744992833338059.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 09:50:06 +0000
References: <20210827172513.224045-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210827172513.224045-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        aravindhan.gunasekaran@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 10:25:10 -0700 you wrote:
> Aravindhan Gunasekaran says:
> 
> This adds support for Credit-based shaper qdisc offload from
> Traffic Control system. It enables traffic prioritization and
> bandwidth reservation via the Credit-Based Shaper which is
> implemented in hardware by i225 controller.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: Use default cycle 'start' and 'end' values for queues
    https://git.kernel.org/netdev/net-next/c/c814a2d2d48f
  - [net-next,2/3] igc: Simplify TSN flags handling
    https://git.kernel.org/netdev/net-next/c/61572d5f8f91
  - [net-next,3/3] igc: Add support for CBS offloading
    https://git.kernel.org/netdev/net-next/c/1ab011b0bf07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


