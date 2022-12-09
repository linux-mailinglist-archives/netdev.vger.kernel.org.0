Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD864885D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLISUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLISUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E661211808
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA67EB828D6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 893BCC433F2;
        Fri,  9 Dec 2022 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670610017;
        bh=V1SXJwuuuB3cTB7U6C5e7WS1TfY6kTLyWrPodWzNgaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DmogPcME4eu+I+QB3gCt1tsjPlvfvQhHbcIQwlrCZwfkWjPqT8Cl+/QACrkzBLQEv
         xqr1oBtfdM54qCE4opB+PIE+CsXH+BVqH13ea0xXCOM4M4qaRg6JV0Azklr+CDEGbb
         dPnZ+1Fj9RJtbXgSiQEfVltCNzJWO2VD1KJ9IhetmNgcVUaeAg5rsFKc42GsnGuSF+
         s3J7rE+8YMLrKl/0CwrF2gtaoap4+Rjz5Di6DK7czUx1AsSwLtoNldBvThsEsv3USP
         KVdw/jbNcehvmpJUXE9By6zD1VvVYsRliyFeCCGdQQTkYxesCzD+0ugR2/uhQWZG9F
         lSZk+YRoL/Hmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CAA2E1B4D8;
        Fri,  9 Dec 2022 18:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] libnetlink: Fix memory leak in __rtnl_talk_iov()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167061001744.13827.14134499118420494295.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 18:20:17 +0000
References: <20221205084741.3426393-1-gnaaman@drivenets.com>
In-Reply-To: <20221205084741.3426393-1-gnaaman@drivenets.com>
To:     Gilad Naaman <gnaaman@drivenets.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        lschlesinger@drivenets.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon,  5 Dec 2022 10:47:41 +0200 you wrote:
> From: Lahav Schlesinger <lschlesinger@drivenets.com>
> 
> If `__rtnl_talk_iov` fails then callers are not expected to free `answer`.
> 
> Currently if `NLMSG_ERROR` was received with an error then the netlink
> buffer was stored in `answer`, while still returning an error
> 
> [...]

Here is the summary with links:
  - [iproute2] libnetlink: Fix memory leak in __rtnl_talk_iov()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=0faec4d050b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


