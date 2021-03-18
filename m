Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E781A340FD3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhCRVan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhCRVaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B83964F38;
        Thu, 18 Mar 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616103010;
        bh=AwsWUyeFUWfSrisNWO8iAiM8UVfX358NycK0uj3mRS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iMB+L9kVVuajI0OoZOD3jY7j3uyPGyxMXsjesjZWerQTZYbumv94KSJVvZ5KmhOvt
         wNPBithMCs54F4Ted5LhhWjdE7t2hUFAm94wZPYPo4OuN5QhHp9eq6qxTmPOr1Wkq+
         E32L6OspwQRq6/K16xt0DLptF/q9pTf2YIs8GWpoTcc/B9nOLy4ToAZWRpsZrdDMvI
         hOMik7/2JGbvipWJlNxsaW5zpljowt2MHepSXkiRsXMnEmI7gsXn2wemOuoUKGOQag
         zX1iT5v+eDl51ocxIk8AzNx581awq420lnsEsQoG05R5BGjfoVLSocC6soMo1KBD/Y
         YFBlFaWmAEArQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7665460951;
        Thu, 18 Mar 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] stmmac: add VLAN priority based RX steering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610301047.15925.7348673094676244775.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:30:10 +0000
References: <20210318172204.23766-1-boon.leong.ong@intel.com>
In-Reply-To: <20210318172204.23766-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 01:22:02 +0800 you wrote:
> Hi,
> 
> The current tc flower implementation in stmmac supports both L3 and L4
> filter offloading. This patch adds the support of VLAN priority based
> RX frame steering into different Rx Queues.
> 
> The patches have been tested on both configuration test (include L3/L4)
> and traffic test (multi VLAN ping streams with RX Frame Steering) below:-
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: stmmac: restructure tc implementation for RX VLAN Priority steering
    https://git.kernel.org/netdev/net-next/c/bd0f670e7931
  - [net-next,2/2] net: stmmac: add RX frame steering based on VLAN priority in tc flower
    https://git.kernel.org/netdev/net-next/c/0e039f5cf86c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


