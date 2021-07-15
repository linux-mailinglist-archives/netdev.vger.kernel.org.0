Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866593CA49D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGORnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhGORm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF4FF613CF;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626370805;
        bh=mrzZ2KGRKON/4FPt+DXco2b2MKIqM6+stJWfS+50zmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b6zQF5rZ9T0LMPIJRdfyU+RDo6YvyDG+sJlL1sHSA5qmsYuJ/ObRQTVo1s+w2gqXx
         0NbEdv5yp2fS8TYeMrwLH+jpUcvcDc5v0xb3UIcqIxCfDuXcCb7SMSZF9ABZ9WzuYK
         GlQOMPxf9h5rMAjnJWbQyUiHd0i0guLgslKKDDdhOhfOrLQiz2nF9gfEBP1ytXlrYF
         n5ybIaCroHAyeYf+z03NRe09EPmSKn63imhOMK6HNRjH3qRe5iDw8fSfR4M4QUE/G5
         u6Y4RwMPXG+czchqm8vmfmjU/kF8Ry8oUqzAjYko2ECnoF8j9TMwu7/KVC0oDQs3wH
         f74cJV6dMM/vw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E571560A37;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] liquidio: Fix unintentional sign extension issue on left
 shift of u16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637080493.16853.1349424784773313835.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:40:04 +0000
References: <20210714152343.144795-1-colin.king@canonical.com>
In-Reply-To: <20210714152343.144795-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org,
        rvatsavayi@caviumnetworks.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 16:23:43 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the u16 integer oct->pcie_port by CN23XX_PKT_INPUT_CTL_MAC_NUM_POS
> (29) bits will be promoted to a 32 bit signed int and then sign-extended
> to a u64. In the cases where oct->pcie_port where bit 2 is set (e.g. 3..7)
> the shifted value will be sign extended and the top 32 bits of the result
> will be set.
> 
> [...]

Here is the summary with links:
  - liquidio: Fix unintentional sign extension issue on left shift of u16
    https://git.kernel.org/netdev/net/c/e7efc2ce3d07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


