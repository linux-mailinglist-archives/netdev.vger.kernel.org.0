Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAEC4AF115
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiBIMLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiBIMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D0AE02462D;
        Wed,  9 Feb 2022 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61D69616DD;
        Wed,  9 Feb 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C03BEC36AE5;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408012;
        bh=ORcoVBsU9fItvTpvJVOP71pHbFHSfc6H7u7f3hTy4/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JJYpIK1jWh1+AHsEdfNDs/eTgnKo5HZA9YVcKXmeE4MOYpOdJvXo8Rk7gWj6lGr7k
         6ILifmEgDRkS7n47o+ZihhvUTwQKr4diDVxcKsrNXl/Pm0VebJmzH79LWv7ZhQ7ome
         nfhDyQKo1yKKzrGkmcGWQE4TlNQOMN0rmg6IZxmBPvp/njyfgOpi6Qtv/5I3jP1WAE
         XFo0drYj2c39cBq/xp8ZagC/yeJupMomMYircAuktw1KsNOXYt7JXTUioJN4CzPH2s
         Aglb2yJ7oeNS2MVRjG9xEnowueHxivNc0S/vqMtQy64/fJiJmHX9gFpoCSrWTjpqmt
         xmPePrkraH6fA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC13FE6D4A2;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 1/2] dt-bindings: net: renesas,etheravb:
 Document RZ/V2L SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440801270.11178.8562719751986010323.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:12 +0000
References: <20220206202425.15829-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220206202425.15829-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        s.shtylyov@omp.ru, sergei.shtylyov@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, geert+renesas@glider.be,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  6 Feb 2022 20:24:24 +0000 you wrote:
> Document Gigabit Ethernet IP found on RZ/V2L SoC. Gigabit Ethernet
> Interface is identical to one found on the RZ/G2L SoC. No driver changes
> are required as generic compatible string "renesas,rzg2l-gbeth" will be
> used as a fallback.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] dt-bindings: net: renesas,etheravb: Document RZ/V2L SoC
    https://git.kernel.org/netdev/net-next/c/654f89f9496d
  - [net-next,2/2] dt-bindings: net: renesas,etheravb: Document RZ/G2UL SoC
    https://git.kernel.org/netdev/net-next/c/5e2e8cc9dd33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


