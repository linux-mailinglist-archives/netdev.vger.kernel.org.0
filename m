Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B05E5853
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIVCAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIVCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48676B146
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7D262E2F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E33CC433C1;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663812017;
        bh=ShM8zvIC6MlK7zBPZTP7x66v++djqdr4f8+W6t6Kvxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L1miVFNsYGy5rZp9vOqtKXyZaztCBhytpoJXXZRq4CR3lYPPqn+mUZOfGH+7xCPDf
         sgZnJpuxQSdMgxvtLguk0UhkQIi9COcUryN2Dzj/1vfIYw+UGMvMSuYldtM83Y8QLE
         nZP/gko1vE8JWzfQrskk77ayhDeCREK/0wBt7VMhot4Kn7uPBIHSJcMuXzrgrUtWfW
         44tbWiwLOui5jCzygqww/Rac1OXooTsz1TTNDjfAVEBa3QbVGp67VwI2DK2lY0879p
         QHTj+GFCntX/mX+h1U8thwPQ1Oy70r3u+S8cBWT/aTLdV7qzAu2dHYzYa8kwFqsvHd
         mMoLLr32C4y9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21C35E50D6B;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: sched: remove unused tcf_result extension
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381201713.16388.821610934966988729.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:00:17 +0000
References: <20220919130627.3551233-1-jhs@mojatatu.com>
In-Reply-To: <20220919130627.3551233-1-jhs@mojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, kernel@mojatatu.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Sep 2022 13:06:27 +0000 you wrote:
> Added by:
> commit e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
> but no longer useful.
> 
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/sch_generic.h | 5 -----
>  net/sched/act_mirred.c    | 3 +--
>  2 files changed, 1 insertion(+), 7 deletions(-)

Here is the summary with links:
  - [net-next,1/1] net: sched: remove unused tcf_result extension
    https://git.kernel.org/netdev/net-next/c/1d14b30b5a5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


