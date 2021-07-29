Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A993DA6D2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhG2OuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237350AbhG2OuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 10:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6E1160EE6;
        Thu, 29 Jul 2021 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627570205;
        bh=N83vUm64NlkHsfA8TCWyYSdlzTuALn97KMNARtdBHoo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UDpiQ3JQed1iVyWUb0iYRIRfdJBmMKqk+9ZHWJWQxiK8qgOpacwHJGydedYXwuzMd
         Rb8pr+g7eEewvOqkbKRA1HmNmu/BvQgcy4OaVF1deHChPVO2OKXAAauVhi5Komfl+H
         qQ00PmBf/aWC/i5SF0JmscmuVpT6pZ0IsNT89krjLo0vmblX36pg3rjGDHDUm7pVdL
         L+lWRo0fnL6ln43U06yLsGn3glh+lcWN062/dblIjrT90Oo/jhZc2BkMouxIiUpVjS
         9ApmxOZenOeKjap/JwSJi0/eyVI6UZhzWsFsVn/zKqaOwz9nEdPY+TlLu2fk+TqQpT
         Q4aYjqcaXM05A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E53960A59;
        Thu, 29 Jul 2021 14:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Remove the qed module version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162757020564.26339.1638465060110774440.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 14:50:05 +0000
References: <20210729100011.10090-1-pkushwaha@marvell.com>
In-Reply-To: <20210729100011.10090-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        malin1024@gmail.com, smalin@marvell.com, aelior@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 13:00:11 +0300 you wrote:
> From: Shai Malin <smalin@marvell.com>
> 
> Removing the qed module version which is not needed and not allowed
> with inbox drivers.
> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - qed: Remove the qed module version
    https://git.kernel.org/netdev/net-next/c/7a3febed4455

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


