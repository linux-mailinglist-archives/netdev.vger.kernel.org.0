Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9E734110D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhCRXam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhCRXaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B48964F30;
        Thu, 18 Mar 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616110209;
        bh=xnRgZ062R2Wp3UDdgv8kVVZD4Z8eu/Bi7p9TSIEZFxc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rRf2ejkG0Fa2te8d0dYpSap7SW1XkXOqAeulsvwzcM8J5h+QUCaUXBaF5IIBgNx8H
         H338L/oSgaNlP7RT/pdceZ2suJq7xqiSi8AsJ7/0UJCT+RRUGj93flDcJ33FbfUKiA
         kX/jmMxwTCp3cNSKhB7oahNDQhETIwPAIyq1bVm9dlz2T4TEfPJBQnCLkeyIQRwSH3
         qvCKHY1PIaOtXHtDEZHq7kohgVZdSJlZnaRtd5t57Ju/rhcAg0n7W3wPBsuES69kIz
         21Vz8AVBet8P6eW4QKU6w50gPQFFKLbJ7qvJ41h4SCH7UfZ6bVo767W7FGbo2taV8w
         H6fjYVz0nRxFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CBCB6097B;
        Thu, 18 Mar 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: ipa: support 32-bit targets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161611020924.24048.7584803726508446472.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 23:30:09 +0000
References: <20210318185930.891260-1-elder@linaro.org>
In-Reply-To: <20210318185930.891260-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 13:59:26 -0500 you wrote:
> There is currently a configuration dependency that restricts IPA to
> be supported only on 64-bit machines.  There are only a few things
> that really require that, and those are fixed in this series.  The
> last patch in the series removes the CONFIG_64BIT build dependency
> for IPA.
> 
> Version 2 of this series uses upper_32_bits() rather than creating
> a new function to extract bits out of a DMA address.  Version 3 of
> uses lower_32_bits() as well.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: ipa: fix assumptions about DMA address size
    https://git.kernel.org/netdev/net-next/c/d2fd2311de90
  - [net-next,v3,2/4] net: ipa: use upper_32_bits()
    https://git.kernel.org/netdev/net-next/c/3c54b7be5d36
  - [net-next,v3,3/4] net: ipa: fix table alignment requirement
    https://git.kernel.org/netdev/net-next/c/e5d4e96b44cf
  - [net-next,v3,4/4] net: ipa: relax 64-bit build requirement
    https://git.kernel.org/netdev/net-next/c/99e75a37bd0a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


