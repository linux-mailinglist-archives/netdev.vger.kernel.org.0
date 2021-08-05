Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A403B3E14B9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbhHEMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhHEMaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD30C61131;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628166606;
        bh=kJnlv/Ri0V9gM2yfZM4Q3E88EmUmEyodkSVmh+zjuYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fk40HdrCw85QwFz95ms01E5lXHmfPB0m1WvH4MwVfccGqW6el/Nck6ZfBosGKehpT
         zrjYsXuFn0UiRQA20GKwAhwKyItkOxxXBcJhOrhhfciljJHvGVRYd7ZYfHTHRLoJDf
         9KBFjz8b69iGrbRThfaIYBCd8j7pyJ9RhvFw7cM7+qYVTxbW8i9Fot35SiZD8+7FfH
         xyJXUCoko6BsRiLJmwXwH6UAohvK739JfemoxFk59+v5IgLkTfyGCPwoXcmVfmhgMC
         8M+k03VJGRv7/DwGyU5eHK6E8NCy0x0pb/jLQCZvtMwafaSv2Bu59eGplr1rhjK8ZB
         ZutJnO3X6ygww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C20FF60A72;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] GRO and Toeplitz hash selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816660678.5517.4095732932218620845.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:30:06 +0000
References: <20210805073641.3533280-1-lixiaoyan@google.com>
In-Reply-To: <20210805073641.3533280-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 07:36:39 +0000 you wrote:
> This patch contains two selftests in net, as well as respective
> scripts to run the tests on a single machine in loopback mode.
> GRO: tests the Linux kernel GRO behavior
> Toeplitz: tests the toeplitz has implementation
> 
> Coco Li (2):
>   selftests/net: GRO coalesce test
>   selftests/net: toeplitz test
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] selftests/net: GRO coalesce test
    https://git.kernel.org/netdev/net-next/c/7d1575014a63
  - [net-next,2/2] selftests/net: toeplitz test
    https://git.kernel.org/netdev/net-next/c/5ebfb4cc3048

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


