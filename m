Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FE479ABC
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhLRMaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhLRMaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0761C061574;
        Sat, 18 Dec 2021 04:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D32460AD2;
        Sat, 18 Dec 2021 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2EE9C36AE8;
        Sat, 18 Dec 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639830610;
        bh=Eq3jgzuqBJJvtHt11kUu/GJ7HRGqHoVN9uNM7owmRBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P1zkYQaaEAUfONQoDU48loAiAP4QDUaKLnuXNhEXMV4Xd/aGtBRbuKyPm+10OB06x
         yayahyxPD0qAHwK+DfsuQeCsi09ztRSiRD6TCyZhZc1f3oxX7hgsvAGWvMpSPp0gCO
         hLQ1LuJ855dmAsl8YWD2BTVoUQcCMJOr8y7eaH9XoDGPFz5+j3dm6UZcvrAT6vq4wf
         vRg1nsoAB/Z/lvIHD6G17/270Mn9aa4CjzrOdU/iG+epnWH49f0ZM6SkAo4f2qtW6f
         khsgvk7oiiK7x7DNzKrxNOHCbX+YePEceUPuNbazQNda54NCFhagxNyd0NMUpsneBe
         li+EKVIbZm0aQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C0FC160A4F;
        Sat, 18 Dec 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates
 2021-12-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983061078.29880.10453820135462050582.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:30:10 +0000
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 17 Dec 2021 11:31:08 -0800 you wrote:
> Maciej Fijalkowski says:
> 
> It seems that previous [0] Rx fix was not enough and there are still
> issues with AF_XDP Rx ZC support in ice driver. Elza reported that for
> multiple XSK sockets configured on a single netdev, some of them were
> becoming dead after a while. We have spotted more things that needed to
> be addressed this time. More of information can be found in particular
> commit messages.
> 
> [...]

Here is the summary with links:
  - [net,1/6] ice: xsk: return xsk buffers back to pool when cleaning the ring
    https://git.kernel.org/netdev/net/c/afe8a3ba85ec
  - [net,2/6] ice: xsk: allocate separate memory for XDP SW ring
    https://git.kernel.org/netdev/net/c/617f3e1b588c
  - [net,3/6] ice: remove dead store on XSK hotpath
    https://git.kernel.org/netdev/net/c/0708b6facb4d
  - [net,4/6] ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
    https://git.kernel.org/netdev/net/c/8b51a13c37c2
  - [net,5/6] ice: xsk: allow empty Rx descriptors on XSK ZC data path
    https://git.kernel.org/netdev/net/c/8bea15ab7485
  - [net,6/6] ice: xsk: fix cleaned_count setting
    https://git.kernel.org/netdev/net/c/dcbaf72aa423

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


