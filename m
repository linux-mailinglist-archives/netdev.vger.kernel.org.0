Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89342ECC96
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfKBBKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfKBBKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 21:10:05 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572657004;
        bh=ZYV85FHuO1FdPrybf86qqk8CVzLbbZiKCSTfisWt48c=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SQMqRfCov5NVt87mCr+ounSt0E8cGcv5oeFDKG8tDM/F27EusUSuu+3XAG5XXPtw0
         /5mdnBDfWbrhq6/5IjUSCrVo3mLm/9Aq/oXNhZkDOt6eM5xrCj9cwZz2aoPsvCNwc+
         4In9GIqGcFDvtHleccW3PlBTWC4I2j1bxRg8SgrU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191101.165029.1804551650613208564.davem@davemloft.net>
References: <20191101.165029.1804551650613208564.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191101.165029.1804551650613208564.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: aeb1b85c340c54dc1d68ff96b02d439d6a4f7150
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1204c70d9dcba31164f78ad5d8c88c42335d51f8
Message-Id: <157265700474.2997.4709703528603617408.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Nov 2019 01:10:04 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 01 Nov 2019 16:50:29 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1204c70d9dcba31164f78ad5d8c88c42335d51f8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
