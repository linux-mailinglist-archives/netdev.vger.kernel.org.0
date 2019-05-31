Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8214A307BE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEaEZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 00:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbfEaEZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 00:25:13 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559276712;
        bh=Jhr3Z+JGuyGl2UI6nWM84k3C42JQVsxh0nHDWMDj7VU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ixfHISe3kCOgH/D41xKmpqW8MoW0/ZzzXSG/pb40BU2MxIyadqxbCUpDjkJRAZPft
         6t/I8CyC6COt9XtJPTGV9FtYpZ3gZpTVgbEh1oDyPV+3bgO1OCdjJfxZds9mZL4Tcz
         MP/x++3rmm0jJnRMFg3/TfmAYjvrfn9we0sLlQ+Q=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190530.160506.886914005164704233.davem@davemloft.net>
References: <20190530.160506.886914005164704233.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190530.160506.886914005164704233.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 100f6d8e09905c59be45b6316f8f369c0be1b2d8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 036e34310931e64ce4f1edead435708cd517db10
Message-Id: <155927671287.23225.3722089018670088061.pr-tracker-bot@kernel.org>
Date:   Fri, 31 May 2019 04:25:12 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 30 May 2019 16:05:06 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/036e34310931e64ce4f1edead435708cd517db10

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
