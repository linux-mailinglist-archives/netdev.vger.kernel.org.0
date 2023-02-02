Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750476889B7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjBBW2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 17:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjBBW1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 17:27:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C624BCC04;
        Thu,  2 Feb 2023 14:27:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84CCBB8287A;
        Thu,  2 Feb 2023 22:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FDB2C433EF;
        Thu,  2 Feb 2023 22:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675376871;
        bh=0Ej2KFNlG/DxS7S3zbpGtHNGHa/uN7ggETKGkzSYVAQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KTzKTu4qLlu3kxr+yAAzrMGGcjdHQN7sc65ptS8I5uNVdgx9oLkdxn54YFNKykd3N
         KSuquhO3aIlQU0cF4Y+G8Y/0Hi+c0gM03LLTYOwC28AZRcGeogmlfmHnfygyc7vVFk
         c4oT2MzYmKBprOJrE1GKQb7pb32Cof8SofwOnrMlB4c9CuoY2wrlF+RLzBl2NjMM40
         hwDyrnxyCqiZ6LMG+Qohtcifzaolse5Aj7N8+Hyf5vf0sXkRU3f8jStnhmqORede+A
         E/LrVGUEfTSLMVorcevbOYZ3kNZsEFYjavvhz4bMf2EO5k8ttSeJ/D7Sw7aswpDAOj
         0Qj1Zt5yr/qig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CE29C0C40E;
        Thu,  2 Feb 2023 22:27:51 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.2-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230202213439.3065404-1-kuba@kernel.org>
References: <20230202213439.3065404-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230202213439.3065404-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc7
X-PR-Tracked-Commit-Id: 9983a2c986534db004b50d95b7fe64bb9b925dca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: edb9b8f380c3413bf783475279b1a941c7e5cec1
Message-Id: <167537687111.10932.13372148402364923125.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Feb 2023 22:27:51 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  2 Feb 2023 13:34:39 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/edb9b8f380c3413bf783475279b1a941c7e5cec1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
