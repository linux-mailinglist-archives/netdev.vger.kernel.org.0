Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E740694182
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBMJlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjBMJlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:41:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FE4BB92;
        Mon, 13 Feb 2023 01:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A9EB80EF2;
        Mon, 13 Feb 2023 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55F69C433AA;
        Mon, 13 Feb 2023 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281218;
        bh=ZWgZRDbNxYjJMZxTsE4Qyi5TDQsuhsCCICH2lW4eLoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOseT4ctswdvi/kLnSIkqAhf+MBikDM2naK4shlmNlJM2OkWEudBWmzSBSYW7Skrp
         vXVGIdL3yvuwwi4nhB2sRi7SR1v3V/pkGLQ1yMJaAe0tiJRlZBzvBhC9qweGNh3MmK
         oZYeeUksuGn1Eq/jhMZGCzNtAs1tScLSgUuAtS37vaLUsdooXzhBmKa7c43JvR7D/l
         RI2H0DbH1+6Pr0XI18YpWQNeVjB0lAcIi7Lptp6N/TMv4l6A1TmKCkWca8B/zGu5Ts
         nwIe5/4yg/IAeRQCncw1BJPCIEDU/QcKOy0GIf0gZbXn+cQxBrixnv1UfxCdMqU10Q
         uJlGkVXSoTy2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39414E68D30;
        Mon, 13 Feb 2023 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rds: rds_rm_zerocopy_callback() correct order for
 list_add_tail()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628121823.7814.4417159911347667893.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:40:18 +0000
References: <20230209-rds-list-add-tail-v1-1-5f928eb81713@diag.uniroma1.it>
In-Reply-To: <20230209-rds-list-add-tail-v1-1-5f928eb81713@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        willemb@google.com, sowmini.varadhan@oracle.com, c.giuffrida@vu.nl,
        h.j.bos@vu.nl, jkl820.git@gmail.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 09 Feb 2023 12:26:23 +0000 you wrote:
> rds_rm_zerocopy_callback() uses list_add_tail() with swapped
> arguments. This links the list head with the new entry, losing
> the references to the remaining part of the list.
> 
> Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> 
> [...]

Here is the summary with links:
  - [net-next] rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
    https://git.kernel.org/netdev/net-next/c/68762148d1b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


