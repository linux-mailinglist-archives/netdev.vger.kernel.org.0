Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795A3367158
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244742AbhDURaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239320AbhDURam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E44FC61459;
        Wed, 21 Apr 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026208;
        bh=qyLLDcGhPFeBmxu3AtwJwPJ0LplI1y7ufowgb7Go+7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vEEvvqUyT/pUiFoWpWyiOfXgUVxIAf3QKXb0NJ7L7aciGK0Hpy1ftJ07+j3ruw6LS
         HsIsRoWnC3Wq+zt/AkR7weKhw5Nehu4f2KGwGV5SHK3SfT6VfvTl5e65IEgCMhSqef
         I8fKGuNPVmPiZKqdHWT2LlXY0cp4iUg6yAsE1R6VZ2oTacVbk5lSvSHnv3q+30tbRK
         +ScQie79wJrevC0NNyfM7a8Er6OcLNxSEn9JGYoO8jlo8AGWjqgpR5CR6N9Sf+FkcK
         SZfza2ncUMy/H67PZ+h/xMYjn64+3Ie+j/F1zCskM4aiU7y3rbGikIdYKk8p4T16AJ
         WzRYceiWjCVMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D84C560A39;
        Wed, 21 Apr 2021 17:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-04-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902620888.9844.8449355059297880345.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:30:08 +0000
References: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
In-Reply-To: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 09:03:35 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-04-21
    https://git.kernel.org/netdev/net/c/542c40957c05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


