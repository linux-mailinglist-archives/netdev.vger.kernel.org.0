Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C742C6D22
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbgK0WLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbgK0WKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606515006;
        bh=l+zG+7erUAlUEPqelLFKzW/b/zSNMpiF5Sfo9x3vHnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QFd537tTUEAxLHqcM4eVJFAXcAgz1nXhA5XehMSKuWUxvJ3bJIyojAeLh9qRx3Tby
         q9mU6lydPb8mJ2581XbDZfN4oaue6zamSgXq7fDMoHLZ53LoOyOqfrEkva3XXWxKOx
         uvlm/UYGlzYOL6dTiBIQHC3/tPvRDrep1dylCRuc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 1/1] xdp: remove the functions xsk_map_inc and xsk_map_put
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160651500681.26708.13432162126987776291.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Nov 2020 22:10:06 +0000
References: <1606402998-12562-1-git-send-email-yanjunz@nvidia.com>
In-Reply-To: <1606402998-12562-1-git-send-email-yanjunz@nvidia.com>
To:     Zhu Yanjun <yanjunz@nvidia.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, netdev@vger.kernel.org, zyjzyj2000@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 26 Nov 2020 23:03:18 +0800 you wrote:
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> The functions xsk_map_put and xsk_map_inc are simple wrappers.
> As such, replacing these functions with the functions bpf_map_inc
> and bpf_map_put and removing some test codes.
> 
> Fixes: d20a1676df7e ("xsk: Move xskmap.c to net/xdp/")
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v5,1/1] xdp: remove the functions xsk_map_inc and xsk_map_put
    https://git.kernel.org/bpf/bpf-next/c/bb1b25cab043

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


