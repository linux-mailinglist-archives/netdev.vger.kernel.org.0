Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B616D0746
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjC3NuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjC3NuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7F5597;
        Thu, 30 Mar 2023 06:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E266B828F0;
        Thu, 30 Mar 2023 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD5A9C4339C;
        Thu, 30 Mar 2023 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680184217;
        bh=nCIxYfeOpNNYAdQJkG3B1YlgdvS8aT3sViVNWAQZLwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RzU9+D40oss0bDCVl4JKyGqFN4Ay8AtGAFtuDOuNtAFRQ83P3OFSAP9yAuERvCxK+
         Lb7bHSs3foWMf+8ZckXx9yRqHJ/mGGpsCdUVvDvisqtiTiULxgd8bSO5y3F4rGbg1Y
         JQysUuQgHtChR+EFiMwGNin2g1dIjbVsX2Br5o0lNXHM81QPNwM7EpNEKffQ6flO50
         hHNDNa3+uf5EsGI29LeQVTbSYElfh0FJ0DUo5arJZ5Yx9AMBLzT9sPevlf1e0AFjzv
         0W/xJ5jBnJDMt44ndG9cQSTp1KACJGz0BvvR2ytTqAJldakrh9k/8RjtdnhTZL+Rag
         g2H9lz8o1m04w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B025FE2A037;
        Thu, 30 Mar 2023 13:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] xen/netback: use same error messages for same errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168018421771.9777.1140138877861718257.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 13:50:17 +0000
References: <20230329080259.14823-1-jgross@suse.com>
In-Reply-To: <20230329080259.14823-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, jbeulich@suse.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Mar 2023 10:02:59 +0200 you wrote:
> Issue the same error message in case an illegal page boundary crossing
> has been detected in both cases where this is tested.
> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - new patch
> V3:
> - modify message text (Jan Beulich)
> 
> [...]

Here is the summary with links:
  - [v3] xen/netback: use same error messages for same errors
    https://git.kernel.org/netdev/net/c/2eca98e5b24d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


