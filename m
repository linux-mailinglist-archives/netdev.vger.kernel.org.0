Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736813A4A3D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFKUmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhFKUmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 100C16128A;
        Fri, 11 Jun 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623444004;
        bh=L67LrTJqfmjDCNYMIGEo5yysMyPlUKi5n9qFLrycCqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=seYERk0iBYV4eYcu0gA4PLrpd/fBrHDpOicp4UrDgSVaTIs9NzTiwqdDtgCfLSnhY
         Lr4dPZd0mps0zjdaewtcgac2Ky3bzjkyLDs0ry1ko/DHqPHOjQt9Rc3K/bMGF95ReI
         otk7saLLUZvhqTi2Yr/yUPC0QMwBU0EKSrOvDLCOyzlDzpuQNxFELU1NU1T3ptCdPy
         qGSmpINqiDlvJurjWUn6KkHNXUA9fslVzYmsfTA3QqqiUI97/leOYUMAGRcM1myqC2
         6JpU5sQ3edFq/ewsk5xpP6Y7DdQIr3uZwxD5c9hLnduEbFtyULGPYO0USGQzQ8S/Vg
         33pOKPgcjOXZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 047A960A53;
        Fri, 11 Jun 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Add trusted VF support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344400401.21288.6507350122333489800.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:40:04 +0000
References: <20210611094205.28230-1-naveenm@marvell.com>
In-Reply-To: <20210611094205.28230-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 15:12:01 +0530 you wrote:
> This series adds support for trusted VF. The trusted VF support
> allows VFs to perform priviliged operations such as setting VF
> interface in promiscuous mode, all-multicast mode and also
> changing the VF MAC address even if it was asssigned by PF.
> 
> Patches #1 and #2 provides the necessary functionality for supporting
> promiscuous and multicast packets on both the PF and VF.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] octeontx2-af: add support for multicast/promisc packet replication feature
    https://git.kernel.org/netdev/net-next/c/967db3529eca
  - [net-next,2/4] octeontx2-nicvf: add ndo_set_rx_mode support for multicast & promisc
    https://git.kernel.org/netdev/net-next/c/cbc100aa2205
  - [net-next,3/4] octeontx2-af: add new mailbox to configure VF trust mode
    https://git.kernel.org/netdev/net-next/c/bd4302b8fd16
  - [net-next,4/4] octeontx2-pf: add support for ndo_set_vf_trust
    https://git.kernel.org/netdev/net-next/c/b1dc20407b59

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


