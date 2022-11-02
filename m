Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C7615D5F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKBIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKBIKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E7D7673
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 01:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FFA961852
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B7C2C433D7;
        Wed,  2 Nov 2022 08:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667376614;
        bh=yAELzuZGKtjyUQu7OV+8lhNOOyQe+341CRUy8KFoaeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uOqbn4CuY00XnIakIcesmwyT5SD7IT1TM0PWHN3KFzbQOwKwjxNH73F5hd1wCAnBo
         GCigCj65C++pncv8SfkfRCYy/BNNFm+UDkCAH/2WJLSMq6qLS8rA8rkBLXzraUbDpR
         eHimcc0ii2qcAEzY8dpd7TsGRsyfuOkN1i16dIF+pXOo1Qkm2uX9O6liyEfV2LTV6L
         h7W0N6h1Lra9Y0AReV1nxuut9FiWGzR15G3c2XueAFiXLCAm+GC2eULBcWPK6Xlv27
         kZMCbhmU7APqVGOsf7RyDLD9cLwICMuUDDVB2Iupx6r60rZg+y4kItBza9Pn95GoIc
         Yrw/ZPl8vPSpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E471E270D5;
        Wed,  2 Nov 2022 08:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] fix a warning when compiling for 32-bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166737661444.30705.12196973135847906213.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 08:10:14 +0000
References: <20221102054115.1849736-1-saproj@gmail.com>
In-Reply-To: <20221102054115.1849736-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        vasundhara-v.volam@broadcom.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed,  2 Nov 2022 08:41:15 +0300 you wrote:
> Since BNXT_PCIE_STATS_LEN is size_t:
> 
> ../../ethtool/bnxt.c:66:68: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘unsigned int’ [-Wformat=]
>    66 |                 fprintf(stdout, "Length is too short, expected 0x%lx\n",
>       |                                                                  ~~^
>       |                                                                    |
>       |                                                                    long unsigned int
>       |                                                                  %x
> 
> [...]

Here is the summary with links:
  - [ethtool] fix a warning when compiling for 32-bit
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=cbd784424577

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


