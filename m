Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08F5EF93D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiI2Pk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiI2Pkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAD040BCE;
        Thu, 29 Sep 2022 08:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 295EF6194B;
        Thu, 29 Sep 2022 15:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D9DDC433D6;
        Thu, 29 Sep 2022 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664465923;
        bh=m62MJOeG0bPZl/sajcqU1aFz5U2SQ6VtUTQBzgeCeSg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DsVuxbH6tW2YBqyKlEmJ+bDvOteMGa4shrNuZdyE0NQMCmcKrr4ucLEEPnLAMkblH
         IYkkVPyGaNNMXRUrtRM83TR9bbh4ot9SpKjEGuLoIfeNCAa0LZApzmE3kQs9hD1v/S
         6c6pSBnkfFT+PslAecNuC7SGlclPOXJ/nvaT4itmSX9DWyStCVZCastbZCh8vA/Mxt
         24UyNPJCE6nr+5puFxSAsh1LEfdYJ4aZHpIKJw7beStai8NBT/N/5ehwv0DRAhfwRd
         +QOfJ4v5zrJaY0inz5WFI7QyvI93FTm07flvZXDzP/cK2IAex0N23Gs2KqCUpfT6Il
         J/X+eS9aSWLbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78780C395DA;
        Thu, 29 Sep 2022 15:38:43 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.0-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220929111605.32358-1-pabeni@redhat.com>
References: <20220929111605.32358-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220929111605.32358-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc8
X-PR-Tracked-Commit-Id: 3b04cba7add093d0d8267cf70a333ca8fe8233ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 511cce163b75bc3933fa3de769a82bb7e8663f2b
Message-Id: <166446592348.14842.13821393257354064108.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Sep 2022 15:38:43 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 29 Sep 2022 13:16:05 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/511cce163b75bc3933fa3de769a82bb7e8663f2b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
