Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160685F5FD6
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJFEAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFEAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4E858B4B;
        Wed,  5 Oct 2022 21:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB817617FB;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AA68C43142;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028817;
        bh=T+SwlxiKuBO+CE8538i8k26fdUZf0S8mRyqXrJDoUro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iZvGOLeh3kaDRTmeMOy3jtVnEBjYK5oy9GUan3K1Cbd7ErfDzmJq1pfpD+FDfIvKP
         5C9Ne1KiWlrC4GTgr/IHSHzdvFbgs6uz7H3ffD1bmnQseCVfMageFsPvtLvyB1wNwS
         qp3MvQAh2KC2+sGunfW28Dxnk4HIA2rJrd5TeGs4It6pBuaWgP4KlJRPhZoOFs6l3r
         /6EvyOJPwqeIeTcfbtxy54f+fwtsXvQ2hR6JEK0XW1bF3vEbkJFvf9JCvMrBIrGF7G
         g6Hzn90/MtfmlH2vmVwuwsD+Y1d9Zf1fPpS0TeqjRu2ag+zlYHW3J3E/0bSxMYF9E/
         adHZ+UwCLJJDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07F07E4D011;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2022-10-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166502881701.31263.13846825290117849335.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 04:00:17 +0000
References: <20221005144508.787376-1-stefan@datenfreihafen.org>
In-Reply-To: <20221005144508.787376-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Oct 2022 16:45:08 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree:
> 
> Only two patches this time around. A revert from Alexander Aring to a patch
> that hit net and the updated patch to fix the problem from Tetsuo Handa.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2022-10-05
    https://git.kernel.org/netdev/net/c/1d22f78d0573

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


