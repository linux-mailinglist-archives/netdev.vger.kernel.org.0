Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DF66E9CB3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjDTTxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjDTTxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A642E559E;
        Thu, 20 Apr 2023 12:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D4863C31;
        Thu, 20 Apr 2023 19:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A365BC433D2;
        Thu, 20 Apr 2023 19:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682020382;
        bh=Kv1yHjUjjchUslLkgCho9qj92VEPsWHhJswoA372L7g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=GGaUfLWSst8U9J+rKaJd7Vdk5oLUjUcpbmLpmvN8ZTXye+85EL0DZUKrPhydGPrE4
         emj2vdLOAYj7+Di+u0JVzbhm0Cdd4iUhK9J6yvl5W0Q5pWBthtgDYMd5O7Atvu979H
         w6lC2qzsjpcXkHM6oRAeyMz+Hdzx7BDLdTYGQRPgn7i0V7VZgjGKqY1aYDtPEBtZRq
         EoHEi5S73D7LPsqtvSbyiRCU0mXlg+ufksCbmUTcVKpXMQFWflyIjVL72t4AHtp58J
         WSdGF2FI/QRL/dJ+xfsc0RGPEyC5X49Osd2jAKurUVublVD0FHf6fm8PO5AI7CP7Kk
         Yh7xjK5GiTZCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91373E270E1;
        Thu, 20 Apr 2023 19:53:02 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.3-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230420120044.288741-1-pabeni@redhat.com>
References: <20230420120044.288741-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230420120044.288741-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc8
X-PR-Tracked-Commit-Id: 927cdea5d2095287ddd5246e5aa68eb5d68db2be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 23309d600db1abb73b77ca35db96133b7fc35959
Message-Id: <168202038258.11187.11222006627461147428.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Apr 2023 19:53:02 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 20 Apr 2023 14:00:44 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/23309d600db1abb73b77ca35db96133b7fc35959

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
