Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED65A0743
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiHYCaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbiHYCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610B37FB4;
        Wed, 24 Aug 2022 19:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45C561291;
        Thu, 25 Aug 2022 02:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05D75C433D6;
        Thu, 25 Aug 2022 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661394615;
        bh=zARuAjQaB6fNrTTQ51hm9fDWpTcFilOUCIo3fUAlHXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIPYMT8cWnQnWzRFBnhWgEkRxq4JSElmfjg7xdL6p9+cOeVLTe2JQJMoY7e8Uq76p
         ZaVxF2uvs7PDcUE3oHvZMUDL0atEFYElwv1P3ithgeTxnZtxOuggj5gp+hiTwx+CCA
         KOTNFP+a9J/ptkk+7JOlhXnegSWE6U6sCxwaupZasOT/P8T7/eQiHHqe5okUU8S8MG
         yMeuyo4faTFukFmbfqwauStOe3haACjqgPoKeq9xbrp3BjnzBnrUkJ0ZzmMQjmaTWB
         pxywUTlWrSKN+nONGGlePB56CReY9AwfWanIQ0ShYA7H2XdSpCDh1YLydq0oV9PO5H
         IL5gv5Y5obMNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8E6DE2A03D;
        Thu, 25 Aug 2022 02:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: fix some kernel-doc comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139461488.28757.10831519801603630363.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 02:30:14 +0000
References: <20220824013621.365103-1-shaozhengchao@huawei.com>
In-Reply-To: <20220824013621.365103-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 09:36:21 +0800 you wrote:
> Modify the comment of input parameter of nlmsg_ and nla_ function.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/netlink.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] netlink: fix some kernel-doc comments
    https://git.kernel.org/netdev/net-next/c/0bf73255d3a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


