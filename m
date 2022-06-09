Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BBF54553E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiFIUCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFIUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:02:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A90C1F186C;
        Thu,  9 Jun 2022 13:02:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01CACCE3103;
        Thu,  9 Jun 2022 20:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D7E4C3411E;
        Thu,  9 Jun 2022 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654804926;
        bh=1vvMZ+T2CyT41YDwGJaZIdyhRFG7lGEUm68rR+ODheI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ni7OtC/ard5lkgb0SqihS+A38TszmoRlY9IzqHlRYm6qfiieHMD0mVSvfZz8ZH/QI
         LErpuUEzXDS2IF0aiXOZ6nk4GQ0paX4VSSBB8Ga2Kem/lMleHvJ07VBOZef6wwC0iJ
         dn0LWEJmIIIazdS3LOxX1laiQ8LRkHujPVA7mrFGH7T89+LLV/JTBZVFHLFn91jejH
         YEKywQHPW1hK2LXdrO1dOHxPAuhC3iiRyvFOYNZIZmhZO6SjRAhJCcal2LaFxB9Q4J
         BNneORrV/yGadR4G+LCgWx1Pw2n0w5GUmEu0lFpl3TB+w84OX7lrCjK4zc45k49WPJ
         3WcKk43Mv84+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FE65E737F0;
        Thu,  9 Jun 2022 20:02:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.19-rc2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165480492619.19966.7730563044164134810.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 20:02:06 +0000
References: <20220609103202.21091-1-pabeni@redhat.com>
In-Reply-To: <20220609103202.21091-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu,  9 Jun 2022 12:32:02 +0200 you wrote:
> Hi Linus!
> 
> The following changes since commit 58f9d52ff689a262bec7f5713c07f5a79e115168:
> 
>   Merge tag 'net-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-02 12:50:16 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.19-rc2
    https://git.kernel.org/netdev/net/c/825464e79db4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


