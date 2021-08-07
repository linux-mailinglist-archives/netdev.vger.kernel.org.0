Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF213E323E
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 02:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhHGAAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 20:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhHGAAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 20:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07CE3611C5;
        Sat,  7 Aug 2021 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628294406;
        bh=4A+8Gdr0GxJ3QR/5/1CZG4CMQQjvAVlXL9P64LaMOPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=njJIEcdqOWqzTq2iTeKDx9hkJsRsldn60uhN79Z0KVn+b1r7So+xeC4IxSnhz25W0
         +vE0K/lcZy/OGitJSXScJo/ydp/9VSKSj65V5Xr702vnSPn89h2VK6zzRiNAXDTT+1
         0OeDPomgL+IOkwucewBQbMx2qr6KEZrjOV5JB6xpvvKupAbX4g98Rv95wmdkoHghen
         YZa6T3+PtvNf7MFqxaRLA3rQzDJzjkduVP673F+vBjfxWd7i+gVXZ+ucygeDhSXqFQ
         jsjITMZcBEO//ha55dOhkiKfn+zjXNGUQXhsrsNNVtsphAz8Z/CBz0i39d1xfWCw+N
         3x9iTdOipaqVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EEBDC60A7C;
        Sat,  7 Aug 2021 00:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] samples/bpf: xdpsock: Minor enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162829440597.32097.9443934066485128574.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 00:00:05 +0000
References: <20210806122855.26115-1-simon.horman@corigine.com>
In-Reply-To: <20210806122855.26115-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com, niklas.soderlund@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri,  6 Aug 2021 14:28:53 +0200 you wrote:
> Hi,
> 
> this short series provides to minor enhancements to the
> ample code in samples/bpf/xdpsock_user.c.
> 
> Each change is explained more fully in its own commit message.
> 
> [...]

Here is the summary with links:
  - [1/2] samples/bpf: xdpsock: Make the sample more useful outside the tree
    https://git.kernel.org/bpf/bpf-next/c/29f24c43cbe0
  - [2/2] samples/bpf: xdpsock: Remove forward declaration of ip_fast_csum()
    https://git.kernel.org/bpf/bpf-next/c/f4700a62c271

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


