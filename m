Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF63A361F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFJVmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhFJVmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 00E48613F1;
        Thu, 10 Jun 2021 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361204;
        bh=3GaA1H0Pb4mD3VvXV91rJtO+nzzcY1sOh0ghx+4YOiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hPkFijg6mPTYCVC73dHzGp9vOQ/hYg1vSj9LyUNZW1avAa/8mqjnjOIL2QVnA7t8g
         ZxplPavnPWj8sSyqU40/eUS7slZR9wOrjlJIM7NFujTahV4Z2OkHvNAwzMAVZ/77xu
         JzV1PVlp2PBLedlPvQL8sJohbNcg2K+7uv/A26tvz6sb5LeL5EN1bt31zAcEMiSZjp
         QhcEExZpf/aVy7CFed1Qc0rE9mgPHFpH0JbDeSA7NnDLL1XBAmn5e1yWvgmoeMlqES
         SYbNlbHDgNbrC2vRMEWX5eYW0vdJXwY3qtWDB0ZDlCUWZGoT7XXNDTIVcPjaZ9Puxr
         doCPQ/xaScncg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E431C60952;
        Thu, 10 Jun 2021 21:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH, net-next,
 v2] ibmvnic: Allow device probe if the device is not ready at boot
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336120392.23488.10694134296837837250.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:40:03 +0000
References: <20210610170835.10190-1-cforno12@linux.ibm.com>
In-Reply-To: <20210610170835.10190-1-cforno12@linux.ibm.com>
To:     Cristobal Forno <cforno12@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, sukadev@linux.ibm.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        davem@davemloft.net, kuba@kernel.org, tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 11:08:35 -0600 you wrote:
> Allow the device to be initialized at a later time if
> it is not available at boot. The device will be allowed to probe but
> will be given a "down" state. After completing device probe and
> registering the net device, the driver will await an interrupt signal
> from its partner device, indicating that it is ready for boot. The
> driver will schedule a work event to perform the necessary procedure
> and begin operation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ibmvnic: Allow device probe if the device is not ready at boot
    https://git.kernel.org/netdev/net-next/c/53f8b1b25419

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


