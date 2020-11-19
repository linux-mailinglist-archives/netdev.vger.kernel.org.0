Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92982B88E1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgKSAAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSAAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:00:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605744007;
        bh=41YbvG3NKotkaWDErGL3hKBNxh3V5X1Nv3NXyz2oTho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DK7/AgvuUmAP6q2wi5E2OLWSOo7/HpG+AdsKUTdJC4NyZW2mMFLiaYOT+8SErgGfL
         +EhZqfpoO6Xxmb5FqI/y5dfTp14RiNO9T4RXKA1RJWJ/arfop9gBfNkic5FM8hYjKN
         Runa4ygtVd2SrAuI8O8ChR+mJbwT0knib38L20Lc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: ipa: IPA register cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160574400729.27158.16846081422739604378.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 00:00:07 +0000
References: <20201116233805.13775-1-elder@linaro.org>
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Nov 2020 17:37:54 -0600 you wrote:
> This series consists of cleanup patches, almost entirely related to
> the definitions for IPA registers.  Some comments are updated or
> added to provide better information about defined IPA registers.
> Other cleanups ensure symbol names and their assigned values are
> defined consistently.  Some essentially duplicate definitions get
> consolidated for simplicity.  In a few cases some minor bugs
> (missing definitions) are fixed.  With these changes, all IPA
> register offsets and associated field masks should be correct for
> IPA versions 3.5.1, 4.0, 4.1, and 4.2.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: ipa: share field mask values for IPA hash registers
    https://git.kernel.org/netdev/net-next/c/4d715380b4b8
  - [net-next,02/11] net: ipa: make filter/routing hash enable register variable
    https://git.kernel.org/netdev/net-next/c/5f87d77bb3bd
  - [net-next,03/11] net: ipa: support more versions for HOLB timer
    https://git.kernel.org/netdev/net-next/c/6833a0967300
  - [net-next,04/11] net: ipa: fix two inconsistent IPA register names
    https://git.kernel.org/netdev/net-next/c/f3ae1616c54d
  - [net-next,05/11] net: ipa: use _FMASK consistently
    https://git.kernel.org/netdev/net-next/c/c3bf353fdbf2
  - [net-next,06/11] net: ipa: fix BCR register field definitions
    https://git.kernel.org/netdev/net-next/c/fb14f7229122
  - [net-next,07/11] net: ipa: define enumerated types consistently
    https://git.kernel.org/netdev/net-next/c/8701cb00d78a
  - [net-next,08/11] net: ipa: fix up IPA register comments
    https://git.kernel.org/netdev/net-next/c/3413e61337de
  - [net-next,09/11] net: ipa: rearrange a few IPA register definitions
    https://git.kernel.org/netdev/net-next/c/74fbbbbe80d1
  - [net-next,10/11] net: ipa: move definition of enum ipa_irq_id
    https://git.kernel.org/netdev/net-next/c/322053105f09
  - [net-next,11/11] net: ipa: a few last IPA register cleanups
    https://git.kernel.org/netdev/net-next/c/716a115b4f5c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


