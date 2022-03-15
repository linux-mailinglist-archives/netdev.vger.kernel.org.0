Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77F4D9E86
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349481AbiCOPVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiCOPVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943740E6D;
        Tue, 15 Mar 2022 08:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA94861225;
        Tue, 15 Mar 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16B53C340ED;
        Tue, 15 Mar 2022 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647357610;
        bh=hV7TWjA4mrhGqnN1c6IGfxD94bpnAvcHgGYjUnxAeH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nd35ZJ+blcXYJRlO1lOdb2CpUDg9rhxRQVCBQXRj7AxnQ87LwiuH6VShW9Bgv2Ezw
         FgkYUejhzr22pgBrP9JZdLjQgtPfjYF6ceIIKQXwX6IST3DcMDBFZ5I1bH00ApMGNW
         i1xIi1UssVIfneiSvysXuvZgr0tgARs2v6EnuOznEcCM7lUjEjHiGpUyBf1zILxUe/
         H+AJXmxIpx9/yXk08Nc6CDYU/5oE9myb28Ax/ysI6pa5wRiHOfS02ecGcQOm87UObR
         H333bDhDT9OmuWKKhM2hC/yVjMwSYqtBjVFp183RbHoLzlm1mDBgkGj2q+h4D2a110
         qMycI0VUCZ4UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED197E6D44B;
        Tue, 15 Mar 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: fix a couple warning messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164735760996.20923.1446111901508222494.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 15:20:09 +0000
References: <20220314140327.GB30883@kili>
In-Reply-To: <20220314140327.GB30883@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, horatiu.vultur@microchip.com, kuba@kernel.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Mar 2022 17:03:27 +0300 you wrote:
> The WARN_ON() macro takes a condition, not a warning message.
> 
> Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: sparx5: fix a couple warning messages
    https://git.kernel.org/netdev/net-next/c/c24f657791fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


