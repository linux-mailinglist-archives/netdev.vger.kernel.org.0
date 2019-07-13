Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB86774C
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 02:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGMAkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 20:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfGMAkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 20:40:14 -0400
Subject: Re: [GIT PULL] 9p updates for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562978413;
        bh=N1eN8QH+7+JfYNNJ4yh+cOKi0l7F+Trf3hII8g1oIBg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DEyjTsKroaYPyBZpS5gupT9I0yQTFF2uDYIuKMAkT2Go+oJn4f6oH+lqgo8SqhowS
         YGzL0MJrcPOAfiOf4JeiEqsuvb8H9Djp7DUiSDsuhnDvcLDDOpq9Mzzqw+j6YTl+oD
         /4T3w8QDFtM1DBCbTPn5XdaFUJB4HzTGaLxwqOb0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190712080446.GA19400@nautica>
References: <20190712080446.GA19400@nautica>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190712080446.GA19400@nautica>
X-PR-Tracked-Remote: git://github.com/martinetd/linux tags/9p-for-5.3
X-PR-Tracked-Commit-Id: 80a316ff16276b36d0392a8f8b2f63259857ae98
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 23bbbf5c1fb3ddf104c2ddbda4cc24ebe53a3453
Message-Id: <156297841376.30815.4748359987826787756.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Jul 2019 00:40:13 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 12 Jul 2019 10:04:46 +0200:

> git://github.com/martinetd/linux tags/9p-for-5.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/23bbbf5c1fb3ddf104c2ddbda4cc24ebe53a3453

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
