Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DBA584B2C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiG2Faa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbiG2Fa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA9711C10;
        Thu, 28 Jul 2022 22:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6F961EA5;
        Fri, 29 Jul 2022 05:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03C90C43143;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072620;
        bh=Xcvfj3hoAs2jREw1c542RAD/KUpaKvZ72Gubv1t7zgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R/a1XdnsMMcjQQjrSCyc7T9Dl/ZHb56MRR+sWMbCWZ+0NyQQnX0weUkXK3EZIvUJ0
         izKZ6HuIJ7xye31YrZ3Pd94zQs0eJPL8CRw7+VFMD+SuXAHb4VcX8txxVpfGHwLeQE
         20BaFftB7KS8a6DhTRQ18jBosULgyVcuMyeRr8RLunk3VTEdhOOkXGMtoWudBLk2rQ
         cURtquTBJY9e5GDwi8XUmv+O8PQtmeJ8Okd1wd2GNBh1BV4nz1thbA3GArG3/TnR31
         uWrTgOHcJiP853YEG8TYZ641eBYsdFkipHxfwnHGsS/N3gMG3gOIP+3F+SeNhqnMfy
         EZjjj2Rf/Nipw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1794C43147;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] mlxsw: core_linecards: Remove duplicated include in
 core_linecard_dev.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261992.17632.5783289767562003796.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220727233801.23781-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220727233801.23781-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 07:38:01 +0800 you wrote:
> Fix following includecheck warning:
> ./drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c: linux/err.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [-next] mlxsw: core_linecards: Remove duplicated include in core_linecard_dev.c
    https://git.kernel.org/netdev/net-next/c/707e304dd2e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


