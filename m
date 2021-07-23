Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A23D3CC8
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhGWPJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235663AbhGWPJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A028660EB5;
        Fri, 23 Jul 2021 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627055404;
        bh=qPT4JWX5jO+VWBQCggeUdgQeTU1X4/maZRiWjQklwxc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rtw96mJOt4+VSUqmjyBdFayL+BvuAChm+RWrnl3peVK/h/0rKJV8BryyuFiv1NUr2
         n0CcaEs8tqGCcMQtjWJMblsVFgbEj/oPVuHicOvJwfsBD+wqM/9We/GT7A6X2XKvDN
         qW3yfvoYabZW/hCXqRBb5mUJN4XYqRbSdNs5ASyg4o8c4Mb2+A9yUYBn5+7udEROBk
         sDVfLRDLQuDLtxoRI0OdB65NX3dYtjX/XG6Vg+r0S8dvkWx8gjHE2jkcwxe0z2qQfd
         jphKmuQuB6zlcRh+7RpBmZOy/NuzosRLwVoC1zX2bp1AR+zHT/CP9qh8ssiZtdOQ/K
         DRXtrT3yrgPpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 937F560721;
        Fri, 23 Jul 2021 15:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Set true network header for ECN decapsulation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705540459.23511.8821493329364517880.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:50:04 +0000
References: <20210722170128.223387-1-gnaaman@drivenets.com>
In-Reply-To: <20210722170128.223387-1-gnaaman@drivenets.com>
To:     Gilad Naaman <gnaaman@drivenets.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, toke@redhat.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 20:01:28 +0300 you wrote:
> In cases where the header straight after the tunnel header was
> another ethernet header (TEB), instead of the network header,
> the ECN decapsulation code would treat the ethernet header as if
> it was an IP header, resulting in mishandling and possible
> wrong drops or corruption of the IP header.
> 
> In this case, ECT(1) is sent, so IP_ECN_decapsulate tries to copy it to the
> inner IPv4 header, and correct its checksum.
> 
> [...]

Here is the summary with links:
  - net: Set true network header for ECN decapsulation
    https://git.kernel.org/netdev/net/c/227adfb2b1df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


