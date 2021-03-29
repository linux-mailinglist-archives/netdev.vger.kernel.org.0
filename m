Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFE34DC7D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhC2XaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhC2XaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F068161988;
        Mon, 29 Mar 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617060609;
        bh=SPVzHuIbM+UzlzRdTkpHHdgQsmSrK449uqwYThxljfc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YwXNR6qp7ucL/zmdjgGIet8q38m4B7WA+3eCsmIdnxYIv3bPKXVmZkV/OnDjWSCHE
         5q08zfoYTR+EcOX9/RQq39anqGHv0WeFsEi5U18ccMZP3QkOb9THeLC1kMsCVBVf0R
         SABNAcqSuXUV6h2F2ft/+8bLgIZX0RaVSKsVF5F80lEU0zDG/vqjol270dYa5MJmYN
         OZnT9Tm+aMZXtU+el9FyZayPPJhlDwJ5YJMDNdaANiWpVWljq76c0PcvYp2rSgCrBG
         U1vO/qWIWD9Mx5qGLXyh7a6S8BhirmNbulB9u6xv/La6hxOexZ7+phxBY+Qm64+Vcl
         vfTQe/VjyGnhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E094760A1B;
        Mon, 29 Mar 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dt-bindings: net: bcm4908-enet: fix Ethernet generic
 properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706060891.18537.301095859684605439.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:30:08 +0000
References: <20210329153328.28493-1-zajec5@gmail.com>
In-Reply-To: <20210329153328.28493-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 17:33:28 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This binding file uses $ref: ethernet-controller.yaml# so it's required
> to use "unevaluatedProperties" (instead of "additionalProperties") to
> make Ethernet properties validate.
> 
> Fixes: f08b5cf1eb1f ("dt-bindings: net: bcm4908-enet: include ethernet-controller.yaml")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> [...]

Here is the summary with links:
  - [net] dt-bindings: net: bcm4908-enet: fix Ethernet generic properties
    https://git.kernel.org/netdev/net/c/4cd7bd599e27

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


