Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87E33D8E41
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhG1MuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235159AbhG1MuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A14A460FC0;
        Wed, 28 Jul 2021 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627476606;
        bh=c7cmXFD6ILJ07Ag2y2T5Gac+uLpZFYPDDHu1w7USR04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uryZv+vrFsxQyU8xrN8YbUM8OI8l+4LSYzadHuEMGTHTUhPhCxQSl8AYmInjPZ8VI
         WJ9+3pMOZJB7X4jCqZg9O/JSHLePFSzYoP1FJVoh9sAvjSaUgBYkgBK5Mz8iN2NtmC
         xU9R90AmI/ykKmISRz8qMz5Rb5Qu02dIzZUcyojMr8LsXFwX4Y9n6VZcpQ9HHnkJeJ
         6nOP2hKXTCQg7VhoCr0MFxASzhJB32lnoOIdmwxZtRHuOeK7QJczhB6hH2UyylCFzs
         aFQBCQ31ZHyXnT5Mdbhw9BEhMZqsaHFPb8Ki13OrkYzHgTmKSIfDtJuPHd879yeCH2
         L863yFWaMnBRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A84760A6C;
        Wed, 28 Jul 2021 12:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/7] net: fec: add support for i.MX8MQ and i.MX8QM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162747660662.5429.7423683699651350875.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 12:50:06 +0000
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 19:51:56 +0800 you wrote:
> This patch set adds supports for i.MX8MQ and i.MX8QM, both of them extend new features.
> 
> ChangeLogs:
> V1->V2:
> 	* rebase on schema binding, and update dts compatible string.
> 	* use generic ethernet controller property for MAC internal RGMII clock delay
> 	  rx-internal-delay-ps and tx-internal-delay-ps
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/7] dt-bindings: net: fsl,fec: update compatible items
    https://git.kernel.org/netdev/net-next/c/5d886947039d
  - [V2,net-next,2/7] dt-bindings: net: fsl,fec: add RGMII internal clock delay
    https://git.kernel.org/netdev/net-next/c/df11b8073e19
  - [V2,net-next,3/7] net: fec: add imx8mq and imx8qm new versions support
    https://git.kernel.org/netdev/net-next/c/947240ebcc63
  - [V2,net-next,4/7] net: fec: add eee mode tx lpi support
    https://git.kernel.org/netdev/net-next/c/b82f8c3f1409
  - [V2,net-next,5/7] net: fec: add MAC internal delayed clock feature support
    https://git.kernel.org/netdev/net-next/c/fc539459e900
  - [V2,net-next,6/7] arm64: dts: imx8m: add "fsl,imx8mq-fec" compatible string for FEC
    https://git.kernel.org/netdev/net-next/c/a758dee8ac50
  - [V2,net-next,7/7] arm64: dts: imx8qxp: add "fsl,imx8qm-fec" compatible string for FEC
    https://git.kernel.org/netdev/net-next/c/987e1b96d056

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


