Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D764871B1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiAGEKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:10:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45124 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiAGEKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:10:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B65F0B82515
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84A34C36AF2;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641528612;
        bh=K+ejuYykrOpWkwtFUrVzqg336fdeUZrRzGkQS6cvZv8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MqlG1YUVxVfmSmcRT2ScpHYLOMwAjuF6uRtfRXPyEsW7ElVA356q/Ttu198GKRAJb
         0TptWBsOrw/LPVwtco5TQ69Vd7Sz1bkfCqnxhnIKCVWyGg7hI0ex9qU+uomcSdhqYQ
         QY+PdvZbEX/oe3jTfcuTU+nSyc/1zbTfgF+R6+jgevnhPFE00WZmCoC8jWdrtyzoDP
         NP9uSOqvIqFZSDaoR4kN7EBwU8GLTNjZ21BteX/ZvsX+21DCOpMsYMiX8gZeQpQx8E
         mZGvxRgUVEWFBEzXQXR9rp64PzwiGZ0iXqpwNInDTyv71VhMh3qX4wB72Xr2JIN0KI
         VNlvh/aHM5PaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68926F79401;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: small cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164152861242.15603.17607721253813172845.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 04:10:12 +0000
References: <20220106135905.81923-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220106135905.81923-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        robert-ionut.alexa@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Jan 2022 15:59:02 +0200 you wrote:
> These 3 patches are just part of a small cleanup on the dpaa2-eth and
> the dpaa2-switch drivers.
> 
> In case we are hitting a case in which the fwnode of the root dprc
> device we initiate a deferred probe. On the dpaa2-switch side, if we are
> on the remove path, make sure that we check for a non-NULL pointer
> before accessing the port private structure.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] dpaa2-mac: bail if the dpmacs fwnode is not found
    https://git.kernel.org/netdev/net-next/c/5b1e38c0792c
  - [net-next,2/3] dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode is not set
    https://git.kernel.org/netdev/net-next/c/4e30e98c4b4c
  - [net-next,3/3] dpaa2-switch: check if the port priv is valid
    https://git.kernel.org/netdev/net-next/c/d1a9b84183e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


