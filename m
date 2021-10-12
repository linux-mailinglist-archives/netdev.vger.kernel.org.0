Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C06F429A47
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbhJLAMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235753AbhJLAMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 20:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB86860F3A;
        Tue, 12 Oct 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633997409;
        bh=ELHpK8xz4vQA8Tv2SU+NIPkYoNnsj5JErkWWiMYVkXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UaYzglY0p/Lp3+GSWU+4YVNuSXFX2mzGSzWPypYcPLSRpLovYIoaLqIuBD7fXoDq8
         /9BHZ0BqGfk7CkXbR15j19IN5YzBPDJGTK3zJU/zrQ0u9myrlJJa3NZk8ZT+tILWk4
         RMDgeMwSVLgF/E/Zh9q35ILHqSOpXaoPMuJEvrOTt+nBHB7q7VMcB/9nybamswH1zz
         FYpnXsAhY3MOedo24Imi33Of6Nk9ykjDWC5H11geIfucY8Gnizi0FZXxs2fPLkKR8V
         f4DZ9lBBHUdKdnXt5h723P3xvrorEuZNkWAov0UHizlrO9cR6VgpsN6tqnNasQ5Iwk
         F1H1AK5hb1clQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBD27609AB;
        Tue, 12 Oct 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/7] nfc: minor printk cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163399740889.30056.14308792441517445393.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 00:10:08 +0000
References: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     k.opasiak@samsung.com, mgreer@animalcreek.com, davem@davemloft.net,
        kuba@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        joe@perches.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Oct 2021 15:38:28 +0200 you wrote:
> Hi,
> 
> 
> Changes since v2:
> 1. Correct SPDX license in patch 2/7 (as Joe pointed out).
> 
> Changes since v1:
> 1. Remove unused variable in pn533 (reported by kbuild).
> 
> [...]

Here is the summary with links:
  - [v3,1/7] nfc: drop unneeded debug prints
    https://git.kernel.org/netdev/net-next/c/5b25a5bf5e04
  - [v3,2/7] nfc: nci: replace GPLv2 boilerplate with SPDX
    https://git.kernel.org/netdev/net-next/c/f141cfe364ef
  - [v3,3/7] nfc: s3fwrn5: simplify dereferencing pointer to struct device
    https://git.kernel.org/netdev/net-next/c/edfa5366ef42
  - [v3,4/7] nfc: st-nci: drop unneeded debug prints
    https://git.kernel.org/netdev/net-next/c/84910319fad4
  - [v3,5/7] nfc: st21nfca: drop unneeded debug prints
    https://git.kernel.org/netdev/net-next/c/e52cc2a625a6
  - [v3,6/7] nfc: trf7970a: drop unneeded debug prints
    https://git.kernel.org/netdev/net-next/c/f0563ebec68f
  - [v3,7/7] nfc: microread: drop unneeded debug prints
    https://git.kernel.org/netdev/net-next/c/f41e137abd25

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


