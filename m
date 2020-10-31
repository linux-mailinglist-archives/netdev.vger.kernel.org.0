Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12E2A1A92
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgJaUkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgJaUkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 16:40:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604176804;
        bh=LNK9wWhaB4HN3AIOnL/TFE7I4MvCNkjmqcvjoonYyHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I24ypDPOT3iPrh51g86L0Wbt0jcCaQkLlSupkUAgjySBBrkexiliRIyIsllVcOV/e
         bA6Wox/pHN4+8MK+xT7jUCkrf4cLGmg9uUvSNnSbRX+9mgicR4b1dwZsDpAzadRyXE
         dXCkOpqLakSGCH3Uy66EL9XusKxxWMMzVDoBQpLE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: avoid a bogus warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160417680446.8931.2811207306443585655.git-patchwork-notify@kernel.org>
Date:   Sat, 31 Oct 2020 20:40:04 +0000
References: <20201031151524.32132-1-elder@linaro.org>
In-Reply-To: <20201031151524.32132-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Oct 2020 10:15:24 -0500 you wrote:
> The previous commit added support for IPA having up to six source
> and destination resources.  But currently nothing uses more than
> four.  (Five of each are used in a newer version of the hardware.)
> 
> I find that in one of my build environments the compiler complains
> about newly-added code in two spots.  Inspection shows that the
> warnings have no merit, but this compiler does not recognize that.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: avoid a bogus warning
    https://git.kernel.org/netdev/net-next/c/624251b4b5a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


