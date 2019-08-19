Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF51894BF4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfHSRpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfHSRpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:45:08 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566236707;
        bh=2V8Op1akcL6TNkgdkBeR8bU6FujX1ZM1fPLgSogm8Qo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=sKHdiwLQHEY8iUB10DW8Kquitdv2r3fOO7n5kTfDp1jMUfKDFv6/IpXW6NhdABXsw
         UGMFa9/NVsC9Bor4De+EGWPKIpiLhPO3crI5Mmw+6dZhuJVx1rIjPIBi1N3mwUydMB
         NTeT8IirJIrt1s4QrwVBlJv21h0z+rphFxej8Y30=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190818.194615.2174476213333990592.davem@davemloft.net>
References: <20190818.194615.2174476213333990592.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190818.194615.2174476213333990592.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: cfef46d692efd852a0da6803f920cc756eea2855
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 06821504fd47a5e5b641aeeb638a0ae10a216ef8
Message-Id: <156623670766.9756.14496540938783784333.pr-tracker-bot@kernel.org>
Date:   Mon, 19 Aug 2019 17:45:07 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 18 Aug 2019 19:46:15 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/06821504fd47a5e5b641aeeb638a0ae10a216ef8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
