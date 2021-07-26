Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBBD3D6929
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhGZVTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233349AbhGZVTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 17:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1180860F90;
        Mon, 26 Jul 2021 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627336805;
        bh=mR683BInAPIEhzlSDYxQJOwD8m9r5lIkSzgH9q5FLA4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CljxrMcLpN7tqVmkVcNDRVgNMO74GKvV7yv7CRH6aokk0SeO62yiNIs6r/HKQ6ziT
         PzAcX7whPonuBPTk9fL/R0cMqLlzZyXI9IH3Nc7yvKfc7ZhmupVs0GWaIBw3m3iNRG
         c4HSnQ4rxLFFRufUYopPSmxp0+n4gwtZWy5IwONByunL+hqKTDooc8Ob8ZZtacjEmC
         5KqIxQQnFzO7hmYbSMawMmb2Mz054CycPCz6hJH/za3qx8qC6TlYxpf8mN2VBXg2n2
         oe5dp+1twCGyJMT1yMMiLmymCU1JWmCJ3lU2ufDWg40ghiGYZIrtS88wkSI6m4CMI/
         nuErtfkfV8zAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 05FF060972;
        Mon, 26 Jul 2021 22:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: ipa: enable inline checksum offload for IPA
 v4.5+
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733680501.7201.5058653470686936386.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 22:00:05 +0000
References: <20210726164504.323812-1-elder@linaro.org>
In-Reply-To: <20210726164504.323812-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 11:45:04 -0500 you wrote:
> The RMNet and IPA drivers both support inline checksum offload now.
> So enable it for the TX and RX modem endoints for IPA version 4.5+.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_data-v4.11.c | 2 ++
>  drivers/net/ipa/ipa_data-v4.5.c  | 2 ++
>  drivers/net/ipa/ipa_data-v4.9.c  | 2 ++
>  3 files changed, 6 insertions(+)

Here is the summary with links:
  - [net-next,1/1] net: ipa: enable inline checksum offload for IPA v4.5+
    https://git.kernel.org/netdev/net-next/c/22171146f84b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


