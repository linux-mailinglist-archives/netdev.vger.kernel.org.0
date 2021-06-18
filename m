Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF393AD276
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhFRTCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhFRTCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D610F611B0;
        Fri, 18 Jun 2021 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042803;
        bh=A2Rlmp2CAn41txesR3WXlK2V201i9HjRH+7b5YHh1oI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GevRAvQPV5we6Vq8rxZwbM2uM2sQZLi+sNjkHXsx1dM9rUpMmZSOeKGp5rQjEdhRN
         CP+cpdiCZN8YRuuqvLqMCyKedU7phdlKHIkBD3hZ1Q+Yu+GCk4A0tPNcZaBc77baa9
         wQbHpj8H+UBmaW5GeyeKVTFMsA1Ey+2sD2d9Ir5+9jQAMyfj2CVOmSAuWczMusgxOD
         nxvEPge1/YUclaVSJqCzg7Th/uyp5NRf9TU5bUDCZ/OeA6C3Ux2GeF6+oZHi9UiwZ3
         yan9ScWEMnv+y7AnnzMvv9lyh6dp3YYdJhDhMN6PhhRdIz0n/44hWZJkxIL3gOOKeR
         l1pZoynqji7TA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8C6360CDF;
        Fri, 18 Jun 2021 19:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2] cxgb4: fix wrong shift.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404280381.1350.4674309237695129409.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:00:03 +0000
References: <20210618092948.GA19615@duo.ucw.cz>
In-Reply-To: <20210618092948.GA19615@duo.ucw.cz>
To:     Pavel Machek <pavel@denx.de>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        colin.king@canonical.com, rajur@chelsio.com, kuba@kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 11:29:48 +0200 you wrote:
> While fixing coverity warning, commit dd2c79677375 introduced typo in
> shift value. Fix that.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> Fixes: dd2c79677375 ("cxgb4: Fix unintentional sign extension issues")

Here is the summary with links:
  - [PATCHv2] cxgb4: fix wrong shift.
    https://git.kernel.org/netdev/net/c/39eb028183bc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


