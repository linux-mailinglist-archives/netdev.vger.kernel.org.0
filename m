Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245FB3DA21D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhG2LaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhG2LaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 07:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1903C60F23;
        Thu, 29 Jul 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627558207;
        bh=2e5SInslfL8UdNJgZY8KZwxJqEELR1t+TSPEQACVbsY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RP4+cn9gSQHxdQkYVkCuY34rBT0OlyCgR+tMAHKQvT0yyamWyQkWQ2xlJcTTFUCfq
         oN/N71/ANtZo6nwzbnb6K0ChhXNMgSHGgpWIIWnwRzRrcG5ZmAnM0Pn/PZQ4RsLxZT
         0sCui63RCSO67TH31UJypK8zvgSeDaD1dyBsvdQxLAxz1swXZBzi+N2v80+h7W2IPS
         vcsvSj1X8khIazkxcwLjQAMCkxjReslAixQWM/HNDR6G87M4iSm8JpNEzWeO6cm7nU
         0lrdjZNK9NFxboh1wa96Nyyms9THlTWTBVfyOXQeFloQVbDMITIrWsVKtXv28HhgH3
         b87T8x6otBvxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B4FA60A7B;
        Thu, 29 Jul 2021 11:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/12] nfc: constify, continued (part 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162755820704.26856.6157999905884570707.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 11:30:07 +0000
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     mgreer@animalcreek.com, bongsu.jeon@samsung.com,
        davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 12:40:10 +0200 you wrote:
> Hi,
> 
> On top of:
> nfc: constify pointed data
> https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
> 
> Best regards,
> Krzysztof
> 
> [...]

Here is the summary with links:
  - [01/12] nfc: constify passed nfc_dev
    https://git.kernel.org/netdev/net-next/c/dd8987a394c0
  - [02/12] nfc: mei_phy: constify buffer passed to mei_nfc_send()
    https://git.kernel.org/netdev/net-next/c/894a6e158633
  - [03/12] nfc: port100: constify several pointers
    https://git.kernel.org/netdev/net-next/c/9a4af01c35a5
  - [04/12] nfc: trf7970a: constify several pointers
    https://git.kernel.org/netdev/net-next/c/ea050c5ee74a
  - [05/12] nfc: virtual_ncidev: constify pointer to nfc_dev
    https://git.kernel.org/netdev/net-next/c/83428dbbac51
  - [06/12] nfc: nfcsim: constify drvdata (struct nfcsim)
    https://git.kernel.org/netdev/net-next/c/582fdc98adc8
  - [07/12] nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
    https://git.kernel.org/netdev/net-next/c/6c755b1d2511
  - [08/12] nfc: fdp: use unsigned int as loop iterator
    https://git.kernel.org/netdev/net-next/c/c3e26b6dc1b4
  - [09/12] nfc: fdp: constify several pointers
    https://git.kernel.org/netdev/net-next/c/3d463dd5023b
  - [10/12] nfc: microread: constify several pointers
    https://git.kernel.org/netdev/net-next/c/a751449f8b47
  - [11/12] nfc: mrvl: constify several pointers
    https://git.kernel.org/netdev/net-next/c/fe53159fe3e0
  - [12/12] nfc: mrvl: constify static nfcmrvl_if_ops
    https://git.kernel.org/netdev/net-next/c/2695503729da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


