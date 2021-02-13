Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59F31A988
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhBMBqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhBMBqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:46:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E7D8264EA6;
        Sat, 13 Feb 2021 01:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613180753;
        bh=oecdGOLPRrsX8igQNwWvTsveOUTJxIoetxhi9npHSzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auwaITTXuhsh5gKEtnA8f9O9+quDOsGRxc40QICTQWE1Ekm4Q7zx73AF4wzSLPxYx
         y6psMhYrKept5Lh1Sf6EOeeNCw/xizOfxDrYLM+I1mB3yWc7cYPCJPozKRca10fwRt
         xXsP46rjB8torhXRgErnV05Pv/3uMNnmBIJre3OslIn6qj6NcnCca3b7mg9N6wb/XQ
         ph13DaWSwikR8mfPQnuPN01AVZMItWu1W/w8r9W1N643BdohxE94t68CyLfjaMN4Bv
         ExSw0Ey+NQtF1E5Jg6lK6GhXiTNhVwWrlyErgwI20KnGr7xPTJqlunniPkAjpcMjgF
         ODEh2WhZZ0uFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D816D60A2A;
        Sat, 13 Feb 2021 01:45:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Xilinx axienet updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161318075288.24767.11331993680228001755.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:45:52 +0000
References: <20210213002356.2557207-1-robert.hancock@calian.com>
In-Reply-To: <20210213002356.2557207-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 18:23:53 -0600 you wrote:
> Updates to the Xilinx AXI Ethernet driver to add support for an additional
> ethtool operation, and to support dynamic switching between 1000BaseX and
> SGMII interface modes.
> 
> Robert Hancock (3):
>   net: axienet: hook up nway_reset ethtool operation
>   dt-bindings: net: xilinx_axienet: add xlnx,switch-x-sgmii attribute
>   net: axienet: Support dynamic switching between 1000BaseX and SGMII
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: axienet: hook up nway_reset ethtool operation
    https://git.kernel.org/netdev/net-next/c/66b51663cdd0
  - [net-next,2/3] dt-bindings: net: xilinx_axienet: add xlnx,switch-x-sgmii attribute
    https://git.kernel.org/netdev/net-next/c/eceac9d2590b
  - [net-next,3/3] net: axienet: Support dynamic switching between 1000BaseX and SGMII
    https://git.kernel.org/netdev/net-next/c/6c8f06bb2e51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


