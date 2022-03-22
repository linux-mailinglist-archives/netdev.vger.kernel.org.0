Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3ECB4E3E5C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiCVMVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 08:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiCVMVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3D6C957
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B12856148C
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19225C340F6;
        Tue, 22 Mar 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647951610;
        bh=MIADDDn7JQ6nO3Qn5t0JGh+fopvSQCUUqIa7IwoWu9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K1aZ7+Ycr96UDF9iysy5cjYCvoU/kIh64qc5ovbvROSm3c8cEMjd+CwBTnEvWrEd+
         htFgaL6FUiw38Uq8JOciQWNJejH/x0xD+mWnsBuRU3/doLfTqcPYpou6CTXvluotQj
         eP9ue8MvKuhY0ARygk8gs8wHYE0HgeaPtOFld5b6UZvBU2ClnkoCEiLkeFmeOoXmZ9
         +Rt0tzVRAUeYQNJuA5JpaUqkUIKqc9xYSSStZA/euTH+Qfr3daQ6F/tOrRQATIqmMJ
         uMzHhEltA2bdHbMHktw9J7xIJi6PuNylKqoNxGVlbTjUnuHI+tJFXiZkiTL62rmA81
         t9h9IWNA0uwIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3B23EAC09C;
        Tue, 22 Mar 2022 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevice: add missing dm_private kdoc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164795160999.10929.2993680167888468537.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 12:20:09 +0000
References: <20220322051053.1883186-1-kuba@kernel.org>
In-Reply-To: <20220322051053.1883186-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 21 Mar 2022 22:10:53 -0700 you wrote:
> Building htmldocs complains:
>   include/linux/netdevice.h:2295: warning: Function parameter or member 'dm_private' not described in 'net_device'
> 
> Fixes: b26ef81c46ed ("drop_monitor: remove quadratic behavior")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/netdevice.h | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] netdevice: add missing dm_private kdoc
    https://git.kernel.org/netdev/net-next/c/4a0cb83ba6e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


