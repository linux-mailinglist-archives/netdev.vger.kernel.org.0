Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A683CC01B
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhGQAdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230352AbhGQAdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 20:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC5FC613F2;
        Sat, 17 Jul 2021 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626481805;
        bh=TH4SVeGjkEP3qfpkAMY64fC8/7CgV0c1GfBcVSnCBvg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YETY0nBr6Nvg9FXh4J4YWD+D5IIrALHmXmo7xOOdj02AT4vqw7cPosgxHqTsJ+Kr/
         vOU5PIP8sJsF9JTB45WdLjkje0artf3z1uu8WHPYC/OSLc0gleZtYdA1cwx7M89hrf
         fY+sz+fBSIgK//Bysg0lJ0NGHAhgNSF6K5s9x++Y6kH3fGr8hZKeSLyawggyXf+wmr
         n8IUP6x7dzomJcdTGmyCG+zpfFlIicaVjLyJqmmnwETSrPAajCqi4HKaIh++3xcGyw
         8MrvjOj89tjqTzo/0OtCro8WPv43zGTpT2PtxsXESQ/j1J5MdMmHNInI4md4ifW8Qy
         na1hSPbzxLLcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D67A260963;
        Sat, 17 Jul 2021 00:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-07-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162648180587.17758.7584097411653240168.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 00:30:05 +0000
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 14:24:22 -0700 you wrote:
> Vinicius Costa Gomes says:
> 
> Add support for steering traffic to specific RX queues using Flex Filters.
> 
> As the name implies, Flex Filters are more flexible than using
> Layer-2, VLAN or MAC address filters, one of the reasons is that they
> allow "AND" operations more easily, e.g. when the user wants to steer
> some traffic based on the source MAC address and the packet ethertype.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] igc: Add possibility to add flex filter
    https://git.kernel.org/netdev/net-next/c/6574631b50ed
  - [net-next,2/5] igc: Integrate flex filter into ethtool ops
    https://git.kernel.org/netdev/net-next/c/2b477d057e33
  - [net-next,3/5] igc: Allow for Flex Filters to be installed
    https://git.kernel.org/netdev/net-next/c/7991487ecb2d
  - [net-next,4/5] igc: Make flex filter more flexible
    https://git.kernel.org/netdev/net-next/c/73744262210c
  - [net-next,5/5] igc: Export LEDs
    https://git.kernel.org/netdev/net-next/c/cf8331825a8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


