Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE85241DD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349803AbiELBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349802AbiELBKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD6F53E00;
        Wed, 11 May 2022 18:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 851B5B826B8;
        Thu, 12 May 2022 01:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D511C34113;
        Thu, 12 May 2022 01:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652317813;
        bh=CpuSyDWiKb9QlaiTEFhJWMz+dVsdATkpdFWbrChwLWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JVcpRmGPO5j/qr8hCzbxEIYvnRV0kilKiA/JCLcJsL0hMSRh8J4Bgqy+N2ylR7RYJ
         atx79NCP7bEtmASMheniOlAh53M/tB+9tQ+5xIswhL6qJ45GIiwYr1HY95RsowEP+X
         ucgk4XZ1g7Q/DosJZpSl981PAil+loMZS18H6IBghZQmLXYlPYTygVH8Fm5cza5bgF
         TBtIJ5Nup2y6zeLbtTeqvPUCjH7RdF2aVoKaeshMBbbjBwKCknfpCrAzAtaKiXN42O
         jZ1GfcNA4qvBvutpuTLLJYDUffS7NtUUWZWAL2YY0QFDdPLGuDGm4RPYv/o4hjv+xq
         ppveYTcR6vi8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F09B4E8DBDA;
        Thu, 12 May 2022 01:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-05-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165231781297.19416.10203908620528305173.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 01:10:12 +0000
References: <20220511154535.A1A12C340EE@smtp.kernel.org>
In-Reply-To: <20220511154535.A1A12C340EE@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 15:45:35 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-05-11
    https://git.kernel.org/netdev/net/c/8bf6008c8bbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


