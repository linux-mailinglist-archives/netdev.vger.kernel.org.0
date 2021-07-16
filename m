Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333E83CBCCA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 21:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhGPTnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 15:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhGPTnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 15:43:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 835BA613EB;
        Fri, 16 Jul 2021 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626464430;
        bh=yy3lgzUv8c1hezgnRSueqAhnq8qdRsPvZZMExvBL9ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VsvM5esBWErc9ifFp1rySZVY0gQbEdYGS80SSJlbqxl1Eh8pdzz+jlaiXTYb4Ky/G
         RakiafNe52KhwlxaqZCjHNAF7Cwnt4ZRGjTUOlhXpw+/sE8/r/8AaVS3TgSkxWWLGp
         72elzNi15WIqqWjhBr5tXO6mwBn//0HnR2RHO6hpu+qNOoB4ErcxmTLmGq6/w7u18E
         faQCa+Te7mrs/nrOUyF9pCgXYCi2Rtd7cUjZJK5gACyl5pIQmihork4t9KPYBVG/u+
         FtgkFdaB1vQQpl5DszQG6UABKLJR8gAenDmQ6gE/FooDW25+R07/FjM3q129ruXGVV
         xSCuSs15DRMPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77744609EF;
        Fri, 16 Jul 2021 19:40:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V1 0/3] dt-bindings: net: fec: convert fsl,*fec bindings to
 yaml
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646443048.11536.12063272896536154628.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 19:40:30 +0000
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, bruno.thomsen@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 18:29:08 +0800 you wrote:
> This patch set intends to convert fec binding into scheme, and fixes
> when do dtbs_check on ARCH arm.
> 
> One notice is that there are below logs for some dts when do dtbs_check:
> 	ethernet@2188000: More than one condition true in oneOf schema:
> We found that fec node in these dts all have "interrupts-extended"
> property, and schema default is:
>          'oneOf': [{'required': ['interrupts']},
>                    {'required': ['interrupts-extended']}],
> so we don't know if it is a common issue or need be fixed in specific
> bindings.
> 
> [...]

Here is the summary with links:
  - [V1,1/3] dt-bindings: net: fec: convert fsl,*fec bindings to yaml
    https://git.kernel.org/netdev/net-next/c/96e4781b3d93
  - [V1,2/3] ARM: dts: imx35: correct node name for FEC
    https://git.kernel.org/netdev/net-next/c/95740a9a3ad9
  - [V1,3/3] ARM: dts: imx7-mba7: remove un-used "phy-reset-delay" property
    https://git.kernel.org/netdev/net-next/c/86a176f485b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


