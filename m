Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507A54D6FF3
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 17:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiCLQLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 11:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCLQLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 11:11:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6C13B559
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81EC361046
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 16:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8363C340F4;
        Sat, 12 Mar 2022 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647101411;
        bh=fwFR2uRs/uWf8sKoxw7HoW9LMYJD3KkPBYMMPv9pYD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E41rUBu3HjFCNp7Qx+JtTtNKALng5ntFsRtsd/HOKW603x1dGJ1I+yEoImi4A8tL0
         CSQn0hxK+apbDlPsE7Sx33Ay4A6cYrA9P/iu7BG6VvYz/VM1st2UnRj5ikcGw+dCp7
         GmsOf+USBTgJOKH9VZe4T3tBMHVdCrIwirptuluszt4EmfAevSjUUjGGJMYelBxUi0
         ilFW6JeoFSdGAlt2ifXL8IjJPOel/Bqql6bh1r9sWdWZWdSsBR5Z9i5QDyH0VAUnKW
         D+zbFHWfslZjnv83DfyLcIntFeNMhLlSFuGGsLILRFt9D3kMEymjsSYJCrMugiEc7v
         zCJL0D0XG7OGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B81ABF0383F;
        Sat, 12 Mar 2022 16:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] Makefile: move HAVE_MLN check to top-level
 Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164710141175.15431.5685294809613073920.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 16:10:11 +0000
References: <814bc876484374530642f61f999a0c136a6a492c.1646845304.git.aclaudi@redhat.com>
In-Reply-To: <814bc876484374530642f61f999a0c136a6a492c.1646845304.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  9 Mar 2022 18:03:26 +0100 you wrote:
> dcb, devlink, rdma, tipc and vdpa rely on libmnl to compile, so they
> check for libmnl to be installed on their Makefiles.
> 
> This moves HAVE_MNL check from the tools to top-level Makefile, thus
> avoiding to call their Makefiles if libmnl is not present.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next] Makefile: move HAVE_MLN check to top-level Makefile
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=93fb6810e146

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


