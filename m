Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724513662B9
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhDUAAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhDUAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA56761417;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963210;
        bh=7KebMaxvqUVosMG1sUtctPOejw6S2PvpoPYndt3MxA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UsZQYUKCl44MYoi52wLH+EIuqsa+F9Wh0lClVh8bFS4UTpOs+/Lz+bnI1u5UDQKpA
         PopsoM008qAl8AWb6WhAyVI2cVh3uo7qp9K84e122c10zOB20jiBc2VvZEU9NEP6au
         C9F6Ud4TjAU45mlU6Ck3sJjQp+USGDv5yI+g2foyow5KneIDQLib9YB4exLviQAcax
         6RrCQKv1mALibvDu0kCXqgoHfUAKZG6bIIFS7oX22VX/T5Bgk1ajg9xl9qa0BCC86p
         78MiS4c41T9l/km9bvvxLNMsRwmVjDCUv4X5jE37iBLHCbxrEKQFAIkde6XXHee+Cd
         Gv8u8AZzhgjsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C238A60A39;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: Fix bit ops double shift
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896321079.2554.14735894367515771017.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:00:10 +0000
References: <1618945797-11091-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1618945797-11091-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 21:09:57 +0200 you wrote:
> bit operation helpers such as test_bit, clear_bit, etc take bit
> position as parameter and not value. Current usage causes double
> shift => BIT(BIT(0)). Fix that in wwan_core and mhi_wwan_ctrl.
> 
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: Fix bit ops double shift
    https://git.kernel.org/netdev/net-next/c/b8c55ce266de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


