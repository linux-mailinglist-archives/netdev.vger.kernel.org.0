Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1334DCF8B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiCQUmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiCQUmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:42:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C187B7C71;
        Thu, 17 Mar 2022 13:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B54E26195C;
        Thu, 17 Mar 2022 20:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 240CBC340EE;
        Thu, 17 Mar 2022 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647549658;
        bh=wFf3ln9SVIrmcwr2/G1eIYGKQ1hNcIQMtT4l7jY0d7k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UkHgbiEDH2I+ILBjzn+mN8OCI71jfC2/jmG/XNRQkDDYEaUE3USrFnrZgIIJliOLw
         Y24tQicKRcNuZYHcz1dAhdiSfftaARanPbemctMKtmvgz4kDXgMUJBg7b035W9Fm5B
         0tmutc8JWAdkCpfcZzQsgSq+ZK2vJgkTG//KmdxqV+dXBPLrd9VLUfcOKswfh5gQuX
         I9DJW3oIxhRmWMzy2T0c4YqM6ltIy9w2QHcBHkXvIDED0cDpyKF2VKNcTLvbqTfC0t
         IKYpbTb6I7Q1nwBXQyHgvJLi/HYjgccRS0DnyIpXxt9mD7gPYpxXFKB52SzrMwLXXj
         /omoRbB811+6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AC33EAC09C;
        Thu, 17 Mar 2022 20:40:58 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220317181627.487668-1-kuba@kernel.org>
References: <20220317181627.487668-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220317181627.487668-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-final
X-PR-Tracked-Commit-Id: b04683ff8f0823b869c219c78ba0d974bddea0b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 551acdc3c3d2b6bc97f11e31dcf960bc36343bfc
Message-Id: <164754965803.20112.18331708338874405177.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Mar 2022 20:40:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 17 Mar 2022 11:16:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-final

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/551acdc3c3d2b6bc97f11e31dcf960bc36343bfc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
