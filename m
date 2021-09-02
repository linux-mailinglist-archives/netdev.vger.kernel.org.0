Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF53FEDC7
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhIBMbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhIBMbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 08:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0718161059;
        Thu,  2 Sep 2021 12:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630585806;
        bh=4j7xNuOIngY6lu5Isc4EMtdVmQkz7acNQNoRlVoqUJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tkh7VaO9ftUt+U6nENmi4wZaWFPvxLdxMOd7uTXf46NvTB1lKWSPqmCich/KOPjsx
         28yiQ6xbDiT9Vhu9n4bjLKWFgHOSNV3l/tqUsvyZdcZBRpHP0ZLlviQ7WyTDZd8oK1
         0wHxjj4m+HosNLbrClsOgrmAixFSArJCKppA6HQERj8WDL2VKQWWAmo18FeetaM3B+
         hFaE784UvBrsKM/SE9jyE7VvfcUd7OE7AeUinuUnmB4EYqcCZ+2Ghcs0a7Op1D+cCg
         nJsOY20sPscaf0JFTKA5RmR1wSftoohkezPsJfztrMaWkF5Mu6F6H0ZfreHBdVeB+5
         rZT9hQqPgnmNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB55360A17;
        Thu,  2 Sep 2021 12:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit
 LN920
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163058580595.2825.9991854730997719956.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 12:30:05 +0000
References: <20210902105122.15689-1-dnlplm@gmail.com>
In-Reply-To: <20210902105122.15689-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, oliver@neukum.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 12:51:22 +0200 you wrote:
> Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit LN920
> 0x1061 composition in order to avoid bind error.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/net/usb/cdc_mbim.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
    https://git.kernel.org/netdev/net/c/aabbdc67f348

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


