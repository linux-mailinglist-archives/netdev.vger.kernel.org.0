Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C156BDCF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbiGHPUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiGHPUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3151AD89
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA6C61123
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 15:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4428BC341C6;
        Fri,  8 Jul 2022 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657293614;
        bh=bM3QydwZT8OyDOPcGSr6AzVJPKZIdg2Au7oUY01JNFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZCPNPEq9ie12FgunmYr9BgSKJmIym9YUQKZUUq/57NaE1AxSwX6szZX6LW0DZRLiM
         AuhTqVB3xGvYkzYE1p+yXLkwfXV9NorjaacbsjqXLkAKDdH4lx8gEe8VjN0EC3VRXe
         d1NiqFoMkN0p75ZX/6cIBXb3XWWmKHIdLoD5W31okwVHj08aoNyTqcOnOjYU6rTTRI
         sPjneFCZw1VuKCkvN/IId5YsxYQuWE0PyfePVI+CfGsCXXSPH/N9phcY2w0hl+jYX1
         VyeyBOSsb3kwwOVl9tScKVSYx1qfT0NkfC87zi8VnkPfmXVoo7tTXCbQJGAYJ0og7j
         YMob12hAU197A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B711E45BDD;
        Fri,  8 Jul 2022 15:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] libbpf: add xdp program name support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165729361410.2009.9035901055111218694.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 15:20:14 +0000
References: <20220705042501.187198-1-liuhangbin@gmail.com>
In-Reply-To: <20220705042501.187198-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, andrii.nakryiko@gmail.com,
        dsahern@kernel.org, toke@redhat.com, stephen@networkplumber.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 12:25:01 +0800 you wrote:
> In bpf program, only the program name is unique. Before this patch, if there
> are multiple programs with the same section name, only the first program
> will be attached. With program name support, users could specify the exact
> program they want to attach.
> 
> Note this feature is only supported when iproute2 build with libbpf.
> 
> [...]

Here is the summary with links:
  - [iproute2-next] libbpf: add xdp program name support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=77b3a84e8fbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


