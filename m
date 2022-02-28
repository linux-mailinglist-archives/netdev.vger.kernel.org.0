Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623974C76FE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbiB1SKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiB1SKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECEBB7179
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB9A560180
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 310BFC36AE2;
        Mon, 28 Feb 2022 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646070610;
        bh=P7SogT2LVmc6xvVjtKuSGFTNZ6FJCRPwHhO0RCgkxtk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XE8KpcdwPjLAgUYc6H95vEfhnBgAOQq4dxweITYJhzSdzUWtz2RUdTEAR2lnfgNv5
         Wzlgprc3vdSrz3QXgvgAZdFRnZI6wP7WhcmP1vPaPZpIbIhAl/slGKOI+icytyflYP
         i1fkz0JaVsCNAURDJcUumF1ad5QvH3x4tQjKuql+f2lYrx/PkK7lkngHQ2ULfXp7Bh
         huuY+XNWSSTVG3qVclQdh4I+/LeEEjA+JHu4J8go2Dmas1saDyfULuTAywufoyr+fc
         xcaxYBFZ8GmK0zJBXfRZZRe4Bv7uo+htbNqPqpnOdJJNYaw9NtQ1WgmW8eKIV1eBSW
         RrWYA5+1O72YA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1076EE6D4BB;
        Mon, 28 Feb 2022 17:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164607061006.28629.15229035404726253495.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 17:50:10 +0000
References: <20220228015435.1328-1-dsahern@kernel.org>
In-Reply-To: <20220228015435.1328-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 27 Feb 2022 18:54:35 -0700 you wrote:
> Easy way to build for both gcc and clang.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  configure | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [iproute2-next] configure: Allow command line override of toolchain
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=386ae64c8312

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


