Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7594B52D3
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354940AbiBNOK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:10:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354937AbiBNOKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B611B25F4;
        Mon, 14 Feb 2022 06:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6916BB80F9C;
        Mon, 14 Feb 2022 14:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E168C340EE;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644847810;
        bh=uu0WSRjS4fc8anLglBnwsgBr/4Wgd43TgRH+TDgQgT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cl0ME6U6Bl4B8An92YkRX29VAZ2J/J9KpE8PASe+9qdgoepeRROkXXf7gJOlC7VeR
         92L+6q2og7kbVlQiwm1+hcBoHxPaRpajn4npxbzxa6MHlaCplGT/8Hbx3rxQvNLjx0
         h/XnRGiDc2TTkMpp7LtpM4ZajwGvc5y7zQuR6NNg7Sg3wrGfNozeIrX8GOpp5b1aS4
         k1nO5UFr4h0UTB/Y6L0Pj410Nme1m2bSFRVkLHo8rbenrLHjSQKXGV56Uq0XzF0guG
         TR92aZc8/tuOnLG9v5eW+Kr65N0UM+W2dIL9PAQ3u/n53g8IhfyUrGLmhNGFXGWqnu
         3MxzfxyTY98gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18DEEE6D447;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix documentation for kernel_getsockname
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484781009.8191.15215417018022977748.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:10:10 +0000
References: <20220212102927.25436-1-alexander.maydanik@gmail.com>
In-Reply-To: <20220212102927.25436-1-alexander.maydanik@gmail.com>
To:     Alex Maydanik <alexander.maydanik@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 12 Feb 2022 12:29:27 +0200 you wrote:
> Fixes return value documentation of kernel_getsockname()
> and kernel_getpeername() functions.
> 
> The previous documentation wrongly specified that the return
> value is 0 in case of success, however sock->ops->getname returns
> the length of the address in bytes in case of success.
> 
> [...]

Here is the summary with links:
  - net: fix documentation for kernel_getsockname
    https://git.kernel.org/netdev/net/c/0fc95dec096c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


