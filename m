Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42852FB18B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbhASGXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404019AbhASFuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8074322ADF;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611035410;
        bh=9PCTtxdlnFAAROmo4v1rq+c//3T4U7DNx4CHZwyQ1wY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lsnZcpesrhrgDK0oBaQGxsiRZm2oObO6dqQ44SrHWC2b3Gqi1CC/UwLQPJvr//qNo
         XyocfNrkNzGIVWJomZH+GoyjSYwbZhDyX/5RtbWafwMvJmo+EPbg2UGborJNTJs28V
         uFm073Xz3jBlR3CcgxR/UOFnBv29XPZdVqoq6uxpf9clFlSwQi4QkF5xdw+Ds2EL+Y
         0sbQfUBHhFJDp0A/LtEo2aE3kuyoluajsZbU8ZVXHcbPr4iG/CIUVDWI+3Qfi3BwpN
         Lsun22Jv4shOmCNDTnDWl45JXksi8OnrKXjy5016opJ67NUTbzauY8qMLxKvOYemY4
         59FvgE7XlyBcA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7008C60460;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 0/8] TLS device offload for Bond
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103541045.1484.3865101885505297554.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 05:50:10 +0000
References: <20210117145949.8632-1-tariqt@nvidia.com>
In-Reply-To: <20210117145949.8632-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        netdev@vger.kernel.org, ttoukan.linux@gmail.com, moshe@nvidia.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        john.fastabend@gmail.com, daniel@iogearbox.net, jarod@redhat.com,
        ivecera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 17 Jan 2021 16:59:41 +0200 you wrote:
> Hi,
> 
> This series opens TX and RX TLS device offload for bond interfaces.
> This allows bond interfaces to benefit from capable lower devices.
> 
> We add a new ndo_sk_get_lower_dev() to be used to get the lower dev that
> corresponds to a given socket.
> The TLS module uses it to interact directly with the lowest device in
> chain, and invoke the control operations in tlsdev_ops. This means that the
> bond interface doesn't have his own struct tlsdev_ops instance and
> derived logic/callbacks.
> 
> [...]

Here is the summary with links:
  - [net-next,V3,1/8] net: netdevice: Add operation ndo_sk_get_lower_dev
    https://git.kernel.org/netdev/net-next/c/719a402cf603
  - [net-next,V3,2/8] net/bonding: Take IP hash logic into a helper
    https://git.kernel.org/netdev/net-next/c/5b99854540e3
  - [net-next,V3,3/8] net/bonding: Implement ndo_sk_get_lower_dev
    https://git.kernel.org/netdev/net-next/c/007feb87fb15
  - [net-next,V3,4/8] net/bonding: Take update_features call out of XFRM funciton
    https://git.kernel.org/netdev/net-next/c/f45583de361d
  - [net-next,V3,5/8] net/bonding: Implement TLS TX device offload
    https://git.kernel.org/netdev/net-next/c/89df6a810470
  - [net-next,V3,6/8] net/bonding: Declare TLS RX device offload support
    https://git.kernel.org/netdev/net-next/c/dc5809f9e2b6
  - [net-next,V3,7/8] net/tls: Device offload to use lowest netdevice in chain
    https://git.kernel.org/netdev/net-next/c/153cbd137f0a
  - [net-next,V3,8/8] net/tls: Except bond interface from some TLS checks
    https://git.kernel.org/netdev/net-next/c/4e5a73329051

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


