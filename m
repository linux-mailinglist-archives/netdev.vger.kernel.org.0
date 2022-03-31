Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF94EDA91
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiCaNcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiCaNcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695CD37A24;
        Thu, 31 Mar 2022 06:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AA6DB82134;
        Thu, 31 Mar 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD26DC34110;
        Thu, 31 Mar 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648733411;
        bh=K6aSB5OGz0g8W4I1PtKtyCeGyTyE/QPLddQ6/Eu/now=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=coTDcbIDjDfw/fTN9VTGhOnTDPDG0rNYMxBU7ciHln+n+C58qUtXYT9apisIkzCbu
         7o5R7qNfbjFZf0Z37o2kw4njxaWvAxKMJIQ5QLDuhG+MSGdW03Ni7EyVMrHDIdPu+Y
         VRgj/wPh8FveRNEXXnImj+c/hcWcfEe/KJu+YDxANGnOccvx3BMZrAMTAjta80+d8e
         jCnHCqbQJioROYJVOvJOF0e0xwOgM2t/62x6aFRV4kWM+vQlDJyt9ZxSJXUkthl3wm
         T39LLOMgxfE7HPagC9N8yhs6EmLBvOvhXV4SKn8cuYhXaAuLpxvgec3orpeDYOBnGT
         spI0PSQc53Mog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B56ABEAC09B;
        Thu, 31 Mar 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: fix some null-ptr-deref bugs in server_key.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164873341173.16728.1025951051499150339.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 13:30:11 +0000
References: <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
In-Reply-To: <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, butterflyhuangxx@gmail.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 30 Mar 2022 15:22:14 +0100 you wrote:
> From: Xiaolong Huang <butterflyhuangxx@gmail.com>
> 
> Some function calls are not implemented in rxrpc_no_security, there are
> preparse_server_key, free_preparse_server_key and destroy_server_key.
> When rxrpc security type is rxrpc_no_security, user can easily trigger a
> null-ptr-deref bug via ioctl. So judgment should be added to prevent it
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: fix some null-ptr-deref bugs in server_key.c
    https://git.kernel.org/netdev/net/c/ff8376ade4f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


