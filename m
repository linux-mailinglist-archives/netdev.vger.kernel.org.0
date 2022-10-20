Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DFB60547B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJTAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJTAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5EFF8D2
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EAC6171B
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A67DC433C1;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666225817;
        bh=WMvsjRonVg1xivp1tGdi0x7tsRyuVn2TXZ3VdDEUZ3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Np5dXDLmXjxt5AM6slA+4fVfPeJGRl/QhhZlBbpVhtbuYb3V490bYlQNBO8cBndXq
         zXCi2Z4qD4Zj3lNaoIplN6dnVT0ynXDpKWHoxAkAyERjV+VMMO1Y80ZwdUN1TCXurJ
         yAqY5EttHJ/3fqMyqkK7QwCxoLEYgYCAboGCcbIIyNF9PaIlQKNkeTmDzdLjzoIDkp
         dwEFi7ZfeG0fafVeL5WqBQI8SimjaaG1V0JslpANeHH9d3hYhKvmU/y3DYVIkImgJf
         P3t1xZ5PoDe/3gAJdHMJq+GbwAAK0pqKB/3+e16gHRAcJyuGg5aQi9Td6MITvUGCVV
         VC11leyT+Uz1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10A73E270EA;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: include vport_id in filter spec hash and equal()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622581706.22962.12482233681339586359.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 00:30:17 +0000
References: <20221018092841.32206-1-pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <20221018092841.32206-1-pieter.jansen-van-vuuren@amd.com>
To:     <pieter.jansen-van-vuuren@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 10:28:41 +0100 you wrote:
> From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> 
> Filters on different vports are qualified by different implicit MACs and/or
> VLANs, so shouldn't be considered equal even if their other match fields
> are identical.
> 
> Fixes: 7c460d9be610 ("sfc: Extend and abstract efx_filter_spec to cover Huntington/EF10")
> Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: include vport_id in filter spec hash and equal()
    https://git.kernel.org/netdev/net/c/c2bf23e4a5af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


