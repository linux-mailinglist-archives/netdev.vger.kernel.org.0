Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230BA349DD6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCZAa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhCZAaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A9D761A42;
        Fri, 26 Mar 2021 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718612;
        bh=lMMuc4dp09Oud66NMEEJ3qIidne6+GXH+y8z5e5M5+k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmQIoO2JAMM6jeOLnCC92ZoErYutIuSaD5kaiDjV0adJljWQA00B4G5uYuC2XtWPW
         CR2s8eMbZb1CgvRh1VlEkn9XhdU5mvFojr6tE50VTUj1rbwtkF7LmTSIDNTiqZ8bRQ
         K44aMAmnWPk5cU1nYZ2DW3epIHS7SlVz499s697ManFcp184y4nyQTZ4uab5vDXr5S
         juPnPxShdsK9jU4+vAy2qvSbcX46Inb+U5dYtV0enOpOUkHMdWSTuq+uR0OQ2avo/2
         Jr3IFAFuL6xeDPFDUg0Qzefky3XTN6QpSNBABpx23kdn2lPS4ErvQbMDp8fADMZCWh
         VBAfYe+iWDIpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 363F76096E;
        Fri, 26 Mar 2021 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: update registers for other versions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861221.2256.1947704332788484864.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:12 +0000
References: <20210325144437.2707892-1-elder@linaro.org>
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 09:44:31 -0500 you wrote:
> This series updates IPA and GSI register definitions to permit more
> versions of IPA hardware to be supported.  Most of the updates are
> informational, updating comments to indicate which IPA versions
> support each register and field.  But some registers are new and
> others are deprecated.  In a few cases register fields are laid
> out differently, and in these cases the changes are a little more
> substantive.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: update IPA register comments
    https://git.kernel.org/netdev/net-next/c/b8ecdaaaf328
  - [net-next,2/6] net: ipa: update component config register
    https://git.kernel.org/netdev/net-next/c/cc5199ed50f2
  - [net-next,3/6] net: ipa: support IPA interrupt addresses for IPA v4.7
    https://git.kernel.org/netdev/net-next/c/e666aa978a55
  - [net-next,4/6] net: ipa: GSI register cleanup
    https://git.kernel.org/netdev/net-next/c/4f57b2fa0744
  - [net-next,5/6] net: ipa: update GSI ring size registers
    https://git.kernel.org/netdev/net-next/c/42839f9585a0
  - [net-next,6/6] net: ipa: expand GSI channel types
    https://git.kernel.org/netdev/net-next/c/2ad6f03b5933

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


