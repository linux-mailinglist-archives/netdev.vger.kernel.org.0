Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3651386CF3
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343815AbhEQWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242110AbhEQWb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AF096611ED;
        Mon, 17 May 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621290609;
        bh=rZSy1iCZ1/bDOfUbvqiIU2gNPg5JQ99zZGwAsHuu/Po=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=csVqaRgpTID1rJsSThjil9/bRohXSSZJLkebWlJ/h3glJm4cYB9dhBKhLR15RoIDr
         IzF5N4C2Nu/DGIrDcoyaijfaSIXAEs0Ze5S2Hddz//hS+SpBQV2IFkN55arKtSzLB3
         mA1HCGFf8Yw6PJ9Ghq+l+tlijo62qAE11j+bvMBW4mKZ1/WszBMR0HVWfMNxtCL+85
         r+ERmRVde7NBT0BWTOzXfO2mxC6LD3KFl7gdHXv2inQ+b/0fE3wcuvJiRpjwrrKALR
         8UGslTuDa2j9vi0Vp8B6/vH9mf9xSNlSenEj4P/W75M86WfaAwYP298dlxicBQMflI
         yrY6WeVLPTxVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A384560A4F;
        Mon, 17 May 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: net: remove stale website link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129060966.6973.9422539993556940727.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:30:09 +0000
References: <20210517141954.56906-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210517141954.56906-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 10:19:54 -0400 you wrote:
> The http://www.linuxfoundation.org/en/Net does not contain networking
> subsystem description ("Nothing found").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - MAINTAINERS: net: remove stale website link
    https://git.kernel.org/netdev/net/c/3c814519743a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


