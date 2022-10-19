Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE260388F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJSDUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 23:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJSDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 23:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE963AB38;
        Tue, 18 Oct 2022 20:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE2061769;
        Wed, 19 Oct 2022 03:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB57CC433B5;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666149623;
        bh=9u7rEZt/xjd0rgaxCm7SoCQ0VkF5XvCkAb8VyutZSa0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VjTCCpJYAFbgdmtiFIHd8BI7V769KUYxhPEHzuIc8XPhQEIAPRnLu1Qq2FEgQOD0K
         In5LMMThMEmbkFyGB02HxRNsEd+Oga5h/6N3MJehv6epPykNusG8+G58WJSqRWSZS7
         bhvI2hARfQTcF69tzwOtmrc2rmTlhbxukam6yn2LPqCjtPhRa0rAO/17JzPFwA55CH
         TLF4Ne3BLmLSk0PGoD2SqgO34JIlN/Uq0WyYgTQkOkwnbBSf/tf4XMPu0+cpWwucrw
         bncYlal1LgX2uy9tfpRNUx1HXWpU7iBVxlFolNptOmkpJ71rb1rGSITe0on1gs9vaW
         RGEzpvfv3tUDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9264E52513;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: remove smc911x driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614962282.9993.3785570586231787923.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 03:20:22 +0000
References: <20221017121900.3520108-1-arnd@kernel.org>
In-Reply-To: <20221017121900.3520108-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steve.glendinning@shawell.net, arnd@arndb.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 17 Oct 2022 14:18:26 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver was used on Arm and SH machines until 2009, when the
> last platforms moved to the smsc911x driver for the same hardware.
> 
> Time to retire this version.
> 
> [...]

Here is the summary with links:
  - net: remove smc911x driver
    https://git.kernel.org/netdev/net-next/c/a2fd08448f2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


