Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A6C5F2FC5
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiJCLkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJCLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624AA1A805;
        Mon,  3 Oct 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EE32B8107E;
        Mon,  3 Oct 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0D0DC433C1;
        Mon,  3 Oct 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664797214;
        bh=bFoPM+VdvAXnSmDi7qTpDpT02RkKRdyFW8pWKcVeUyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G7F61gthixv+xq1Z3VD7uZTYb8V6AAVzJs2UXUR4mACftu/T0i62r5uVequH7UUkB
         fmCAqx2LLrjUjzhb4DeoIkrFrrK/3dT/+iCYNQeodW/XpJCAKGiHusaQ/GhXcSt91M
         n5A2vfokjkzFzOEfJAwVTm1YBDtQwg1b0waEA0o3ejXDUgQ25/HW/PK/dXGLL939vO
         h4PTCzntfCutp7gyMswYGlUwj8U8h9hiAFViQAuk88hE7kiTlgDpI+cEKLt44MoCLB
         HlpwMdDM5zRbAUOJycUQB9bdgJ76zNkfT/2oz+h0MrcfSC/ijrBpXEbzHHFsh+/+8H
         vd+NvE6mAjD4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BDDFE4D013;
        Mon,  3 Oct 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479721450.20474.10937271845553963937.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 11:40:14 +0000
References: <20220930044843.32647-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220930044843.32647-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     vmytnyk@marvell.com, davem@davemloft.net, tchornyi@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 12:48:43 +0800 you wrote:
> As the kemdup could return NULL, it should be better to check the return
> value and return error if fails.
> Moreover, the return value of prestera_acl_ruleset_keymask_set() should
> be checked by cascade.
> 
> Fixes: 604ba230902d ("net: prestera: flower template support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net: prestera: acl: Add check for kmemdup
    https://git.kernel.org/netdev/net/c/9e6fd874c7bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


