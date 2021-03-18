Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7F34092E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhCRPuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhCRPuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 11:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E65264EF2;
        Thu, 18 Mar 2021 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616082608;
        bh=qfX5zLiax3LIzYkYRMHRgL7ivrPxRNxoVv0+OTDd2j0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYFpPbYGPQN+p0WZO1B8G/OIhtC0Vswv8ViXi4kGFHWE3FQnkmIB6as7EE77FoU1f
         0QbZmSC0rCLV92Ki9GR3AXUgDOV5t7S+M6OjPcEpAyVjWJsY1q74ynCpMWjufk6j9v
         ZWN6oItveFGXDsITKkOeuR8VfY/xtLfTBInmB4gM5ELg+Djp+95SFqwzJsxa00Rtai
         e0bc0NarkCR6HZp6MMqXrbD51ROno1toGgXhzc12REms3X2MEK5BOSFuzOS1Ig2rRE
         zw41nP0JmB7kWEoaF8HbtRSdnpmcm6BbtEWW87cPbcEXokM8cKJ4pdELNjl+EcREcb
         0I8By03WNVV8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39099600E8;
        Thu, 18 Mar 2021 15:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap for
 XDP_REDIRECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161608260822.2327.1831559957123186442.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 15:50:08 +0000
References: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
In-Reply-To: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, toke@redhat.com, freysteinn.alfredsson@kau.se,
        lorenzo.bianconi@redhat.com, john.fastabend@gmail.com,
        jasowang@redhat.com, mst@redhat.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk,
        ilias.apalodimas@linaro.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com,
        ecree.xilinx@gmail.com, maciej.fijalkowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  8 Mar 2021 12:06:58 +0100 you wrote:
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next] bpf: devmap: move drop error path to devmap for XDP_REDIRECT
    https://git.kernel.org/bpf/bpf-next/c/fdc13979f91e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


