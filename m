Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F27429975
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhJKWcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 18:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235492AbhJKWcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 18:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 87F0D60F5B;
        Mon, 11 Oct 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633991409;
        bh=HmO9w25JD4+n/0F6SKE3lfNzVom9+QLKHyuHf3cRLV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeK9qb9ltPEZeR4vlUiMV6wY1rse7LK0DonlncvbA0LR4QKrgNsOhj+v59/G7bsJJ
         m3tncvNshV8DwSydlejk4DQjCZBkeDd8jaBDfNjyJp7V1c5BrrnWpp4LGPzg74EkCV
         P3iWvoq4IVh770pm3wy8oOZxuKhwZuBVSn9e0holjRtAV9PWMeUW/8gQ540QO+3+SI
         U3wiqQp694fAJtY0rNM+hIXZheacW2funU2z3WxEttGbW5Hydj/CIsGV9a0/eYjjwm
         nO5LL7JiDQmTcdQ+pbDXEphel/u16HRLmFgseEntThMR6uswwHfP90GyjMhBM/bPio
         343km+04WbLDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B0FC608FC;
        Mon, 11 Oct 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163399140949.20385.7016384584167614726.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Oct 2021 22:30:09 +0000
References: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 11 Oct 2021 09:57:33 -0700 you wrote:
> Wojciech Drewek says:
> 
> This series adds support for adding/removing advanced switch filters
> in ice driver. Advanced filters are building blocks for HW acceleration
> of TC orchestration. Add ndo_setup_tc callback implementation for PF and
> VF port representors (when device is configured in switchdev mode).
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ice: implement low level recipes functions
    https://git.kernel.org/netdev/net-next/c/7715ec32472c
  - [net-next,2/9] ice: manage profiles and field vectors
    https://git.kernel.org/netdev/net-next/c/450052a4142c
  - [net-next,3/9] ice: create advanced switch recipe
    https://git.kernel.org/netdev/net-next/c/fd2a6b71e300
  - [net-next,4/9] ice: allow adding advanced rules
    https://git.kernel.org/netdev/net-next/c/0f94570d0cae
  - [net-next,5/9] ice: allow deleting advanced rules
    https://git.kernel.org/netdev/net-next/c/8bb98f33dead
  - [net-next,6/9] ice: cleanup rules info
    https://git.kernel.org/netdev/net-next/c/8b8ef05b776e
  - [net-next,7/9] ice: Allow changing lan_en and lb_en on all kinds of filters
    https://git.kernel.org/netdev/net-next/c/572b820dfa61
  - [net-next,8/9] ice: ndo_setup_tc implementation for PF
    https://git.kernel.org/netdev/net-next/c/0d08a441fb1a
  - [net-next,9/9] ice: ndo_setup_tc implementation for PR
    https://git.kernel.org/netdev/net-next/c/7fde6d8b445f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


