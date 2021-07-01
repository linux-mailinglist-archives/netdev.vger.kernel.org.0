Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4278A3B9640
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhGASwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhGASwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A692D6141E;
        Thu,  1 Jul 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625165403;
        bh=eRyn9P+vGJ1WcJIyTwNUPQx37m3fDEqxlgykLPzZn/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgSJbCMMufW3BXkoYbPvCqQ6czDXHsj3dhVqQdU1Bo6/p+73xfumrI3/uIGzZWsao
         5xBpjW4vw4iAYiiAOr0IHwstv0VZmgDh6uFiGoQT1/2n30mdEBoBfsgVCQm8e0ScE8
         GPA5OyKoRnyNXpo+Qmwkga6L8ORPCRWoCL1UKv1BNE2/tAQ7QQDkc4SclM0WDLAIu0
         f+fgrC/ctXwlXxf0Yr6TN9s3n+Pjvo/kldXKJOSArgN8aeM53sSifO/TDyrJUsqTaM
         p5FFwmXzvpsc436vX7xeZ0g20uADFQ/zq90p9LhuBc4imvEoBUNW8FI/mAhw0neqTd
         hCn8MuLE3hj+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96D6F60A56;
        Thu,  1 Jul 2021 18:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516540361.27350.271838834305327308.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:50:03 +0000
References: <20210630001419.402366-1-opendmb@gmail.com>
In-Reply-To: <20210630001419.402366-1-opendmb@gmail.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 17:14:19 -0700 you wrote:
> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
> logic of the internal PHY to prevent the system from sleeping. Some
> internal PHYs will report that energy is detected when the network
> interface is closed which can prevent the system from going to sleep
> if WoL is enabled when the interface is brought down.
> 
> Since the driver does not support waking the system on this logic,
> this commit clears the bit whenever the internal PHY is powered up
> and the other logic for manipulating the bit is removed since it
> serves no useful function.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
    https://git.kernel.org/netdev/net/c/5a3c680aa2c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


