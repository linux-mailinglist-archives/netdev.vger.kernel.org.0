Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F65759041D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbiHKQci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238983AbiHKQbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84027BE9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E499861455
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44EC9C433B5;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234215;
        bh=ri4dLayl4Xv3oPWJOOBkBgnHvqFNCfB9WPGZgph4KWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iAs6wNTTFLt09V9/MQMUt6dlhP8/bwI3XNYXItNR/+JOJhnQMxIrxZT9Frzk4ak52
         cLJSnCCTFVChT6HTYsyEHZuThXckwMfYbRD8/pQgUfbmfNXhESmlA1m2Ory/c470+B
         +0Q932IATSUu7uhqNOHChZQimdqYH3TLg1l+XhpC83UZFVMGhwBop+641yw7+q2EM4
         EHRjSsjNWT7xcXF3OZ805HP2KVodF+M6i6/BHJLzjVouLjau8PpCKHUNMosd6fxnRm
         rpMNHgJsWgfS/pLVG+TBJgTvs51X4/LdT/ye3foCioqBRFUY59HL/elkTnvmHPD6OB
         OqjpAKgcmgqfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25390C43142;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: use my korg address for mt7601u
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023421514.9507.17285825547178663979.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 16:10:15 +0000
References: <20220809233843.408004-1-kuba@kernel.org>
In-Reply-To: <20220809233843.408004-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 16:38:43 -0700 you wrote:
> Change my address for mt7601u to the main one.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] MAINTAINERS: use my korg address for mt7601u
    https://git.kernel.org/netdev/net/c/cef8e3261b4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


