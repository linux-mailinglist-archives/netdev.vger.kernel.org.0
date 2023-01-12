Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE8666A9D
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbjALFA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbjALFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB20147313
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4727661F64
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F15DC433AE;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673499617;
        bh=kRewJ4z3pym+VL9t0pNErTepSaXzn3i2ZPWI3w5bKwk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vACVWtZAV94Nm32OzSlPsnI5qcqQ3g9IjuVFDiUIAa/zBICeKxEeapZaZUa0RaXE6
         Rjllp/C2zcaYgbbJU68wiW2jV5nK0ZN1yoK5VlDZRsoImjB5t1cMWDC93r6S3qdPz+
         3q8OuabhNQcb+uI5o+/vCbrWWK9IJbhX+KxQ0F7l+dwxLckBImYQTGL2HvbsXpKLe5
         isSO8O2/up46xkApym+r29lDQQOcKWrClKI3D9Vs9r/HvvwCJepPVGjeNVuSGmmQOF
         fzNrxx98Ht1PTDkh+oNkHKj5AcAs7xKIhFwuEZe3LHby8C3GybQQt4FysLdlvvFW6k
         KHhoHNND9qNEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82C50C395D4;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt: make sure we return pages to the pool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349961753.12703.13677873068030211193.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 05:00:17 +0000
References: <20230111042547.987749-1-kuba@kernel.org>
In-Reply-To: <20230111042547.987749-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, somnath.kotur@broadcom.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Jan 2023 20:25:47 -0800 you wrote:
> Before the commit under Fixes the page would have been released
> from the pool before the napi_alloc_skb() call, so normal page
> freeing was fine (released page == no longer in the pool).
> 
> After the change we just mark the page for recycling so it's still
> in the pool if the skb alloc fails, we need to recycle.
> 
> [...]

Here is the summary with links:
  - [net] bnxt: make sure we return pages to the pool
    https://git.kernel.org/netdev/net/c/97f5e03a4a27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


