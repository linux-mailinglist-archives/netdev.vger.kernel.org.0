Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C210349E50
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCZBAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhCZBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44FAC61A1E;
        Fri, 26 Mar 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616720409;
        bh=a/ipJ72/4gZBbJe3RfI2Bb62Txcg5x5q5HCehmpUeH8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RcwLwi4w2sr3Xu0lI4O+KcMKcUOqRZFp3us9z/tvCc+B2A2L4R5BFuy0GgniQI2QW
         IiI3161sLklLlBcDRH64BINiI2hqyFbwnSxSIy00VU5kkelepuP/i59Zl2ClBSImMj
         rgePJ8ZZKlNN65QpPbO8HX0QJyW2GvLIQfatja3op76NqRk84YLmKxw6VjWsSWVMuS
         1dwXpWbA5SndYwl3tIKxuSjYm4lGsAAg9v0aa1/NRjSwVrJfu5cHa/sF3ejd9A4sfy
         lYi+eBgYoaSpXcqygGVUtcEX1NKB4dVaXSyeSXUztx1Livv+vDo3uWlbUCFJ1QRwZf
         Lb4whBbLpOL+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35F7F6096E;
        Fri, 26 Mar 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2021-03-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161672040921.13572.15657383183828707597.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 01:00:09 +0000
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Mar 2021 15:31:15 -0700 you wrote:
> This series contains updates to virtchnl header file and i40e driver.
> 
> Norbert removes added padding from virtchnl RSS structures as this
> causes issues when iterating over the arrays.
> 
> Mateusz adds Asym_Pause as supported to allow these settings to be set
> as the hardware supports it.
> 
> [...]

Here is the summary with links:
  - [net,1/4] virtchnl: Fix layout of RSS structures
    https://git.kernel.org/netdev/net/c/22f8b5df881e
  - [net,2/4] i40e: Added Asym_Pause to supported link modes
    https://git.kernel.org/netdev/net/c/90449e98c265
  - [net,3/4] i40e: Fix kernel oops when i40e driver removes VF's
    https://git.kernel.org/netdev/net/c/347b5650cd15
  - [net,4/4] i40e: Fix oops at i40e_rebuild()
    https://git.kernel.org/netdev/net/c/f2916ae9a1bc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


