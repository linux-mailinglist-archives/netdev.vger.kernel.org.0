Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD455FE05D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiJMSH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiJMSGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4E1371B6;
        Thu, 13 Oct 2022 11:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3642B82067;
        Thu, 13 Oct 2022 18:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CEA0C4347C;
        Thu, 13 Oct 2022 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684022;
        bh=Xfixf5FyZ8J7WWGn2za5P38fsazhJelEtO3Z5tFSMn8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=D7iyImBpLmFO0rMFq9m6fZzjY97JRIKOGjxcpW9cck6wMEA7TLXVkqlLI/I/Hktdj
         Ry+fZYP54/mqrn5VKWhQnc3wYkv9nFOrfuWrN3VZABnu0o/FzXCBa2rs+SMaRBF5Am
         XFcwKvx7X7e6IjiHfGvpB+TkR54tDvaE2panJ0qTLhGvyIWyfA8/9kZBRNYR9KPJhm
         +n2k0PmD9BIV5iMLshuk7bxYMsKiK2h5UZLb7RHO6QUezyV7xHvevW8NFf5FNRCW5o
         PuxuQ60c9DeZNf2I/OJ7pxJJMxV4WrmI9EyjzwZUNV+A5aPAs3WRxENNIiqbG15mlq
         zhoiF41rVFf1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66960E29F31;
        Thu, 13 Oct 2022 18:00:22 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221013172952.338043-1-kuba@kernel.org>
References: <20221013172952.338043-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221013172952.338043-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc1
X-PR-Tracked-Commit-Id: 99df45c9e0a43b1b88dab294265e2be4a040a441
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66ae04368efbe20eb8951c9a76158f99ce672f25
Message-Id: <166568402241.7515.4743328328719228666.pr-tracker-bot@kernel.org>
Date:   Thu, 13 Oct 2022 18:00:22 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 13 Oct 2022 10:29:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66ae04368efbe20eb8951c9a76158f99ce672f25

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
