Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF630C6E4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbhBBRDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237057AbhBBRAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 425B664E9A;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612285208;
        bh=a4SpeF1zNUPFma/TE5v/+Qm8Q3g8jfxU8nzdmkBK4RU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tklw4NcWQ3PD2jwsw+9u0o0PRminp8pbYmkN7eYaOhxAPZ36TSKlg1XxpCn64zbSf
         gclu0ghPO5U5KNiM0ZhDiwnLXvwwSp26qvx8gjUXbi2jLG8yQi5JJo9H7jH9aT6Paq
         g50fjktMn4PnIoP3ObwBYC6bSEABAtTNJv68IExFHWASzPN8jSZxIgZkAj7980IbB7
         MeXFin8EMLt5bUfgLaZDcoWxTpbow3mC+1ZW219ltRV+szJ8V+aNlpbjQWBl76ZMwf
         tC8HX+EfhIusoNSfHToItthhnI2dLzbALdnys4rweLoRwJ0mIvlrfXb6wYIfrEC2Ul
         ZnEVibwNA/vYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3295A609E1;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: ipa: a few bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228520820.27951.3321264627733368250.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 17:00:08 +0000
References: <20210201232609.3524451-1-elder@linaro.org>
In-Reply-To: <20210201232609.3524451-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Feb 2021 17:26:05 -0600 you wrote:
> This series fixes four minor bugs.  The first two are things that
> sparse points out.  All four are very simple and each patch should
> explain itself pretty well.
> 
> 					-Alex
> 
> Alex Elder (4):
>   net: ipa: add a missing __iomem attribute
>   net: ipa: be explicit about endianness
>   net: ipa: use the right accessor in ipa_endpoint_status_skip()
>   net: ipa: fix two format specifier errors
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: ipa: add a missing __iomem attribute
    https://git.kernel.org/netdev/net/c/e6cdd6d80bae
  - [net,2/4] net: ipa: be explicit about endianness
    https://git.kernel.org/netdev/net/c/088f8a2396d8
  - [net,3/4] net: ipa: use the right accessor in ipa_endpoint_status_skip()
    https://git.kernel.org/netdev/net/c/c13899f18728
  - [net,4/4] net: ipa: fix two format specifier errors
    https://git.kernel.org/netdev/net/c/113b6ea09ccd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


