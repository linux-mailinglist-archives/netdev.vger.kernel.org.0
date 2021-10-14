Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFB742DB54
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhJNOWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhJNOWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3989F610A0;
        Thu, 14 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634221207;
        bh=FmINIR3ENpN9V0QG7PF4m2RytRAAMj043EYCFwR1ouU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JmX9p+Go8UR2v6cjAeXBFRjmRWTEd74R4aiSvoKXcdjtxApaFq11onzlrwNQw9T6Y
         EihuylMNXLq+ARFDZf5YZ7SIoKypbXOXGnXwwsmn2NgimwLcvtjmja8ovXsoge0+kN
         fmANZLFAL+Vvwy1RusoXyCLGU+sxAKzJCVUtgn+7IyB/HxoiZDwAlgYNnpw+HHpD9p
         82qgDAxiUtgksepRwvMzesl7cm7wH0yhs0re9sjfLAqgtuW6/zeMrpNw+4hdVu4tEs
         EhrniG7AGbi65oiedH+RIHGQuLnJuSHAtA+bQOLWnJMyQ5saMz+6V7JSdCBW/44n4f
         Yp17QXmfi0nHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2FD3260A44;
        Thu, 14 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: thermal: Fix out-of-bounds memory accesses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422120719.29699.5423823491345588706.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 14:20:07 +0000
References: <20211012174955.472928-1-idosch@idosch.org>
In-Reply-To: <20211012174955.472928-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vadimp@nvidia.com, cera@cera.cz, mlxsw@nvidia.com,
        idosch@nvidia.com, daniel.lezcano@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 20:49:55 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, mlxsw allows cooling states to be set above the maximum
> cooling state supported by the driver:
> 
>  # cat /sys/class/thermal/thermal_zone2/cdev0/type
>  mlxsw_fan
>  # cat /sys/class/thermal/thermal_zone2/cdev0/max_state
>  10
>  # echo 18 > /sys/class/thermal/thermal_zone2/cdev0/cur_state
>  # echo $?
>  0
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: thermal: Fix out-of-bounds memory accesses
    https://git.kernel.org/netdev/net/c/332fdf951df8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


