Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED674D800C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiCNKlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiCNKlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD34348F
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D6E60FD8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EA18C340F4;
        Mon, 14 Mar 2022 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647254410;
        bh=GFElFhywXB9U9GDpHNdC3NyEGOO99BSS2uV4IGsgQ0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HEG8PKdqg+LrLW7lafgqxsXllfrDf03Ai0Cu2SDvJdxdZs6/vOTVia57uZohmmS+j
         Gs5smHXGVwStisdQC5csxVeldmUGdRhQQMY6U6LWGdUw0HF/+HSgcQm/tgaI+IOknj
         a4cG0q4IJ2It3MGLPUfdS2As0A2j+vIuNf7P4ZqaGsyq8utwrR9SPpKkffnpAfA0pj
         JBW0ycuGsYgzAIGDnhreJUSYPs3kbg2TKujxeoKWrcqeJldnH94/Jn6CIDitGXui7B
         GmvcK+oWXveFyV3UXkLZCPWvTJnROnQqgsBDosIPs9vpE6i1NLx8Y6EJy5ldIo+vfl
         e0JShgEOyTJ1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B3B2E6D44B;
        Mon, 14 Mar 2022 10:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next] selftests: tc-testing: Increase timeout in
 tdc config file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725441030.29367.8291070167893280873.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 10:40:10 +0000
References: <20220311152942.2935-1-victor@mojatatu.com>
In-Reply-To: <20220311152942.2935-1-victor@mojatatu.com>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        dcaratti@redhat.com, vladbu@nvidia.com, marcelo.leitner@gmail.com,
        kernel@mojatatu.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 12:29:42 -0300 you wrote:
> Some tests, such as Test d052: Add 1M filters with the same action, may
> not work with a small timeout value.
> 
> Increase timeout to 24 seconds.
> 
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Acked-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] selftests: tc-testing: Increase timeout in tdc config file
    https://git.kernel.org/netdev/net-next/c/102e4a8e12fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


