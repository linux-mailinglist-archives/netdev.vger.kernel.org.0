Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44141FC36
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhJBNV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhJBNVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 239D661B22;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180808;
        bh=gzWtNCXPRi8tN5DvO2wbmOmld72IDjZ/X83FPCYtHRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SqzF1KCSPguLXD/5cx3PrdY1AeyqGJJ+N83Qr9SQectlK2/Ck244QXSDsSC3feDdt
         2Nz9ATc/cwr6gL0S2TF/6uX+Pmt+fGkezIXzTAG1fzHSdKCjPr12F8C+7dFz/SrXEM
         lL4zsNhYc2LVOnNB9oFQoMkgC6TG8JqPMyvdWbTc5IEQmFOWRa23U2XvvAFl/+Bt1l
         SIZSrKVgsA9MqsJGtWFOYdwsIBXUIjLh5qDv06S9HdcQgYLIvFhpighGfOs9ufNnx+
         5w8fiznHVAQ0ar5qcZF5OEDIVTFZIfZBlwkj7csj9BdOshimU893/UvJp0RruOuHG5
         kCn0fYPvs3p8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19C1B60C18;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: renesas,etheravb: Update example to match
 reality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318080810.29287.9786010853202402377.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:20:08 +0000
References: <7590361db25e8c8b22021d3a4e87f9d304773533.1633090409.git.geert+renesas@glider.be>
In-Reply-To: <7590361db25e8c8b22021d3a4e87f9d304773533.1633090409.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 14:13:55 +0200 you wrote:
> - Add missing clock-names property,
>   - Add example compatible values for PHY subnode.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - dt-bindings: net: renesas,etheravb: Update example to match reality
    https://git.kernel.org/netdev/net-next/c/f533bc14e21a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


