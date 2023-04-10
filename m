Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D856DCCB8
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDJVVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDJVVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF0C1BF9;
        Mon, 10 Apr 2023 14:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E22D61857;
        Mon, 10 Apr 2023 21:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E277C4339C;
        Mon, 10 Apr 2023 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681161675;
        bh=5uHpTGKCawHrRFBQaM3eJGNJSmeFsgJtnxEwDUaBI1o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UOOG+i4qjNvmCDpYaSrosx8iuwsIR7dlmva40/7n8xfr3NhlT+5hTTZFLI7+f/yyh
         hqbncTZi6ha8RRpvRWBr0bQLnUetahppj/17PT4O8/9Z0Oyz0i/90x1TNgwqUWr6lf
         zfQFYwmmbRAUBFGCSUHbBuKQr5qmYBwdypvy83uCZAsOeLqueVWnVGgsDWbYI9uMWL
         CWWCqBwq+6q7pl1jW/WoZr1RAfrg4K6OH3VETbm/0hPUl5aJz7mCi+UaK03kL+m1CQ
         DUn5Q04LxQbJADcJYG2EcTbrHKoNrCwz2JJB62bNOw47YkEc/o8aUQlVVceWHIPZnS
         PQphKQ9+lMB1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 590C0C395C5;
        Mon, 10 Apr 2023 21:21:15 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230410055906-mutt-send-email-mst@kernel.org>
References: <20230410055906-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230410055906-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 9da667e50c7e62266f3c2f8ad57b32fca40716b1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dfc191544864601a056ce7691d600e70d60d3ca1
Message-Id: <168116167536.31176.1516094737036591920.pr-tracker-bot@kernel.org>
Date:   Mon, 10 Apr 2023 21:21:15 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.fomichev@wdc.com, elic@nvidia.com, jasowang@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, sgarzare@redhat.com,
        stable@vger.kernel.org, zwisler@chromium.org, zwisler@google.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 10 Apr 2023 05:59:06 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dfc191544864601a056ce7691d600e70d60d3ca1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
