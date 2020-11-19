Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5202B9B3F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKSTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbgKSTKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:10:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605813006;
        bh=U7rRsu8LyVhEkMIEJdrI2vTihImgQ+0+xRHqz5zhER0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BdJcKXR1YoU/ivKOuNjg2ZrCRqBhUvscJ8loG29Z/U8YufLAGiFpL49UnK5WIWNP/
         1GGDA6zFi+oKDfFAOO1n7OgdryTCixm8m7F7a0RJapdhVxI0ik529UQbpC/C9PE9zt
         cnBKSKTaTx5vb9lgyI42pA/g0NAG4ufUQoPhcZCo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fixes 2020-11-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160581300591.10604.16778782932544891078.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 19:10:05 +0000
References: <20201118214038.24039-1-kgraul@linux.ibm.com>
In-Reply-To: <20201118214038.24039-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 18 Nov 2020 22:40:36 +0100 you wrote:
> Please apply the following patch series for smc to netdev's net tree.
> 
> Patch 1 fixes the matching of link groups because with SMC-Dv2 the vlanid
> should no longer be part of this matching. Patch 2 removes a sparse message.
> 
> Karsten Graul (2):
>   net/smc: fix matching of existing link groups
>   net/smc: fix direct access to ib_gid_addr->ndev in
>     smc_ib_determine_gid()
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: fix matching of existing link groups
    https://git.kernel.org/netdev/net/c/0530bd6e6a3d
  - [net,2/2] net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()
    https://git.kernel.org/netdev/net/c/41a0be3f8f6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


