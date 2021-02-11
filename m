Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EFF31965E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhBKXK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:10:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBKXK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:10:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D93864DF3;
        Thu, 11 Feb 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613085015;
        bh=3W+NfG/227zgVuVW8j482opu8W0/YdUsj820YcNKt80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mH/zODjpiMjsx2rRazPKKToA90rKQ5A/F4P7LoXNXiV6bFcVVNsDFVjWrtlCyrtzO
         pB0kwnx/sJUCj8zVJ9Cebwl7BMV2qeZg1VLmB9Ijjy+Df04tji4hU7EHhoOcTXSsNz
         0uDyu90EXzZE32EPTrQN/eCePQxkbAhCyUr0UpT/R7ZwlVtBIRQSdemIbRnuBeDDAJ
         Ar23wGFQvWPrtkBfW5KLDNUgfb4+MlObdYK0cpQrLqIMdvxgtbv8vu5SmyXc1us3GS
         uw0d0E+mfSDty+GrkH7qanM7INRkbgHWFRmORrUFBzGYcUEoqw+Z3jHTjtER0TTbWL
         YMqUNMFQMymrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A307609D6;
        Thu, 11 Feb 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 5.12 0/8] bcm4908_enet: post-review fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308501543.27196.4327749060967319260.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 23:10:15 +0000
References: <20210211121239.728-1-zajec5@gmail.com>
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, rdunlap@infradead.org, masahiroy@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 13:12:31 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> V2 of my BCM4908 Ethernet patchset was applied to the net-next.git and
> it was later that is received some extra reviews. I'm sending patches
> that handle pointed out issues.
> 
> David: earler I missed that V2 was applied and I sent V3 and V4 of my
> inital patchset. Sorry for that. I think it's the best to ignore V3 and
> V4 I sent and proceed with this fixes patchset instead.
> 
> [...]

Here is the summary with links:
  - [net-next,5.12,1/8] dt-bindings: net: rename BCM4908 Ethernet binding
    https://git.kernel.org/netdev/net-next/c/6710c5b0674f
  - [net-next,5.12,2/8] dt-bindings: net: bcm4908-enet: include ethernet-controller.yaml
    https://git.kernel.org/netdev/net-next/c/f08b5cf1eb1f
  - [net-next,5.12,3/8] net: broadcom: rename BCM4908 driver & update DT binding
    https://git.kernel.org/netdev/net-next/c/9d61d138ab30
  - [net-next,5.12,4/8] net: broadcom: bcm4908_enet: drop unneeded memset()
    https://git.kernel.org/netdev/net-next/c/af263af64683
  - [net-next,5.12,5/8] net: broadcom: bcm4908_enet: drop "inline" from C functions
    https://git.kernel.org/netdev/net-next/c/7b778ae4eb9c
  - [net-next,5.12,6/8] net: broadcom: bcm4908_enet: fix minor typos
    https://git.kernel.org/netdev/net-next/c/e39488117203
  - [net-next,5.12,7/8] net: broadcom: bcm4908_enet: fix received skb length
    https://git.kernel.org/netdev/net-next/c/195e2d9febfb
  - [net-next,5.12,8/8] net: broadcom: bcm4908_enet: fix endianness in xmit code
    https://git.kernel.org/netdev/net-next/c/bdd70b997799

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


