Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4938978E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhESULe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232864AbhESULa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:11:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B142D61363;
        Wed, 19 May 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455009;
        bh=YUy2bzxwS1O7akO+aDYOgRvz95Vr3MgoLXF4XLOK8jU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TKxiNJ+r0WR1GDM2jFgGs/GbFrP5Mv7lIt9dHm98R+56+hSs83930megSLg3JTq82
         WK9isM+2pnYMWqcPlrnhF0VloYKj1wXgGVpD83JsEDHj7IG+kq80I64y7BlCF5OX51
         dsrMlCLCB4mkiuQx1upo3VVzHMm59Q3eA6IifIQA+gZTMY58TpgrpB+43fB5drrTH1
         qT1S191i+2VnYU3xmXCW0TzWSyvv0z6inwelY0+xwVptgxnsG/wd+A+Q11TcGRO5HA
         dRqD+7ju3ZoQMh8tIdS4+LW1wx+lkTAluPR+UtKIczNd9XJVqi9lD6Ye9HKG5UghDe
         vCZDhgnTC5HVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6E8660A56;
        Wed, 19 May 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: renesas,ether: Update Sergei's email
 address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145500967.9091.18142980397422047683.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:10:09 +0000
References: <15fb12769fcfeac8c761bf860ad94b9b223d3f9c.1621429311.git.geert+renesas@glider.be>
In-Reply-To: <15fb12769fcfeac8c761bf860ad94b9b223d3f9c.1621429311.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        sergei.shtylyov@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 19 May 2021 15:02:53 +0200 you wrote:
> Update Sergei's email address, as per commit 534a8bf0ccdd7b3f
> ("MAINTAINERS: switch to my private email for Renesas Ethernet
> drivers").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - dt-bindings: net: renesas,ether: Update Sergei's email address
    https://git.kernel.org/netdev/net/c/d5b3bd6ab541

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


