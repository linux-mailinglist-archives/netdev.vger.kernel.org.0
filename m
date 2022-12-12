Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C088C64AA4C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 23:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiLLWcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiLLWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 17:32:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3849D13F5E;
        Mon, 12 Dec 2022 14:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C81DEB80E8C;
        Mon, 12 Dec 2022 22:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FB84C433D2;
        Mon, 12 Dec 2022 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670884336;
        bh=YOaImormonIoIZyffcSD96XBtld1tUqKsVtY+seLJ3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E7YV5/zdpp92oYoOPQwxYG0URZ/bgvSCcGwxpK1LhzoU/Expk8GW/WsMOQwUVnEMd
         h/DMdLVPCEWUszgEtbEyjAUsp3VmcrQqcd4i0aVHl5J2i7/vlqoKlc4klOqWcYfm/3
         StBplBntJohjovBadWvCW9fngWSZPmrQWeLRHm/XJS6nsvceskeTncCQHuYykthaxT
         JoRHX/NMG5dhQA7fbSw4wHA9ySNVajzvbsykX2ah4Cdt6hLcDSVpQlY7IZjhSsWv+D
         DOyGtxIQ9kR4tGzV7j7yHarSVKMnI1PIog2nY/qmzuyMquoRcjfqHFe/IaJisoOtYi
         fHg81XKE2xJEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46553C00445;
        Mon, 12 Dec 2022 22:32:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-12-05
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167088433628.7987.8526740813712502909.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 22:32:16 +0000
References: <20221205131909.1871790-1-stefan@datenfreihafen.org>
In-Reply-To: <20221205131909.1871790-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Dec 2022 14:19:09 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> This is the second pull request from wpan-next this cycle. Hoping its still on
> time we have a few follow ups from the first, bigger pull request.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-12-05
    https://git.kernel.org/bluetooth/bluetooth-next/c/cfbf877a338c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


