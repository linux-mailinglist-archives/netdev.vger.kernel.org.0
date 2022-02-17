Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD804BA9FD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245386AbiBQTkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbiBQTkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6E24199B;
        Thu, 17 Feb 2022 11:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2CA6B82408;
        Thu, 17 Feb 2022 19:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79E1AC340EB;
        Thu, 17 Feb 2022 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645126795;
        bh=H4CRrIHUr+9grCrZynvkqNKJPcG/NF6xXciAhrkK9GY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iXyIgppQTo+uGa2fb3L5jnOpnUukI/oml7RAuEgSB+DZyHuYRwsdZ7cvUwMHsk0Yq
         OlU6rdgnMQXD226ElcCNM6exGrk8z1oEjDUIHXvmKYX8SU3rkuVcZLB9Dw/vqZ8tj4
         IBlv0TvD00TzJDj9JnRqoA3WDxVin1fa98/Dgk9Pic9uLUwmBLY85o1F704pmyJBtB
         CaoguzT12wST4ZJwOccV1QjgBJL212inXqe6epipZZKGFJNxszv5KC8mKUVv7nZrpd
         +0NDM7WpTEpPsWZKChuwA9ybdA3q8DA7DMX35fog7uLamcGmkHvyjrDq1qFoiTA16d
         wKRRYavQwX+Vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68DE1E6D446;
        Thu, 17 Feb 2022 19:39:55 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220217190432.2253930-1-kuba@kernel.org>
References: <20220217190432.2253930-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220217190432.2253930-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc5
X-PR-Tracked-Commit-Id: a6ab75cec1e461f8a35559054c146c21428430b8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b97cae315cafd7debf3601f88621e2aa8956ef3
Message-Id: <164512679542.3447.12316270098095414790.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Feb 2022 19:39:55 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 17 Feb 2022 11:04:32 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b97cae315cafd7debf3601f88621e2aa8956ef3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
