Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227F46A9108
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 07:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjCCGaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 01:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCCGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 01:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19B215568;
        Thu,  2 Mar 2023 22:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80854B816A0;
        Fri,  3 Mar 2023 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CE27C433A0;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677825018;
        bh=zky7Bb/ZzQ7cdXxmSjVjtxqBYRhobFsu//CSVeKzQYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sl1U+pI/udvxnfZyCC+zJb0i0bssqPzPiHsuo5grcOzPssUOhgIDXDPFqaulokpXw
         Ua6H+6qmZ7fkrDLNx5Npp7tfxbttXujENFlpOKSU8Mp2AO1RncA281Cu62M3pew48s
         u8z3SIkHPp6oF4X6XCoDP/RgUPVECK8tcb7qJFlBnmrQdl5j8nFxBFK0h3jLkND25Y
         Zn5e4vHxRiyOqWNB1N3RDOad9dS9oupXPbRhzbGap7n8CAftbLj3n27LN66S2RGHUe
         UPK37DCetN4nOg5IEefOJvLBuEo0QFfqOJW1UNc7eefJo6GSsSk9OFhjt8Hsk9fIu6
         shQEwt8ERPUFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19FFCC00445;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2023-03-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167782501810.9922.9492641520311810184.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Mar 2023 06:30:18 +0000
References: <20230302153032.1312755-1-stefan@datenfreihafen.org>
In-Reply-To: <20230302153032.1312755-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Mar 2023 16:30:32 +0100 you wrote:
> Hello Dave, Jakub, Paolo.
> 
> An update from ieee802154 for your *net* tree:
> 
> Two small fixes this time.
> 
> Alexander Aring fixed a potential negative array access in the ca8210 driver.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2023-03-02
    https://git.kernel.org/netdev/net/c/ad93bab6b8d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


