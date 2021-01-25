Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A563930302E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732745AbhAYXbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731932AbhAYXav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B998722D58;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617410;
        bh=xfegu7uF27VpNY7hYMfBqLtK5YuHNL2dBgCtM9ZHwkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ayDE23rgos4kdnnrKRt8OiX+iluliDPRtGSHzZCbtHhWiQ2TL3TKXIswMyugRdbmp
         S0+A5fVYaofJq0ItBn0dWQTnk1v3IRurI0Dav2/PKKvBmvpOltc4Kp2W/VuIdY977o
         ZM0OAEYqdFA3zg0Dco8SvNU5jUBFarpK/RJJ7Mu7tWLpUj8IA1NNgROK++3Ks1Y+kk
         +uwI112Va5fYVwPsx5M4fBsAXHc0zzvnPEwp7ovCsHXkkjrU/kgCRyUivctW8PA3tT
         A3st6Ky+b9DrdgSpeu0uapGEjagDHMcMbSqNKiX0OAaL578cBgSGgJfJ4uUAk5byWn
         YN3XKg4T0Nzdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5BEB61F2E;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/1] Fix big endian definition of ipv6_rpl_sr_hdr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161161741073.15463.565181310346247543.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jan 2021 23:30:10 +0000
References: <20210121220044.22361-1-justin.iurman@uliege.be>
In-Reply-To: <20210121220044.22361-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, alex.aring@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 23:00:43 +0100 you wrote:
> Following RFC 6554 [1], the current order of fields is wrong for big
> endian definition. Indeed, here is how the header looks like:
> 
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | CmprI | CmprE |  Pad  |               Reserved                |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> [...]

Here is the summary with links:
  - [net,1/1] uapi: fix big endian definition of ipv6_rpl_sr_hdr
    https://git.kernel.org/netdev/net/c/07d46d93c9ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


