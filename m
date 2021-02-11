Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2D319012
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBKQda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:33:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231944AbhBKQat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 11:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A5ADA64EA1;
        Thu, 11 Feb 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613061007;
        bh=FjvOPHXR5vtubXrCZeMCV2OPTg886IJi9fniyWqwwq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xf+Zhh8KE+wGMzHkzeEUO87Y0Ud2HDF5e0KcfRczOs4kdR/kNgGcrIzXn9zVH3COk
         S8podwqWBAZzLMLtmZew3h+HfBlRQpBCXv6Jm3eSj+p/lbp5rXm7un277Ef5012pqb
         RoJHEIkwtlJaSZ0tavJ/22R3U/ya66yyjtLZeZu44M8zxjLFX2C2HJ8ElX+BeC88nN
         1yoS1ajsJA5JMQjuI2dnKeuX9+1GY5ycNSWUNvLQaFV+oJPdDNqi5ITn0ZIsXtLBtt
         puMN/cNUrNoCtdi8d3i8RVqaaSY8umWRNS03mPE+fx0jvQfOWRrcrYKtnqmApPXPaQ
         nDMUc4quvczvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9464060A0F;
        Thu, 11 Feb 2021 16:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next V4] devlink: add support for port params get/set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161306100760.9340.13381007825071685914.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 16:30:07 +0000
References: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@nvidia.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (refs/heads/main):

On Tue,  9 Feb 2021 12:31:51 +0200 you wrote:
> Add implementation for the port parameters
> getting/setting.
> Add bash completion for port param.
> Add man description for port param.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,V4] devlink: add support for port params get/set
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c946f5d3e414

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


