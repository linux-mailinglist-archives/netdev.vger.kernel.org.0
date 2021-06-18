Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5623C3AD387
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFRUWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhFRUWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C58CA60240;
        Fri, 18 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047604;
        bh=o5zEoMkF2ffQupfx/waMkLYoyoZ7wz42rldwWf9gxXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lji5VbqHj5lCPupOp3tOgj+Pj6pXS6T7Hs97yo2gc2ltdF7tsa9nlbfvSR455xHnF
         ruwb/7eCHy6UYkLO4ycuTbJV84lvowB9w+5+oWg2OS446e1cuMQUBiJqfWJ97NvA8r
         jMMI5oSKi/nuM5Bxv1KYvJ2BkJQAqlx/tdbZD6peeYwdWZEatUO8CQgB0tjncNqSfe
         WGT+XllGmuNIjaj69UOMDYqB1L9G0jwyhgidnafLI07UHoaahvOjdl7CvkrhRg/vfg
         elWSBEebaWsebvrhBi3++yY9Q2odG+082vE9CmQ/SClI0CHKGNj/vEKP53TCeiuO9g
         QdctsYGpkXQIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADFD5608B8;
        Fri, 18 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: wwan: Add RPMSG WWAN CTRL driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404760470.11552.8138569124568626440.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 20:20:04 +0000
References: <20210618173611.134685-1-stephan@gerhold.net>
In-Reply-To: <20210618173611.134685-1-stephan@gerhold.net>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, aleksander@aleksander.es,
        ryazanov.s.a@gmail.com, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, ohad@wizery.com,
        mathieu.poirier@linaro.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        phone-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 19:36:08 +0200 you wrote:
> This patch series adds a WWAN "control" driver for the remote processor
> messaging (rpmsg) subsystem. This subsystem allows communicating with
> an integrated modem DSP on many Qualcomm SoCs, e.g. MSM8916 or MSM8974.
> 
> The driver is a fairly simple glue layer between WWAN and RPMSG
> and is mostly based on the existing mhi_wwan_ctrl.c and rpmsg_char.c.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] rpmsg: core: Add driver_data for rpmsg_device_id
    https://git.kernel.org/netdev/net-next/c/60302ce4ea07
  - [net-next,v3,2/3] net: wwan: Add RPMSG WWAN CTRL driver
    https://git.kernel.org/netdev/net-next/c/5e90abf49c2a
  - [net-next,v3,3/3] net: wwan: Allow WWAN drivers to provide blocking tx and poll function
    https://git.kernel.org/netdev/net-next/c/31c143f71275

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


