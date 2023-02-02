Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8084A687432
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 05:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjBBEAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 23:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjBBEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 23:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2E74A5B
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 20:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54860B82408
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 069C3C433EF;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675310418;
        bh=Ju2pM7yWnzHlbogNan6/N2/rB9OgvoQqUcgETlJRgyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dnitb5LjapPHs7sX9CoZESmeStfLdimo6oOiDbITN5RKCmojp9DhCVQgh1ZOm42bX
         +DED8NqF+tZyqe2ubeNhT84+v38kEMYn3J/vJF4bYBhxXW8zwIr52McU88t/8XFLWj
         6CFz30iT4VogOBP4VEEp/MfcrVy9x039GA0XA3okwXXVSF7+74oiKFLcw6V7OfjcQx
         ty2SBJNK0F9p0K6JaxPEmaBHuu1Nh2vlhOm/KmNUVwf3eKjuGrrZKBLeuowsNyDbFV
         H5ovIZzZvzl2mAz/LpQU5XAACVdlB5ZxsVYzLch7EACg8g6w16yl55fPDxGoTPTNYg
         f9I23lno/38kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDDB5E4D037;
        Thu,  2 Feb 2023 04:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531041790.2562.7390194829279324026.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 04:00:17 +0000
References: <20230131080313.2076060-1-simon.horman@corigine.com>
In-Reply-To: <20230131080313.2076060-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yanguo.li@corigine.com, error27@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 09:03:13 +0100 you wrote:
> From: Yanguo Li <yanguo.li@corigine.com>
> 
> A mutex may sleep, which is not permitted in atomic context.
> Avoid a case where this may arise by moving the to
> nfp_flower_lag_get_info_from_netdev() in nfp_tun_write_neigh() spinlock.
> 
> Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: avoid taking mutex in atomic context
    https://git.kernel.org/netdev/net/c/9c6b9cbafdc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


