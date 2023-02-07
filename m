Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701E368DE35
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjBGQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjBGQuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730F239B9D
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E0D60DFC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69419C433AF;
        Tue,  7 Feb 2023 16:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675788617;
        bh=BzDIB1pN0+k5eXta7czQsjWFDwyzbOPNM1SWuOQsYgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vDSCf3Zhcoj0WU2z55umKfbAliOAgnTZ64MLxzO88CwpeoYhpgQVqNco6EF4hEvc4
         zEoqbekno/82S0pWH0aerlIrWVwUdlIjwZKhdSXwtuGgVBDtQIVMjWIHek74uvUWdn
         aJSeGgrHfKvht0Vt5gMEwfsKtDxp3mhuL1OE7boo2wbbrhBGBfWABLMrUg58n0C9dh
         3AsPc4C683qrdDx1ZMCeXFkzv8bVTNaqv/5IGQ69vpH2AyWT0jMOpRlOfnyPQ/9/SN
         E4PLm83CWKkYMI/X1DP10w2jdR5+I8xw77DmlEV31kDi0Fye1ft0xO3n0yyhB4rCpO
         nqqL5xriZeDIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BB01E55F06;
        Tue,  7 Feb 2023 16:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] bridge: mdb: Remove double space in MDB dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167578861730.16507.1557057283792369411.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 16:50:17 +0000
References: <20230206142152.4183995-1-idosch@nvidia.com>
In-Reply-To: <20230206142152.4183995-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, razor@blackwall.org, mlxsw@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon,  6 Feb 2023 16:21:52 +0200 you wrote:
> There is an extra space after the "proto" field. Remove it.
> 
> Before:
> 
>  # bridge -d mdb
>  dev br0 port swp1 grp 239.1.1.1 permanent proto static  vid 1
> 
> [...]

Here is the summary with links:
  - [iproute2-next] bridge: mdb: Remove double space in MDB dump
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=e7baae08a901

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


