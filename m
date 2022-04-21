Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F9B50A031
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiDUNDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiDUNDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:03:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0453894;
        Thu, 21 Apr 2022 06:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372CEB8245E;
        Thu, 21 Apr 2022 13:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD5C6C385A8;
        Thu, 21 Apr 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650546012;
        bh=u+fTpf0LKqlrNXsOjKkONBHQScd20FGQHEw3f+GMdV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ftdA+ZufYL/pLeA6VzNkSa/bOeSxDZLwAsEVn1E5KZdOwwOCSr7sTDHhuWDEskxjT
         veUroQSH3Mi+4qPCztbgAJMt7L98nTqV9VXOhQcmHbsgDEc8ZevPPce7K+Zbos/ZE6
         +9DJSHFAmp2G1zRRt1ZxYi1Ks3KJKr8dqORPRbNRSP4OXN8rYRytwroS5GFFQcf5Tx
         hK4hmbOETARYY/O/xF7r0P+lPanIy+YbC0f6Fs6zKwpY2/rXOnwIN6oh4FBqKQU43d
         sX1KipmJhMlbXy3ZgNPFTTydoZDsaKG/qWPAwvT++12LGvveTl0QNsDt6fSL/y6+qU
         j7pswRnkUV1jQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA013EAC09C;
        Thu, 21 Apr 2022 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: eql: Use kzalloc instead of kmalloc/memset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165054601269.6081.6899957117612196905.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 13:00:12 +0000
References: <1650277333-31090-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1650277333-31090-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 18 Apr 2022 18:22:13 +0800 you wrote:
> Use kzalloc rather than duplicating its implementation, which
> makes code simple and easy to understand.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/eql.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - net: eql: Use kzalloc instead of kmalloc/memset
    https://git.kernel.org/netdev/net-next/c/9c8774e629a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


