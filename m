Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33462E8D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGIDPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfGIDPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:15:03 -0400
Subject: Re: [GIT PULL] Keys: Set 3 - Keyrings namespacing for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562642102;
        bh=boTuLsU2t2PBkQzaviQYR4IqG4XrFTvJAKfUCSM+R/E=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=wnKgAxEAjs1SrLbnFRTFo8VOhIXp2h4KlIsZHZbnYiQDNEdH4oMLwKZT3Wa3ZPPHe
         656RITGkFcWftW9m9Z+wWQ0gApC0mewdpNJwwxPnV2nVessD1dLIyqpLnTYGXk5Py7
         FkaVBeu89G6xOsk7tLXwB5HSg69JP5xk+tWx4l/8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <27850.1562361644@warthog.procyon.org.uk>
References: <27850.1562361644@warthog.procyon.org.uk>
X-PR-Tracked-List-Id: <linux-nfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <27850.1562361644@warthog.procyon.org.uk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
 tags/keys-namespace-20190627
X-PR-Tracked-Commit-Id: a58946c158a040068e7c94dc1d58bbd273258068
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e12256b9a76584fa3a6da19210509d4775aee36
Message-Id: <156264210219.2709.3738517122070198743.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Jul 2019 03:15:02 +0000
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, dhowells@redhat.com,
        jmorris@namei.org, ebiederm@xmission.com, dwalsh@redhat.com,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 05 Jul 2019 22:20:44 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-namespace-20190627

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e12256b9a76584fa3a6da19210509d4775aee36

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
