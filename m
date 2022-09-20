Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C881F5BD962
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiITBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiITBaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694834056F;
        Mon, 19 Sep 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24DBBB82353;
        Tue, 20 Sep 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCABAC433B5;
        Tue, 20 Sep 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663637414;
        bh=M/Vfuj+1x2pkv02mvuyhLTvrL63Q1EoU5SyK2zCuqvQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AUPmiwUBZAGt8SrBrq9CdgFQuNL7D3FrDRWP0CEo41ucEEsnW4rQvXY8qd8poaA+/
         ox7aoY0TIvW4QoFx0cVQwzKp/i7Rosch76dmN9Q7paUdb6XQFM3grgL0jvFYV2tgTK
         Dw0qAJ5A4X1ZP/W8u9G7QCZo+PmwVJg+exozDmSz5fgxQOq6QBKJTvaQ+jMUEuhYAS
         xfMo8wvetgB7JsCC0+EPmzWwruuHiNFbis+2kj8KyCQiNmA+bnVSvPmZjsktKSgce9
         OLfmeHshpOWEcUo3NIxQJl8NT802WTfLVCu2qkpV/Yfg096xligFohw5NzCbbeu4Ax
         DmcNCQ+ngp07g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 924C9C43141;
        Tue, 20 Sep 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-09-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363741459.2241.16870588734772041578.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:30:14 +0000
References: <20220919105003.1EAE7C433B5@smtp.kernel.org>
In-Reply-To: <20220919105003.1EAE7C433B5@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

On Mon, 19 Sep 2022 10:50:02 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-09-19
    https://git.kernel.org/netdev/net/c/094cc3b649e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


