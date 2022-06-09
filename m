Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ECE5454DA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343813AbiFITWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiFITWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:22:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA82D1E3F0;
        Thu,  9 Jun 2022 12:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16F75CE317B;
        Thu,  9 Jun 2022 19:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29653C34114;
        Thu,  9 Jun 2022 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654802561;
        bh=RoX0YbThUxAAH3F3KKjMx4Makt1ywYwX3HaOngRAY0w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fe+dhFpK8CYuk/qkVqVOICwvDaeSoqwb4s428Sj5RXdQbgb0SAEzwOgZ8IeWfcjWX
         HcKLcQbH/carGuIvTkNGayIhUGSQOr4ByQlci0/9JN8yqfmUMuJymp38kpmwMyVFM6
         Unm85+0uyBuzIDkL7XThBjH24sTvCJ1K5N3rpXl2ZLvXsBJ+8Hf4yUvIQ+ezfZVOsX
         pGuyjuPcFyp0MXZyxrhmaijdOXjD7+pZrymty5fkh501QMfFNDDQBPHRdpvINrPrVq
         HtToYm+IWhTVt9xHo8k1obEj8SPAibmAqOk8GUTHQQkSQ4rsBXcNbj/a+5nBctjT/+
         3MWHM0nd9/ysw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18B78E737ED;
        Thu,  9 Jun 2022 19:22:41 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220609103202.21091-1-pabeni@redhat.com>
References: <20220609103202.21091-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220609103202.21091-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc2
X-PR-Tracked-Commit-Id: 647df0d41b6bd8f4987dde6e8d8d0aba5b082985
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 825464e79db4aac936e0fdae62cdfb7546d0028f
Message-Id: <165480256109.32717.3386036457616465104.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Jun 2022 19:22:41 +0000
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

The pull request you sent on Thu,  9 Jun 2022 12:32:02 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/825464e79db4aac936e0fdae62cdfb7546d0028f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
