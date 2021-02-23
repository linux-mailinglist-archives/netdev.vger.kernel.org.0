Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2B322497
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBWDU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhBWDUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 190A464DE9;
        Tue, 23 Feb 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614050409;
        bh=paw6yrLQrSD3PzzcSgl5QkYaRZMEOnDUASOwAVHukzc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nJimDFivaPXFWMJ8GyOAa78ycUK5Np44NO9GrQRB1je2esPbc3/UI9lOPNENVS8Ig
         Eu3BL+Q0JvK573aPIqqfgnZX0hhmbPPfAO85k4QtSjx+QRU97jtnWiIC8wxZLB9KOu
         pcAZ8cX2+Ft6lTIe+t3DfgNqXqgOxuyZFvjn1M3Xq548uiMY4meoUzCBFGKhbbKDiT
         PTRW28HAyQWCSsrt5v0jDXkcKEYO5kby704cmtoGP2GJHI2wreWHVGJ7SfY1wOwTOL
         T9p7QLzIUFaE52RFKUGZFGvcDQfuUvAbtu7gZynAA3tCMVcqsr+DKihgFduTyndNNF
         0cCUNu/QIcE5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1062060176;
        Tue, 23 Feb 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/8][pull request] Intel Wired LAN Driver Updates
 2021-02-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161405040906.12674.14019370302299653748.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 03:20:09 +0000
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Feb 2021 13:35:58 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Slawomir resolves an issue with the IPv6 extension headers being
> processed incorrectly.
> 
> Keita Suzuki fixes a memory leak on probe failure.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/8] i40e: Fix flow for IPv6 next header (extension header)
    https://git.kernel.org/netdev/net/c/92c6058024e8
  - [net,v2,2/8] i40e: Fix memory leak in i40e_probe
    https://git.kernel.org/netdev/net/c/58cab46c622d
  - [net,v2,3/8] i40e: Add zero-initialization of AQ command structures
    https://git.kernel.org/netdev/net/c/d2c788f739b6
  - [net,v2,4/8] i40e: Fix overwriting flow control settings during driver loading
    https://git.kernel.org/netdev/net/c/4cdb9f80dcd4
  - [net,v2,5/8] i40e: Fix addition of RX filters after enabling FW LLDP agent
    https://git.kernel.org/netdev/net/c/28b1208e7a7f
  - [net,v2,6/8] i40e: Fix VFs not created
    https://git.kernel.org/netdev/net/c/dc8812626440
  - [net,v2,7/8] i40e: Fix add TC filter for IPv6
    https://git.kernel.org/netdev/net/c/61c1e0eb8375
  - [net,v2,8/8] i40e: Fix endianness conversions
    https://git.kernel.org/netdev/net/c/b32cddd2247c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


