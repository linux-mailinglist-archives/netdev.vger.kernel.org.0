Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D0E49E402
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241011AbiA0OA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241195AbiA0OAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD70AB8228A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADFF5C340EA;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292012;
        bh=jsXsOK8kGNhPv5KuH7QTnIu80Mda91BxP+bezgP9qsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t2zgj0J1s3veOeduhFusgftTuCRGvNiynjI14RnVP5pgo+8jZ0DQJPLrOXZVjv7W8
         C2e3jDhA76XhrGfvwiw/Xs2rsVYSna1IsRndlbjOneWmCe2FBrxdvF+xE0jSb5vBG7
         6Vq682fnOSSHSa/ws79qKXmT6GQ8MZYsWeUQfu1Z6GMLHlJl5L5re/9/Vnu1hfk9ll
         IY4glDSNaL14hq902rS5+GvFCutJ8c/alLmidvoQ2FTxZpaqGZru07kCr14H6/AGmV
         nLyCFvHaVl06zqx0s/n8bMysCIsDH7397nFNn5xtkb0YHAsbZUBaKFnBSxTLd66MXM
         8N5PswjCwWALw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DB4DE5D084;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] net/fsl: xgmac_mdio: Preamble suppression and
 custom MDC frequencies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201264.13469.13051848040756004565.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:12 +0000
References: <20220126160544.1179489-1-tobias@waldekranz.com>
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 17:05:38 +0100 you wrote:
> The first patch removes the docs for a binding that has never been
> supported by the driver as far as I can see. This is a bit of a
> mystery to me, maybe Freescale/NXP had/has support for it in an
> internal version?
> 
> We then start working on the xgmac_mdio driver, converting the driver
> to exclusively use managed resources, thereby simplifying the error
> paths. Suggested by Andrew.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] dt-bindings: net: xgmac_mdio: Remove unsupported "bus-frequency"
    https://git.kernel.org/netdev/net-next/c/15ca0518c1b3
  - [v2,net-next,2/5] net/fsl: xgmac_mdio: Use managed device resources
    https://git.kernel.org/netdev/net-next/c/1d14eb15dc2c
  - [v2,net-next,3/5] net/fsl: xgmac_mdio: Support preamble suppression
    https://git.kernel.org/netdev/net-next/c/909bea73485f
  - [v2,net-next,4/5] net/fsl: xgmac_mdio: Support setting the MDC frequency
    https://git.kernel.org/netdev/net-next/c/dd8f467eda72
  - [v2,net-next,5/5] dt-bindings: net: xgmac_mdio: Add "clock-frequency" and "suppress-preamble"
    https://git.kernel.org/netdev/net-next/c/f7af8fe85aac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


