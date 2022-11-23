Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1262B635091
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiKWGkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiKWGkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F32ED707
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 22:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3EE661AA0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 576D2C433D7;
        Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669185615;
        bh=GaEddZkzlCZySSxCU4tQgmr3xktK/uhQ3eJbpb6Xx+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KcS0ZQqj0iahdnOJOmB8A77sNO0I6GpPJVBacCTiPjulBXwB4YUfRyjNVNvf1wbZY
         ansSRb3J2utMtJwY67t8tDXbJKFliSJRCAZwyU8hi3fHq49XHY5TLO/7HRwYkRAuP7
         HrVMnaVzT1IYC/xJhX8gcK1fN6Tmge4HtNi5qjQGYsSv1/vop83gYnfsvyqcdxzRrn
         p9m1bxcOo+4tI1JpjfEInq3zqSsYvWCtQAGimLs2/1K31dAy9sNtQdGD7IbCurnO3z
         9bDLZU5uXZVfxWWG6M24b/Vl2aUBkIZIIs0AThKKM1YQKjz1gzX08NsBJfG6s0LWWd
         YvlPmGgIEFtQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30D6AC395EE;
        Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc: add json support to size table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166918561519.32105.8295182106645086195.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 06:40:15 +0000
References: <20221123044949.4785-1-stephen@networkplumber.org>
In-Reply-To: <20221123044949.4785-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
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

On Tue, 22 Nov 2022 20:49:49 -0800 you wrote:
> Fix the JSON output if size addaption table is used.
> 
> Example:
> [ {
>         "kind": "fq_codel",
>         "handle": "1:",
>         "dev": "enp2s0",
>         "root": true,
>         "refcnt": 2,
>         "options": {
>             "limit": 10240,
>             "flows": 1024,
>             "quantum": 1514,
>             "target": 4999,
>             "interval": 99999,
>             "memory_limit": 33554432,
>             "ecn": true,
>             "drop_batch": 64
>         },
>         "stab": {
>             "overhead": 30,
>             "mpu": 68,
>             "mtu": 2047,
>             "tsize": 512
>         }
>     } ]
> 
> [...]

Here is the summary with links:
  - [iproute2] tc: add json support to size table
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6af6f02cce42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


