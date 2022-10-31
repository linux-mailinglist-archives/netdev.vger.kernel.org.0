Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FBB613283
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiJaJUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJaJU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A98DF26
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17F39B810AF
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A75DDC433D7;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208016;
        bh=eLnLCJKxrgBBs8Mo2gB3M9s8UHCGe9AbNMcGozzODkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jU1d8g5N/02j7i3VFEsUYJoeFHI195O+KmkyRRcOKixF6I89DcJl2SWtNJOaOc6GO
         ug+TQaztItA9cXeoo5/tR53cl+1lmNdbSW5uOsrG6BlFIbEbeT7AzDbDOptu24eECC
         fp8jKswuGjE5VhJPoJUnep0pnuYc4MJoSHhj3y0bfhgRKWuLTJOxOzDJhvEmyKvYr9
         3Ie2nlH06ebfZmSvnrWTChwDDDxAZFHesKMrl2jl7yZ93CD5/rO+FoPZfdT9acb4nT
         bbQxk5LK4HHt23j/jZ2pOqYWcAt3Bwad1qPgxmVWPx+KRR4od86JgkKx9q01gHSZPB
         HABIOOKpGIBhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B7ECE5250E;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack construction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720801656.13996.11541357947057918893.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:20:16 +0000
References: <20221027212553.2640042-1-kuba@kernel.org>
In-Reply-To: <20221027212553.2640042-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Oct 2022 14:25:53 -0700 you wrote:
> Clean up the use of unsafe_memcpy() by adding a flexible array
> at the end of netlink message header and splitting up the header
> and data copies.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] netlink: split up copies in the ack construction
    https://git.kernel.org/netdev/net-next/c/738136a0e375

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


