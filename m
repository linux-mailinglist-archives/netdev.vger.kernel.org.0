Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFB63A3500
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFJUmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhFJUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EC7F61426;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357607;
        bh=fyKQIuwStPwuLwiHKst1eZORd0L18zu32avUQjOu4fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SnjQ1+Z1nrSt3+JtzRbT+fjAUqTIi/VOpeJDF2ir9sV3UVJxfBKruH16SQLME4c1R
         zqAgTYhCXsbrg7QFvDbYVloeUCpay+xku4tKB1e7R2MHD3W90s6oXCmnXdnHecAPgF
         sqKtHeMymlO159poSKfv3Uqln5Bq/Iw0g9OdoOyjsRoZllR2oPKe1odW5R92OoCAP4
         50jYyvqb8PbNfsN6oIMHseL7HIfw3RpPv1V7eHCEGAhgKaszvRFy8YnbMj2a5dkZ6t
         fjuxYrvVVtScU6mtQZQc24iGmLIU5pcKsh1rsE0wnioVElm+/ePN6aF8HqEqxmircl
         XlielzNba4thw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77E4860D02;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: phy: probe for C45 PHYs that return PHY ID
 of zero in C22 space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335760748.27474.16543294261653602256.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:40:07 +0000
References: <20210607023645.2958840-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210607023645.2958840-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 10:36:45 +0800 you wrote:
> PHY devices such as the Marvell Alaska 88E2110 does not return a valid
> PHY ID when probed using Clause-22. The current implementation treats
> PHY ID of zero as a non-error and valid PHY ID, and causing the PHY
> device failed to bind to the Marvell driver.
> 
> For such devices, we do an additional probe in the Clause-45 space,
> if a valid PHY ID is returned, we then proceed to attach the PHY
> device to the matching PHY ID driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: phy: probe for C45 PHYs that return PHY ID of zero in C22 space
    https://git.kernel.org/netdev/net-next/c/b040aab76323

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


