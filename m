Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14857383A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiGMOAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiGMOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EB72CCB4;
        Wed, 13 Jul 2022 07:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F31A4B81FE8;
        Wed, 13 Jul 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A286FC341C6;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720815;
        bh=z3m7WKJkw2LX/rJrpJTb7cBVDXPsvYOEJCXBlGdMguw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V/gooNRD7NU68XPkOhWqS8WJ2VdGxh+PkAIEaCCSDwTHWmB22Xe+uqEVKW83QwII2
         eN2ZcCFCq/Yn5csOGrIfZFkyEx+asqWAxsyj3eDtHBX6AoSRVje16inIAax84zWWL8
         KpytrmG3RzT1Koqa9dN1PVThAk9qJ3lho6qTpN1JPbuHFfcU7w+Wtd96oLjajK/AAq
         wlY1LFOirHwlRTIdqlvI263+fHZ6Wd4/sMeREVmy60Kh6tci1lrYxTqTFaP7PsWQwd
         FIya3M1tNL/bnu/tCdZ66VxnGegR8UiFlP+JoT609vliTmywcDXIGkbPjBhUtjZbV5
         1ipj3XlC7fG0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 869DEE45223;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeontx2-af: returning uninitialized variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081554.13863.1993473674203093729.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:15 +0000
References: <20220713073858.42015-1-mailmesebin00@gmail.com>
In-Reply-To: <20220713073858.42015-1-mailmesebin00@gmail.com>
To:     Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 13:08:58 +0530 you wrote:
> Fix coverity error 'use of uninitialized variable'. err is uninitialized
> and is returned which can lead to unintended results. err has been replaced
> with -einval.
> Coverity issue: 1518921 (uninitialized scalar variable)
> 
> Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>
> 
> [...]

Here is the summary with links:
  - [-next] octeontx2-af: returning uninitialized variable
    https://git.kernel.org/netdev/net-next/c/6a605eb1d71e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


