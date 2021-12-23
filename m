Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121B147E7C8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244758AbhLWSvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbhLWSvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:51:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFC0C061401;
        Thu, 23 Dec 2021 10:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27029B821C5;
        Thu, 23 Dec 2021 18:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF040C36AE5;
        Thu, 23 Dec 2021 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640285476;
        bh=Tgl+MKDk+85l8sVmigHob+brGWpqOkWI/vDT+BRJo6Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=R2as4zdcgeuJBNrpsjamXeOjQr682WHpxhMQeBIWj2v/gd1C9e/hghgrpU9uoTebT
         Dr1Sl5hT9z9k3ZLZRbLKWFENpmhTMQ/uyiqutG1kRAtsipFP09V/5YiBEe2Q/OPI+t
         JZhpq2L29U9PB6u+0ekVTrpDQjGzr7uB1HkdiJWG3VbwKDtC7wHmYOFjg1vnT84Mhf
         4oytUY8knLkIMLlO+sW+QmPjzY/Xn4x5tXRA/ad2oUOOf2J8Lj/MRI95OpYkIus/bx
         9SdiIEqv0bPZQCNaQzpVYSFNLriw2w3hadJeniXcEejF85fLfDwmVujT6EH6mFYZ5v
         vEPiP1uRg/Xug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF3D0EAC060;
        Thu, 23 Dec 2021 18:51:16 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211223184316.3916057-1-kuba@kernel.org>
References: <20211223184316.3916057-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211223184316.3916057-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc7
X-PR-Tracked-Commit-Id: 391e5975c0208ce3739587b33eba08be3e473d79
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 76657eaef4a759e695eb1883d4f1d9af1e4ff9a8
Message-Id: <164028547664.17442.5249424011037739118.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Dec 2021 18:51:16 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pablo@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 23 Dec 2021 10:43:16 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/76657eaef4a759e695eb1883d4f1d9af1e4ff9a8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
