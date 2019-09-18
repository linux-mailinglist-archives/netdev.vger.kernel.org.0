Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E280CB6D04
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388866AbfIRTzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388204AbfIRTz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 15:55:27 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568836526;
        bh=Ktt/nlqD6vDYLc7TW+CH0PhtRNs9bOOVzv0fjCiwGe8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eLQx/WwRvggMBhKhP5s3p7WlbFQFi1vVpmwolWaNQ20t4RF++eYKSBLPj/e6BQEMU
         9WJj9a1l0aXCQ3tc5MVKlUR60hWgA4SyB4SqU0cOSxTXQFrLY1dlZyrZW2ZyrRVXeR
         a3mknmD72+LEpQov1S04NqFfQ8PbH0aVrUp//lM4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190918.003903.2143222297141990229.davem@davemloft.net>
References: <20190918.003903.2143222297141990229.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190918.003903.2143222297141990229.davem@davemloft.net>
X-PR-Tracked-Remote: (unable to parse the git remote)
X-PR-Tracked-Commit-Id: 1bab8d4c488be22d57f9dd09968c90a0ddc413bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81160dda9a7aad13c04e78bb2cfd3c4630e3afab
Message-Id: <156883652685.14539.17509162451547564964.pr-tracker-bot@kernel.org>
Date:   Wed, 18 Sep 2019 19:55:26 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 18 Sep 2019 00:39:03 +0200 (CEST):

> (unable to parse the git remote)

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81160dda9a7aad13c04e78bb2cfd3c4630e3afab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
