Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365E22FF5E3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbhAUUbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbhAUUaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2895023A56;
        Thu, 21 Jan 2021 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611261011;
        bh=HG62kbJ/UUQBZl/MQ85MSr+TpY35yfIDBQELjZofos0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/shCvqcz49UmLfABUtzw78AT2Ight5jJLo8CrWV1rRBkPGd0kI36MV5BGLL79rNH
         hPG53a2TaBIX34csX1waequ+DzhPBJtDcWh2iOHbIoINOzejzd+7OgyeykkJqeF7x5
         3/nyxnf1MCKi6PkRjpYZbsOa1F/ezt67Kgj++O2DHHr4KzgPOIppsE9zY5aFjBsuDO
         L9OuHnVFUMnS3tO6+fn/BH/foXz1kJXRSFRgZX6RYH47tF1fXQY1SjQVpHzG5Ii4v9
         q1774HbfUmLLBfoAIYXHP2Cy+O6JVlVc6CXFXS0TdyorEV+4wlS2ci1TH3r9TFNm4D
         ED4+JOdgPTREw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1880460591;
        Thu, 21 Jan 2021 20:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/17] ucc_geth improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161126101109.19518.320974250703012868.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 20:30:11 +0000
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, leoyang.li@nxp.com, davem@davemloft.net,
        qiang.zhao@nxp.com, andrew@lunn.ch, christophe.leroy@csgroup.eu,
        kuba@kernel.org, Joakim.Tjernlund@infinera.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 16:07:45 +0100 you wrote:
> This is a resend of some improvements to the ucc_geth driver that was
> previously sent together with bug fixes, which have by now been
> applied.
> 
> Li Yang, if you don't speak up, I'm going to assume you're fine with
> 2,3,4 being taken through the net tree?
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/17] ethernet: ucc_geth: remove unused read of temoder field
    https://git.kernel.org/netdev/net-next/c/0a950ce029c8
  - [net-next,v2,02/17] soc: fsl: qe: make cpm_muram_offset take a const void* argument
    https://git.kernel.org/netdev/net-next/c/e8e507a8ac90
  - [net-next,v2,03/17] soc: fsl: qe: store muram_vbase as a void pointer instead of u8
    https://git.kernel.org/netdev/net-next/c/155ea0dc8dcb
  - [net-next,v2,04/17] soc: fsl: qe: add cpm_muram_free_addr() helper
    https://git.kernel.org/netdev/net-next/c/186b8daffb4e
  - [net-next,v2,05/17] ethernet: ucc_geth: use qe_muram_free_addr()
    https://git.kernel.org/netdev/net-next/c/03588e92c07f
  - [net-next,v2,06/17] ethernet: ucc_geth: remove unnecessary memset_io() calls
    https://git.kernel.org/netdev/net-next/c/0a71c415297f
  - [net-next,v2,07/17] ethernet: ucc_geth: replace kmalloc+memset by kzalloc
    https://git.kernel.org/netdev/net-next/c/830c8ddc66df
  - [net-next,v2,08/17] ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct ucc_geth_private
    https://git.kernel.org/netdev/net-next/c/7d9fe90036f7
  - [net-next,v2,09/17] ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name} properties
    https://git.kernel.org/netdev/net-next/c/632e3f2d9922
  - [net-next,v2,10/17] ethernet: ucc_geth: constify ugeth_primary_info
    https://git.kernel.org/netdev/net-next/c/b0292e086bee
  - [net-next,v2,11/17] ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
    https://git.kernel.org/netdev/net-next/c/baff4311c40d
  - [net-next,v2,12/17] ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT macros directly
    https://git.kernel.org/netdev/net-next/c/b29fafd3570b
  - [net-next,v2,13/17] ethernet: ucc_geth: remove bd_mem_part and all associated code
    https://git.kernel.org/netdev/net-next/c/64a99fe596f9
  - [net-next,v2,14/17] ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
    https://git.kernel.org/netdev/net-next/c/33deb13c87e5
  - [net-next,v2,15/17] ethernet: ucc_geth: add helper to replace repeated switch statements
    https://git.kernel.org/netdev/net-next/c/634b5bd73187
  - [net-next,v2,16/17] ethernet: ucc_geth: inform the compiler that numQueues is always 1
    https://git.kernel.org/netdev/net-next/c/53f49d86ea21
  - [net-next,v2,17/17] ethernet: ucc_geth: simplify rx/tx allocations
    https://git.kernel.org/netdev/net-next/c/9b0dfef47553

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


