Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA370485BA6
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245010AbiAEWap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245033AbiAEWao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD69C061245;
        Wed,  5 Jan 2022 14:30:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18215617D5;
        Wed,  5 Jan 2022 22:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76ADCC36AEB;
        Wed,  5 Jan 2022 22:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641421843;
        bh=D7rVRzR3AZVuq8Efw7EK9Vp3uTwYZIroaM5HSOP7Nwk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fDAainFfxLx/qvY9J/hCo8egOEt/rFu496RqUSQkt2mvCuA/jYDGaZtxLXReaZGwJ
         YPkS7rEeiitSAwkbkzMR0TAOr7wUwBx/9sXs3O4MYFPCCcQ9KGFqA/TeERe94jdf2a
         /5X/iAo5xn/0XldHz6UVQqfSx/aZrXofuaLqteL8D25+gCBfjgTsAdBG5/L9+KnfkV
         7mPJrNr+PWtBxAcrHlS1wFiKtnJYn/LUpEiWMHcdSmDQrGojZ+GfAUThZEbxpnFDIC
         4DGO3qWx37+3Q9H7UitQSBBZk7afozQ5+rcVEdZGTRwjDKyOQNbiyDhpwm58+SvVHL
         fhQzUkn51S23Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64D77F79401;
        Wed,  5 Jan 2022 22:30:43 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220105204530.3706167-1-kuba@kernel.org>
References: <20220105204530.3706167-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220105204530.3706167-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-final
X-PR-Tracked-Commit-Id: db54c12a3d7e3eedd37aa08efc9362e905f07716
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75acfdb6fd922598a408a0d864486aeb167c1a97
Message-Id: <164142184340.21549.7995944481937372488.pr-tracker-bot@kernel.org>
Date:   Wed, 05 Jan 2022 22:30:43 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed,  5 Jan 2022 12:45:30 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-final

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75acfdb6fd922598a408a0d864486aeb167c1a97

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
