Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E615F494A5A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbiATJIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiATJIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7052C061574;
        Thu, 20 Jan 2022 01:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC61B81D14;
        Thu, 20 Jan 2022 09:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 611FBC340E0;
        Thu, 20 Jan 2022 09:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642669707;
        bh=Ihaq100gCgC3qd3GwgMReAb8+0jwcjEbXu7rdkTJtc0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CNT1reJdThCtvvwMkvZ+lUnEPa35MUYjYPZoLYTjUd24u0HuwiD9ghv/qrvqaJIO4
         KcXPgrbuphXsUBw1dTqts6qsCbijv0czWGwVnrlWgIc1VPbOHHZJFcTFu3wl9Mo0Am
         WOOjcAMAWzEx7sBkPaTt9op2IW52/i42X+fUSCP1/IRt8Vw7stK/46yGIx8tBSZUJy
         C6hxgYtQT2q1GGOy2jt0CqsCkqmEkGcvk7Lvuy9IBDLNNmLOMGxaP9VQ6549t7Z1Cb
         i6sOSMEBHzCTfMtlmgpFTbkePoA01Uv5pbZTnW+MFOQVUeX6T8fLIQPIIQr1hP31l3
         JagJRq3IOSUsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5145EF60798;
        Thu, 20 Jan 2022 09:08:27 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220119182611.400333-1-kuba@kernel.org>
References: <20220119182611.400333-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220119182611.400333-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc1
X-PR-Tracked-Commit-Id: ff9fc0a31d85fcf0011eb4bc4ecaf47d3cc9e21c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fa2e1ba3e9e39072fa7a6a9d11ac432c505b4ac7
Message-Id: <164266970732.26345.11726794577930380253.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Jan 2022 09:08:27 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 19 Jan 2022 10:26:11 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fa2e1ba3e9e39072fa7a6a9d11ac432c505b4ac7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
