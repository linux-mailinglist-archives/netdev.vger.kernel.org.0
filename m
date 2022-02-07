Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C754AC919
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbiBGTDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbiBGTAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:00:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C37EC0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 11:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15629B81157
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5560C340F3;
        Mon,  7 Feb 2022 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644260408;
        bh=MBsgJxOGBcrhCmIQ2CCXXof4fekU2wlNmk4izGb5lOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nhtlz+qQ1/a3UU0+C0exSn179jgqL4DK5rQvBJTz6RC9+uDGlAX103BFyu01Ygm/p
         DcibnFKceWWP5Tat8u/AkKGoEZqd0WThoOc23gjScuVQrSlaaiYfeHZtUwEmeCOlSg
         oQRvtccEE61AhEXcbfyolJa02uEcdK9/zDYUYIWNp2H3Z3Ve0y0zf5H9fSynU4eKz6
         NilOVRfw0lSXkpNfBPybNkYoJ404+PowvZP6DP+76hp6IBW0VLLwvqD0+wFw1N8EAO
         5kjacgopGBQWarrY3Arm+TuRj3PggG7oHNqJJuV+WTM42r8NISUTqTQ/n9UhqwN7BO
         brOpE43zeyGQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF8A6E6BBD2;
        Mon,  7 Feb 2022 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] iplink: add ip-link documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164426040878.15558.10801253267942393474.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 19:00:08 +0000
References: <20220202182411.1839660-1-eric.dumazet@gmail.com>
In-Reply-To: <20220202182411.1839660-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, edumazet@google.com, lixiaoyan@google.com
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  2 Feb 2022 10:24:11 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Add documentation for gro_max_size.
> 
> Also make clear gso_max_size/gso_max_segs can be set after device creation.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Coco Li <lixiaoyan@google.com>
> 
> [...]

Here is the summary with links:
  - [iproute2] iplink: add ip-link documentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e4ba36f75201

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


