Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D35385C6
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242532AbiE3QCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241720AbiE3QCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2D211
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 274E861159
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89246C36AE3;
        Mon, 30 May 2022 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653926414;
        bh=hppJ2Dem/MyqwqFM5yPWeYXn9iCRsn3RHRiRqEBQl+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SHc0ZDyEiIhVcGPNIuFPjwLKskIJpH4IEqhsyAVcgCWPqq+p1XWuAAUNVrfTQtsCS
         9Y4Rg9jrVuWkvr5keKJCTdzz2yW67Xy0LIqQ7OxeWx53hkOB0BtC+9aWX5SLdIg2At
         +NSBDys3m1qpax0leB+n0U8KUxS5fyzhp0gR95fv9t7GB0YFXgcRxqP/eUgF5OqUzp
         s1uGXo+pptYqeuaPpHC+fCPLjKYcnqgJFfs++m/kJcr9l0jN9kDBb9TL/BGniYs3fu
         DyGyVZO2t1R3IXadnZtaHq/ZD4F+wcpeFRv+Nrv6u9+bI9UWUTw78uz06Mf4F2oJMJ
         Oto/Hdl3XfUyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EF5BF0394E;
        Mon, 30 May 2022 16:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] iplink: report tso_max_size and tso_max_segs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165392641445.20842.9830714397606189881.git-patchwork-notify@kernel.org>
Date:   Mon, 30 May 2022 16:00:14 +0000
References: <20220525153624.1943884-1-eric.dumazet@gmail.com>
In-Reply-To: <20220525153624.1943884-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, edumazet@google.com
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 25 May 2022 08:36:24 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> New netlink attributes IFLA_TSO_MAX_SIZE and IFLA_TSO_MAX_SEGS
> are used to report device TSO limits to user-space.
> 
> ip -d link sh dev eth0
> ...
>    tso_max_size 65536 tso_max_segs 65535
> 
> [...]

Here is the summary with links:
  - [iproute2] iplink: report tso_max_size and tso_max_segs
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2a0541810c85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


