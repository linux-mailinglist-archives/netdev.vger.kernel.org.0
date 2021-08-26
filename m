Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BD53F8688
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbhHZLay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242243AbhHZLax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:30:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74A43610C7;
        Thu, 26 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629977406;
        bh=os+q9n8hc+wtS3lf32yM+RmJWjBDfWwQy4QCUNAOw0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C2nkcpxzGRzHOzgmlh07zyV/pxbW1xWjltlTZwUVrkxlpyeQzYPbliew7EyNP8DW/
         Qj0eOt/kT7oL4/ct7YcU0FqNBXGun8UTtWcSClQJar4wWuo7ZJ2RBUeFLx5K6t7qWB
         Pd/J68DEWZBHthSXaPHfsZE3a5CHtB6iKN5qGlp4ASAMTZ77DlZIpJvg1y3DwiFBXS
         Vh3cYP/vghUCNwK4Vf0YWh+QP0ArIEN2au0jsnONVMFzqX0mrmnsqf8JXNt6dueUmu
         t3zhidH5NDo1+yxAFQfOEKEAx/nhTjEScsEBpp6Cf/fDuWNuG3faU23oNleEdFGFzi
         zJKRYdBHwqsvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 67D7E60972;
        Thu, 26 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/2] net: Add LiteETH network driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997740642.22703.3742486992614498379.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 11:30:06 +0000
References: <20210825222106.3113287-1-joel@jms.id.au>
In-Reply-To: <20210825222106.3113287-1-joel@jms.id.au>
To:     Joel Stanley <joel@jms.id.au>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        kgugala@antmicro.com, mholenko@antmicro.com,
        devicetree@vger.kernel.org, florent@enjoy-digital.fr,
        gsomlo@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 07:51:04 +0930 you wrote:
> This adds a driver for the LiteX network device, LiteEth.
> 
> v4 Fixes the bindings and adds r-b tags from Gabriel and Rob.
> 
> v3 Updates the bindings to describe the slots in a way that makes more
> sense for the hardware, instead of trying to fit some existing
> properties. The driver is updated to use these bindings, and fix some
> issues pointed out by Gabriel.
> 
> [...]

Here is the summary with links:
  - [v4,1/2] dt-bindings: net: Add bindings for LiteETH
    https://git.kernel.org/netdev/net-next/c/b0f8d3077f8f
  - [v4,2/2] net: Add driver for LiteX's LiteETH network interface
    https://git.kernel.org/netdev/net-next/c/ee7da21ac4c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


