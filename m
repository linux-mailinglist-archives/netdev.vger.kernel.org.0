Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA334C0DE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhC2BK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE47B61954;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=kbFADyQCGIB0VnnzGLS/kPMihm3Op2yrg0+q3WSQ364=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qd0f/O4AXOZ6yE2BFry5pHIP7R69okLZIvt9h7RLhihceRRPYEHdDqBhItuJ7W+vU
         TfOa/jxq1iCWny+mh/Booj01RWyNVG+DO/BDIJDeZw1dj8UNKIpP/RGqNIcc5wyZif
         ILi6izFNRbRyl20hN7QKSpJTfmBA+ujWAmde510yVtbNduJQV2LBgaLKt5WcyYmUsD
         uLRJC5pfh1hmg9s03QTm2ZJ0G9PbJbITRs4AjoRRC/rgDZjoJKxW9nSDveWGMHDx1y
         lf+Z9vz9fH/ypJlCl7KiUfgaRcAzMZASTSu0ymNMEkGGgaRbqQqiIxVq3mlmLzb3aD
         mfuFhwdN6YS/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C796A60A57;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lantiq: Remove redundant dev_err call in
 xrx200_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020981.2631.10039529116001933341.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <1616841111-8722-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616841111-8722-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 18:31:51 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lantiq: Remove redundant dev_err call in xrx200_probe()
    https://git.kernel.org/netdev/net-next/c/d759c1bd2696

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


