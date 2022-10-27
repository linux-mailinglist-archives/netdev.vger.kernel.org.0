Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE360ED5E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiJ0BU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiJ0BUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B8E4D175;
        Wed, 26 Oct 2022 18:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBAFFB8240E;
        Thu, 27 Oct 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F13DC433D7;
        Thu, 27 Oct 2022 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666833616;
        bh=TxUsiMY8hkjWsnKLTDKBl8qQCk8kzMRR0hOy2vEE8X8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jpdzFH0a8D8XNAjhUxvY0wQrADXNHw2KPFLt7kK3Z4zMdwqTgDIiyRP8DzHiS2AFH
         /3EUM3BX9FSvBXUymdbkFCYrsgTbkvzo6rb1nINUVe+wJZVBix3acYdTc8Vrr4Em00
         Nlg3kTnPsWywsu741+cNVBsh/afcAvcfLaHyDC5fMVXi+iR07nfGY+f/uhASLa59w2
         nD+w9XlxiTP3/YhxrAQUOq/Xy6kpnuBWDl2FH7TcVzgoaWaF4KvSeai+r5PtcWnkgD
         JwURzYhOatHByTQ1XoRPyinJkDX5JZDab4Cv39+C4EZzOmDCouQv8T7MTuSu2TT8aM
         tXjyCAwK0wyew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 411ABE270DC;
        Thu, 27 Oct 2022 01:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request v2: ieee802154-next 2022-10-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166683361626.2540.3289069991817706765.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 01:20:16 +0000
References: <20221026075638.578840-1-stefan@datenfreihafen.org>
In-Reply-To: <20221026075638.578840-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Oct 2022 09:56:38 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> One of the biggest cycles for ieee802154 in a long time. We are landing the
> first pieces of a big enhancements in managing PAN's. We might have another pull
> request ready for this cycle later on, but I want to get this one out first.
> 
> [...]

Here is the summary with links:
  - pull-request v2: ieee802154-next 2022-10-26
    https://git.kernel.org/netdev/net-next/c/c206394b78c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


